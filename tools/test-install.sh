#!/usr/bin/env bash
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
case $(uname -s) in Linux) platform=linux-x86_64 ;; Darwin) platform=macos-x86_64 ;; *) exit 1 ;; esac
name="hydrogen-alpha-0.1.0-${platform}"
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$work/fixture/$name/bin" \
    "$work/fixture/$name/libexec" "$work/home" "$work/mock-bin"
stage="$work/fixture/$name"
printf '#!/bin/sh\nexit 0\n' > "$stage/bin/hy"
printf '#!/bin/sh\nexit 0\n' > "$stage/libexec/hy-core"
printf '#!/bin/sh\nexit 0\n' > "$stage/libexec/hy-maintenance"
chmod +x "$stage/bin/hy" "$stage/libexec/hy-core" "$stage/libexec/hy-maintenance"
printf 'Hydrogen release: alpha-0.1.0\nPlatform: %s\n' "$platform" > "$stage/BUILD-INFO.txt"
printf 'Test release\n' > "$stage/README.md"
printf 'hydrogen-install-manifest-v1\nbin/hy\nlibexec/hy-core\nlibexec/hy-maintenance\nBUILD-INFO.txt\nREADME.md\nSHA256SUMS\nINSTALL-MANIFEST\n' > "$stage/INSTALL-MANIFEST"
if [[ $platform == macos-x86_64 ]]; then
    ( cd "$stage" && shasum -a 256 bin/hy libexec/hy-core libexec/hy-maintenance BUILD-INFO.txt README.md > SHA256SUMS )
else
    ( cd "$stage" && sha256sum bin/hy libexec/hy-core libexec/hy-maintenance BUILD-INFO.txt README.md > SHA256SUMS )
fi
archive_name="$name.tar.gz"
( cd "$work/fixture" && tar -czf "$work/$archive_name" "$name" )
if [[ $platform == macos-x86_64 ]]; then digest=$(shasum -a 256 "$work/$archive_name" | cut -d' ' -f1)
else digest=$(sha256sum "$work/$archive_name" | cut -d' ' -f1); fi
printf '%s  %s\n' "$digest" "$archive_name" > "$work/$archive_name.sha256"
cat > "$work/releases.json" <<EOF
[{"tag_name":"alpha-0.1.0","draft":false,"prerelease":true,"assets":[
{"name":"$archive_name","digest":"sha256:$digest","browser_download_url":"https://github.com/Aurora-softwares/Hylang-Compiler/releases/download/alpha-0.1.0/$archive_name"},
{"name":"$archive_name.sha256","browser_download_url":"https://github.com/Aurora-softwares/Hylang-Compiler/releases/download/alpha-0.1.0/$archive_name.sha256"}]}]
EOF
cat > "$work/mock-bin/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
output=''
last=''
while (( $# )); do
    if [[ $1 == --output ]]; then output=$2; shift 2; continue; fi
    last=$1; shift
done
case $last in
    *'/releases?per_page=100') cp "$HY_INSTALL_TEST_FIXTURE/releases.json" "$output" ;;
    *.tar.gz.sha256) cp "$HY_INSTALL_TEST_FIXTURE/$HY_INSTALL_TEST_ARCHIVE.sha256" "$output" ;;
    *.tar.gz) cp "$HY_INSTALL_TEST_FIXTURE/$HY_INSTALL_TEST_ARCHIVE" "$output" ;;
    *) exit 1 ;;
esac
EOF
chmod +x "$work/mock-bin/curl"
HOME="$work/home" HYDROGEN_CHANNEL=alpha HY_INSTALL_TEST_FIXTURE="$work" HY_INSTALL_TEST_ARCHIVE="$archive_name" \
    PATH="$work/mock-bin:$PATH" bash "$repo/public/install.sh" > "$work/install.log"
test -L "$work/home/.local/bin/hy"
test "$(readlink "$work/home/.local/bin/hy")" = "$work/home/.local/share/hydrogen/bin/hy"
test -f "$work/home/.local/share/hydrogen/INSTALL-MANIFEST"
if HOME="$work/home" HYDROGEN_CHANNEL=alpha HY_INSTALL_TEST_FIXTURE="$work" HY_INSTALL_TEST_ARCHIVE="$archive_name" \
    PATH="$work/mock-bin:$PATH" bash "$repo/public/install.sh" > "$work/again.log" 2>&1; then
    echo 'installer unexpectedly overwrote an existing installation' >&2
    exit 1
fi
echo "$platform installer tests passed"
