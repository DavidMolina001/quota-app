#!/bin/sh
# Installs (or reinstalls) the latest Quota and opens it.
# Downloads from this repo's releases over HTTPS, checks the checksum and that the
# app is signed by Quota's own certificate. You only need this once: Quota updates itself.
#
# Everything runs inside main(), called on the last line, so a download cut off
# halfway runs nothing at all.

main() {
set -e
FEED="https://github.com/DavidMolina001/quota-app/releases/latest/download/latest.json"
# only an app signed by Quota's certificate is accepted (not just any valid signature)
REQ='identifier "com.quota.app" and certificate leaf = H"26ec71693fac632a3f88c9b60dd28cf6df3592f4"'

MAJOR=$(sw_vers -productVersion | cut -d. -f1)
if [ "$MAJOR" -lt 13 ]; then
  echo "Quota needs macOS 13 (Ventura) or later. This Mac has $(sw_vers -productVersion). Nothing was installed."
  exit 1
fi

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Checking the latest version…"
curl -fsSL "$FEED" -o "$TMP/latest.json" 2>/dev/null || {
  echo "Couldn't reach GitHub. Check your internet connection and try again. Nothing was installed."; exit 1; }
VERSION=$(plutil -extract version raw -o - "$TMP/latest.json")
URL=$(plutil -extract url raw -o - "$TMP/latest.json")
SHA=$(plutil -extract sha256 raw -o - "$TMP/latest.json")

echo "Downloading Quota $VERSION…"
curl -fsSL "$URL" -o "$TMP/Quota.zip" 2>/dev/null || {
  echo "The download didn't finish. Try again in a minute. Nothing was installed."; exit 1; }
GOT=$(shasum -a 256 "$TMP/Quota.zip" | cut -d' ' -f1)
[ "$GOT" = "$SHA" ] || { echo "Download didn't match its checksum. Nothing was installed."; exit 1; }

ditto -x -k "$TMP/Quota.zip" "$TMP/out"
codesign --verify --strict -R="$REQ" "$TMP/out/Quota.app" 2>/dev/null || {
  echo "The app isn't signed by Quota. Nothing was installed."; exit 1; }

# Applications if this account can write there; otherwise the account's own Applications
# folder (no password needed, and Quota can still update itself there)
DEST=/Applications
if [ ! -w /Applications ] || { [ -e /Applications/Quota.app ] && [ ! -w /Applications/Quota.app ]; }; then
  DEST="$HOME/Applications"
  mkdir -p "$DEST"
fi

pkill -x Quota 2>/dev/null || true
sleep 1
rm -rf "$DEST/Quota.app"
ditto "$TMP/out/Quota.app" "$DEST/Quota.app"
open "$DEST/Quota.app"
echo "Installed Quota $VERSION in $DEST. A Setup window opens to connect Claude Code; after that Quota lives in your menu bar."
}

main "$@"
