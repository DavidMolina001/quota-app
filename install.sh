#!/bin/sh
# Installs (or reinstalls) the latest Quota into /Applications and opens it.
# Downloads from this repo's releases over HTTPS and checks the checksum first.
# You only need this once: Quota updates itself after that.
set -e
FEED="https://github.com/DavidMolina001/quota-app/releases/latest/download/latest.json"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "Checking the latest version…"
curl -fsSL "$FEED" -o "$TMP/latest.json"
VERSION=$(plutil -extract version raw -o - "$TMP/latest.json")
URL=$(plutil -extract url raw -o - "$TMP/latest.json")
SHA=$(plutil -extract sha256 raw -o - "$TMP/latest.json")

echo "Downloading Quota $VERSION…"
curl -fsSL "$URL" -o "$TMP/Quota.zip"
GOT=$(shasum -a 256 "$TMP/Quota.zip" | cut -d' ' -f1)
[ "$GOT" = "$SHA" ] || { echo "Download didn't match its checksum. Nothing was installed."; exit 1; }

ditto -x -k "$TMP/Quota.zip" "$TMP/out"
codesign --verify --strict "$TMP/out/Quota.app" || { echo "The app's signature is invalid. Nothing was installed."; exit 1; }

pkill -x Quota 2>/dev/null || true
sleep 1
# admin accounts can write to Applications directly; others are asked for their password once
SUDO=""
[ -w /Applications ] || { echo "Your Mac password is needed to put Quota in Applications."; SUDO="sudo"; }
$SUDO rm -rf /Applications/Quota.app
$SUDO ditto "$TMP/out/Quota.app" /Applications/Quota.app
[ -z "$SUDO" ] || sudo chown -R "$(id -un)" /Applications/Quota.app   # so Quota can update itself later
open /Applications/Quota.app
echo "Installed Quota $VERSION. Look for it in your menu bar."
