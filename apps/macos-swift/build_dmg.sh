#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

build_channel="${UROBILANZ_BUILD_CHANNEL:-final}"
case "$build_channel" in
  final)
    app_name="UroBilanz"
    dmg_name="UroBilanz-macOS-Swift"
    ;;
  beta)
    app_name="UroBilanz Beta"
    dmg_name="UroBilanz-macOS-Swift-Beta"
    ;;
  dev)
    app_name="UroBilanz Dev"
    dmg_name="UroBilanz-macOS-Swift-Dev"
    ;;
  *)
    echo "Unknown UROBILANZ_BUILD_CHANNEL: $build_channel"
    echo "Use 'final', 'beta' or 'dev'."
    exit 1
    ;;
esac

app_path="build/${app_name}.app"
staging_dir="build/dmg-${build_channel}"
dmg_path="build/${dmg_name}.dmg"

if [[ ! -d "$app_path" ]]; then
  UROBILANZ_BUILD_CHANNEL="$build_channel" ./build_app.sh
fi

rm -rf "$staging_dir" "$dmg_path"
mkdir -p "$staging_dir"

/usr/bin/ditto "$app_path" "$staging_dir/${app_name}.app"
ln -s /Applications "$staging_dir/Applications"

hdiutil create \
  -volname "$app_name" \
  -srcfolder "$staging_dir" \
  -ov \
  -format UDZO \
  "$dmg_path" >/dev/null

echo "$dmg_path"
