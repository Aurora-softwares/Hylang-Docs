param([Parameter(Mandatory = $true)][string]$SourceDir)
$ErrorActionPreference = 'Stop'
$work = Join-Path $env:RUNNER_TEMP ([IO.Path]::GetRandomFileName())
$originalLocalAppData = $env:LOCALAPPDATA
$originalUserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
New-Item -ItemType Directory -Path $work | Out-Null
try {
    $version = 'alpha-0.0.3'
    $name = "hydrogen-$version-windows-x86_64"
    $stageParent = Join-Path $work 'staging'
    $stage = Join-Path $stageParent $name
    New-Item -ItemType Directory -Path (Join-Path $stage 'bin') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $stage 'libexec') -Force | Out-Null
    '@echo off' | Set-Content -LiteralPath (Join-Path $stage 'bin\hy.cmd') -Encoding Ascii
    Copy-Item -LiteralPath (Join-Path $env:SystemRoot 'System32\whoami.exe') -Destination (Join-Path $stage 'libexec\hy-core.exe')
    '# Fixture only' | Set-Content -LiteralPath (Join-Path $stage 'libexec\hy-maintenance.ps1') -Encoding Ascii
    'Hydrogen fixture' | Set-Content -LiteralPath (Join-Path $stage 'README.md') -Encoding Ascii
    'MIT fixture' | Set-Content -LiteralPath (Join-Path $stage 'LICENSE') -Encoding Ascii
    @("Hydrogen release: $version", 'Platform: windows-x86_64') |
        Set-Content -LiteralPath (Join-Path $stage 'BUILD-INFO.txt') -Encoding Ascii
    $files = @('bin/hy.cmd', 'libexec/hy-core.exe', 'libexec/hy-maintenance.ps1',
        'BUILD-INFO.txt', 'README.md', 'LICENSE')
    $sums = foreach ($file in $files) {
        $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $stage $file)).Hash.ToLowerInvariant()
        "$hash  $file"
    }
    $sums | Set-Content -LiteralPath (Join-Path $stage 'SHA256SUMS') -Encoding Ascii
    @('hydrogen-install-manifest-v1') + $files + @('SHA256SUMS', 'INSTALL-MANIFEST') |
        Set-Content -LiteralPath (Join-Path $stage 'INSTALL-MANIFEST') -Encoding Ascii
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = Join-Path $work "$name.zip"
    [IO.Compression.ZipFile]::CreateFromDirectory($stageParent, $archive)
    $digest = (Get-FileHash -Algorithm SHA256 $archive).Hash.ToLowerInvariant()
    "$digest  $name.zip" | Set-Content -LiteralPath "$archive.sha256" -Encoding Ascii
    $env:MOCK_ARCHIVE = $archive
    $env:MOCK_SIDECAR = "$archive.sha256"
    $env:MOCK_DIGEST = $digest
    $env:LOCALAPPDATA = $work
    $env:HYDROGEN_CHANNEL = 'alpha'
    $env:PROCESSOR_ARCHITECTURE = 'AMD64'
    $env:MOCK_INSTALLER = Join-Path $SourceDir 'public\install.ps1'
    $wrapper = Join-Path $work 'run-installer.ps1'
    @'
function Invoke-RestMethod {
    param($Uri, $Headers, $TimeoutSec)
    $name = 'hydrogen-alpha-0.0.3-windows-x86_64.zip'
    $prefix = 'https://github.com/Aurora-softwares/Hylang-Compiler/releases/download/alpha-0.0.3/'
    return [pscustomobject]@{
        tag_name = 'alpha-0.0.3'; draft = $false; prerelease = $true
        assets = @(
            [pscustomobject]@{ name = $name; digest = "sha256:$env:MOCK_DIGEST"; browser_download_url = "$prefix$name" },
            [pscustomobject]@{ name = "$name.sha256"; browser_download_url = "$prefix$name.sha256" }
        )
    }
}
function curl.exe {
    $outputIndex = [Array]::IndexOf($args, '--output')
    if ($outputIndex -lt 0) { throw 'Missing curl output argument' }
    $url = $args[$args.Count - 1]
    if ($url.EndsWith('.zip.sha256')) { $source = $env:MOCK_SIDECAR }
    elseif ($url.EndsWith('.zip')) { $source = $env:MOCK_ARCHIVE }
    else { throw 'Unexpected download URL' }
    Copy-Item -LiteralPath $source -Destination $args[$outputIndex + 1]
    $global:LASTEXITCODE = 0
}
& $env:MOCK_INSTALLER
'@ | Set-Content -LiteralPath $wrapper -Encoding UTF8
    $output = & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $wrapper 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0 -or $output -notmatch 'Installed Hydrogen alpha-0.0.3') {
        throw "Windows installer failed: $output"
    }
    $root = Join-Path $work 'Hydrogen'
    if ((Get-Content (Join-Path $root 'BUILD-INFO.txt') -First 1) -cne
        'Hydrogen release: alpha-0.0.3') { throw 'Windows installer did not activate release' }
    if (-not (Test-Path -LiteralPath (Join-Path $root 'bin\hy.cmd'))) {
        throw 'Windows launcher was not installed'
    }
    Write-Output 'Windows website installer verified against a digest-checked fixture'
} finally {
    [Environment]::SetEnvironmentVariable('Path', $originalUserPath, 'User')
    $env:LOCALAPPDATA = $originalLocalAppData
    Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
}
