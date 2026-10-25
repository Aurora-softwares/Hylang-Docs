# Install a published, manifest-bearing Hydrogen release for Windows x64.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
try {
    if (-not [Environment]::Is64BitOperatingSystem -or $env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
        throw 'This installer requires Windows x64.'
    }
    if (-not $env:LOCALAPPDATA) { throw 'LOCALAPPDATA is unavailable.' }
    $channel = if ($env:HYDROGEN_CHANNEL) { $env:HYDROGEN_CHANNEL } else { 'stable' }
    if ($channel -notin @('stable', 'alpha', 'beta', 'rc')) {
        throw 'HYDROGEN_CHANNEL must be stable, alpha, beta, or rc.'
    }
    $root = Join-Path $env:LOCALAPPDATA 'Hydrogen'
    if (Test-Path -LiteralPath $root) { throw "An installation already exists at $root; use hy update." }
    $parent = Split-Path -Parent $root
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    $work = Join-Path $parent ([IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $work | Out-Null
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $headers = @{ Accept = 'application/vnd.github+json'; 'User-Agent' = 'Hydrogen-installer' }
        $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/Aurora-softwares/Hylang-Compiler/releases?per_page=100' -Headers $headers -TimeoutSec 30
        $eligible = @($releases | Where-Object {
            -not $_.draft -and $_.tag_name -match '^[A-Za-z0-9][A-Za-z0-9._-]*$' -and
            $(if ($channel -eq 'stable') {
                -not $_.prerelease -and $_.tag_name -notmatch '^(alpha|beta|rc)-'
            } else { $_.tag_name.StartsWith("$channel-") })
        })
        if ($eligible.Count -eq 0) { throw "No published $channel release is available." }
        $release = $eligible | Sort-Object -Property {
            $numeric = $_.tag_name -replace '^(alpha|beta|rc)-', ''
            try { [version]$numeric } catch { [version]'0.0' }
        } -Descending | Select-Object -First 1
        $version = [string]$release.tag_name
        $archiveName = "hydrogen-$version-windows-x86_64.zip"
        $archiveAsset = @($release.assets | Where-Object name -EQ $archiveName)
        $checksumAsset = @($release.assets | Where-Object name -EQ "$archiveName.sha256")
        if ($archiveAsset.Count -ne 1 -or $checksumAsset.Count -ne 1) {
            throw "Release $version has no installer-compatible Windows archive and checksum."
        }
        $digest = [string]$archiveAsset[0].digest
        if ($digest -cnotmatch '^sha256:[0-9a-f]{64}$') { throw 'Release asset has no SHA-256 digest.' }
        $prefix = 'https://github.com/Aurora-softwares/Hylang-Compiler/releases/download/'
        $archiveUrl = [string]$archiveAsset[0].browser_download_url
        $checksumUrl = [string]$checksumAsset[0].browser_download_url
        if (-not $archiveUrl.StartsWith($prefix) -or -not $checksumUrl.StartsWith($prefix)) {
            throw 'Unexpected release asset URL.'
        }
        $archive = Join-Path $work $archiveName
        $checksum = "$archive.sha256"
        & curl.exe --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --max-time 180 --output $archive $archiveUrl
        if ($LASTEXITCODE -ne 0) { throw 'Archive download failed.' }
        & curl.exe --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --max-time 30 --output $checksum $checksumUrl
        if ($LASTEXITCODE -ne 0) { throw 'Checksum download failed.' }
        $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $archive).Hash.ToLowerInvariant()
        if ("sha256:$actual" -cne $digest) { throw 'GitHub release digest mismatch.' }
        if ((Get-Content -LiteralPath $checksum -Raw).TrimEnd("`r", "`n") -cne "$actual  $archiveName") {
            throw 'Release checksum mismatch.'
        }
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $dirname = "hydrogen-$version-windows-x86_64"
        $allowed = @(
            "$dirname/", "$dirname/bin/", "$dirname/libexec/", "$dirname/bin/hy.cmd",
            "$dirname/libexec/hy-core.exe", "$dirname/libexec/hy-maintenance.ps1",
            "$dirname/BUILD-INFO.txt", "$dirname/README.md", "$dirname/LICENSE",
            "$dirname/SHA256SUMS", "$dirname/INSTALL-MANIFEST"
        )
        $zip = [IO.Compression.ZipFile]::OpenRead($archive)
        $seen = @{}
        try {
            foreach ($entry in $zip.Entries) {
                if ($entry.FullName -cnotin $allowed) { throw "Unexpected archive member: $($entry.FullName)" }
                if ($seen.ContainsKey($entry.FullName)) { throw "Repeated archive member: $($entry.FullName)" }
                $seen[$entry.FullName] = $true
                $unixType = ($entry.ExternalAttributes -shr 16) -band 0xF000
                if ($unixType -eq 0xA000) { throw 'Archive contains a symbolic link.' }
            }
        } finally { $zip.Dispose() }
        [IO.Compression.ZipFile]::ExtractToDirectory($archive, $work)
        $stage = Join-Path $work $dirname
        $required = @('bin/hy.cmd', 'libexec/hy-core.exe', 'libexec/hy-maintenance.ps1',
            'BUILD-INFO.txt', 'README.md', 'LICENSE', 'SHA256SUMS', 'INSTALL-MANIFEST')
        $manifest = Get-Content -LiteralPath (Join-Path $stage 'INSTALL-MANIFEST')
        if ($manifest[0] -cne 'hydrogen-install-manifest-v1') { throw 'Unknown installation manifest.' }
        if ($manifest.Count -ne ($required.Count + 1)) { throw 'Unknown installation manifest file count.' }
        foreach ($file in $required) {
            $path = Join-Path $stage $file
            if (-not (Test-Path -LiteralPath $path -PathType Leaf) -or
                @($manifest | Where-Object { $_ -ceq $file }).Count -ne 1) {
                throw "Release file missing or unowned: $file"
            }
        }
        foreach ($item in (Get-ChildItem -LiteralPath $stage -Force -Recurse)) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Release contains a link: $($item.FullName)"
            }
        }
        $buildInfo = Get-Content -LiteralPath (Join-Path $stage 'BUILD-INFO.txt')
        if ("Hydrogen release: $version" -cnotin $buildInfo) { throw 'Release version mismatch.' }
        foreach ($line in (Get-Content -LiteralPath (Join-Path $stage 'SHA256SUMS'))) {
            if ($line -cnotmatch '^([0-9a-f]{64})  ([A-Za-z0-9./_-]+)$') { throw 'Invalid release checksum list.' }
            $expectedHash = $Matches[1]
            $file = $Matches[2]
            if ($file -cnotin $manifest) { throw "Checksum file is not in manifest: $file" }
            $fileHash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $stage $file)).Hash.ToLowerInvariant()
            if ($fileHash -cne $expectedHash) { throw "Internal checksum mismatch: $file" }
        }
        Move-Item -LiteralPath $stage -Destination $root
        $bin = Join-Path $root 'bin'
        $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        try {
            if ($bin -notin @($userPath -split ';')) {
                $newPath = if ($userPath) { "$userPath;$bin" } else { $bin }
                [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
            }
        } catch {
            Remove-Item -LiteralPath $root -Recurse -Force
            throw
        }
        Write-Output "Installed Hydrogen $version at $root"
        Write-Output 'Open a new terminal to use hy.'
    } finally {
        if (Test-Path -LiteralPath $work) { Remove-Item -LiteralPath $work -Recurse -Force }
    }
} catch {
    Write-Error "Hydrogen install: $($_.Exception.Message)"
    exit 1
}
