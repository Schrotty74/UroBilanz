#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
target="$script_dir/build/UroBilanz-Web"

rm -rf "$target"
mkdir -p "$target"

cp "$script_dir/index.html" \
  "$script_dir/styles.css" \
  "$script_dir/mobile.css" \
  "$script_dir/app.js" \
  "$script_dir/manifest.webmanifest" \
  "$script_dir/offline.html" \
  "$script_dir/service-worker.js" \
  "$script_dir/Start_Urinprotokoll.command" \
  "$target/"
cp -R "$script_dir/assets" "$target/assets"

find "$target" -name ".DS_Store" -delete
chmod +x "$target/Start_Urinprotokoll.command"

echo "Web-Build erstellt: $target"
