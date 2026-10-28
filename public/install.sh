#!/usr/bin/env bash
# Install a published, manifest-bearing Hydrogen release for Linux or macOS x64.
set -euo pipefail
umask 077

fail() { printf 'Hydrogen install: %s\n' "$*" >&2; exit 1; }
for tool in curl jq tar mktemp sort; do
    command -v "$tool" >/dev/null 2>&1 || fail "required command missing: $tool"
done
case $(uname -s):$(uname -m) in
    Linux:x86_64) platform=linux-x86_64; hash_command=sha256sum ;;
    Darwin:x86_64) platform=macos-x86_64; hash_command=shasum ;;
    Darwin:arm64)
        /usr/bin/arch -x86_64 /usr/bin/true >/dev/null 2>&1 || fail 'Rosetta 2 is required for the macOS x64 compiler'
        platform=macos-x86_64; hash_command=shasum ;;
    *) fail 'this installer requires Linux or macOS x86-64' ;;
esac
command -v "$hash_command" >/dev/null 2>&1 || fail "required command missing: $hash_command"
hash_file() {
    if [[ $platform == macos-x86_64 ]]; then shasum -a 256 "$1" | cut -d' ' -f1
    else sha256sum "$1" | cut -d' ' -f1; fi
}
verify_internal() {
    if [[ $platform == macos-x86_64 ]]; then
        (cd "$1" && shasum -a 256 -c SHA256SUMS >/dev/null)
    else (cd "$1" && sha256sum -c --status SHA256SUMS); fi
}
version_sort() {
    if printf '1.2\n1.10\n' | sort -V >/dev/null 2>&1; then sort -V
    else awk '{ original=$0; sub(/^(alpha|beta|rc)-/, ""); split($0, n, /[.-]/); printf "%09d.%09d.%09d.%s\t%s\n", n[1], n[2], n[3], n[4], original }' | sort | cut -f2-; fi
}
channel=${HYDROGEN_CHANNEL:-stable}
case $channel in stable|alpha|beta|rc) ;; *) fail 'HYDROGEN_CHANNEL must be stable, alpha, beta, or rc' ;; esac
[[ -n ${HOME:-} && -d $HOME ]] || fail 'HOME is not a directory'
install_parent="$HOME/.local/share"
install_root="$install_parent/hydrogen"
launcher="$HOME/.local/bin/hy"
[[ ! -e $install_root && ! -L $install_root ]] || fail "an installation already exists at $install_root; use hy update"
[[ ! -e $launcher && ! -L $launcher ]] || fail "a launcher already exists at $launcher"
mkdir -p -- "$install_parent" "$HOME/.local/bin"
work=$(mktemp -d -- "$install_parent/.hydrogen-install.XXXXXXXX") || fail 'cannot create staging directory'
trap 'rm -rf -- "$work"' EXIT

api='https://api.github.com/repos/Aurora-softwares/Hylang-Compiler/releases?per_page=100'
curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --tlsv1.2 --max-time 30 -H 'Accept: application/vnd.github+json' \
    --output "$work/releases.json" "$api" || fail 'cannot query official releases'
if [[ $channel == stable ]]; then
    version=$(jq -r '[.[] | select(.draft == false and .prerelease == false)
        | .tag_name | select(test("^(alpha|beta|rc)-") | not)] | .[]' "$work/releases.json" |
        LC_ALL=C version_sort | tail -n1)
else
    version=$(jq -r --arg prefix "$channel-" '[.[] | select(.draft == false)
        | .tag_name | select(startswith($prefix))] | .[]' "$work/releases.json" |
        LC_ALL=C version_sort | tail -n1)
fi
[[ $version =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] || fail "no published $channel release is available"
archive="hydrogen-${version}-${platform}.tar.gz"
release=$(jq -cer --arg version "$version" '.[] | select(.tag_name == $version and .draft == false)' "$work/releases.json") ||
    fail 'release metadata is inconsistent'
asset_url=$(jq -er --arg name "$archive" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$release") ||
    fail "release $version does not include the installer-compatible ${platform} archive"
asset_digest=$(jq -er --arg name "$archive" '.assets[] | select(.name == $name) | .digest' <<< "$release") ||
    fail 'release asset has no SHA-256 digest'
checksum_url=$(jq -er --arg name "$archive.sha256" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$release") ||
    fail 'release checksum asset is missing'
[[ $asset_url == "https://github.com/Aurora-softwares/Hylang-Compiler/releases/download/"* &&
   $checksum_url == "https://github.com/Aurora-softwares/Hylang-Compiler/releases/download/"* &&
   $asset_digest =~ ^sha256:[0-9a-f]{64}$ ]] || fail 'unexpected release asset metadata'
curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --tlsv1.2 --max-time 180 --output "$work/$archive" "$asset_url" || fail 'archive download failed'
curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
    --tlsv1.2 --max-time 30 --output "$work/$archive.sha256" "$checksum_url" || fail 'checksum download failed'
actual=$(hash_file "$work/$archive")
[[ $asset_digest == "sha256:$actual" ]] || fail 'GitHub release digest mismatch'
[[ $(cat "$work/$archive.sha256") == "$actual  $archive" ]] || fail 'release checksum mismatch'

dirname="hydrogen-${version}-${platform}"
allowed=("$dirname" "$dirname/bin" "$dirname/libexec" "$dirname/bin/hy"
    "$dirname/libexec/hy-core" "$dirname/libexec/hy-maintenance"
    "$dirname/BUILD-INFO.txt" "$dirname/README.md" "$dirname/LICENSE"
    "$dirname/SHA256SUMS" "$dirname/INSTALL-MANIFEST")
while IFS= read -r member; do
    member=${member%/}
    found=false
    for item in "${allowed[@]}"; do [[ $member != "$item" ]] || found=true; done
    $found || fail "unexpected archive member: $member"
done < <(tar -tzf "$work/$archive")
while IFS= read -r entry; do
    case ${entry:0:1} in -|d) ;; *) fail 'archive contains a link or special file' ;; esac
done < <(tar -tvzf "$work/$archive")
tar -xzf "$work/$archive" -C "$work" || fail 'cannot unpack verified archive'
stage="$work/$dirname"
for file in bin/hy libexec/hy-core libexec/hy-maintenance BUILD-INFO.txt README.md SHA256SUMS INSTALL-MANIFEST; do
    [[ -f $stage/$file && ! -L $stage/$file ]] || fail "release file missing: $file"
    grep -Fxq -- "$file" "$stage/INSTALL-MANIFEST" || fail "unowned release file: $file"
done
[[ $(head -n1 "$stage/INSTALL-MANIFEST") == hydrogen-install-manifest-v1 ]] || fail 'unknown installation manifest'
[[ $(sed -n 's/^Hydrogen release: //p' "$stage/BUILD-INFO.txt") == "$version" ]] || fail 'release version mismatch'
[[ $(sed -n 's/^Platform: //p' "$stage/BUILD-INFO.txt") == "$platform" ]] || fail 'release platform mismatch'
verify_internal "$stage" || fail 'internal release checksum mismatch'
[[ -x $stage/bin/hy && -x $stage/libexec/hy-core ]] || fail 'release binaries are not executable'
mv -- "$stage" "$install_root" || fail 'cannot activate release'
if ! ln -s -- "$install_root/bin/hy" "$launcher"; then
    mv -- "$install_root" "$stage" || true
    fail 'cannot create the user launcher'
fi
printf 'Installed Hydrogen %s at %s\n' "$version" "$install_root"
printf 'Add %s to PATH if it is not already present.\n' "$HOME/.local/bin"
