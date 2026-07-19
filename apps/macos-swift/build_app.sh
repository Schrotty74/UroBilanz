#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

mkdir -p /private/tmp/urobilanz-clang-cache \
  build

build_channel="${UROBILANZ_BUILD_CHANNEL:-final}"
marketing_version="${UROBILANZ_VERSION:-1.7.2}"
build_number="${UROBILANZ_BUILD_NUMBER:-31}"
case "$build_channel" in
  final)
    app_name="UroBilanz"
    display_name="UroBilanz"
    bundle_id="local.schrotty74.urobilanz"
    ;;
  beta)
    app_name="UroBilanz Beta"
    display_name="UroBilanz Beta"
    bundle_id="local.schrotty74.urobilanz.beta"
    ;;
  dev)
    app_name="UroBilanz Dev"
    display_name="UroBilanz Dev"
    bundle_id="local.schrotty74.urobilanz.dev"
    ;;
  *)
    echo "Unknown UROBILANZ_BUILD_CHANNEL: $build_channel"
    echo "Use 'final', 'beta' or 'dev'."
    exit 1
    ;;
esac

app_path="build/${app_name}.app"

rm -rf "$app_path"
mkdir -p "$app_path/Contents/MacOS" \
  "$app_path/Contents/Resources"

cat > "$app_path/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>de</string>
  <key>CFBundleDisplayName</key>
  <string>${display_name}</string>
  <key>CFBundleExecutable</key>
  <string>UrinprotokollSwiftUI</string>
  <key>CFBundleIconFile</key>
  <string>UroBilanz</string>
  <key>CFBundleIdentifier</key>
  <string>${bundle_id}</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>${display_name}</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>${marketing_version}</string>
  <key>CFBundleVersion</key>
  <string>${build_number}</string>
  <key>LSMinimumSystemVersion</key>
  <string>26.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

CLANG_MODULE_CACHE_PATH=/private/tmp/urobilanz-clang-cache \
  swiftc -parse-as-library \
  Sources/UroLocalization.swift \
  Sources/UroThemes.swift \
  Sources/UroNavigation.swift \
  Sources/UroCSVSupport.swift \
  Sources/UroModels.swift \
  Sources/UroDataModel.swift \
  Sources/UroControls.swift \
  Sources/UroMedicalReport.swift \
  Sources/UroUpdateChecker.swift \
  Sources/UroTablesAndCharts.swift \
  Sources/UroSmokeTests.swift \
  Sources/UrinprotokollSwiftUI.swift \
  -o "$app_path/Contents/MacOS/UrinprotokollSwiftUI" \
  -framework SwiftUI \
  -framework AppKit

cp Assets/UroBilanz.icns "$app_path/Contents/Resources/UroBilanz.icns"
rm -f "$app_path/Contents/Resources/urobilanz-icon-light.svg" \
  "$app_path/Contents/Resources/urobilanz-icon-dark.svg"
cp Assets/urobilanz-app-icon.png \
  Assets/ai-chatgpt-logo.jpg \
  Assets/ai-gemini-logo.svg \
  Assets/ai-claude-logo.png \
  Assets/discord-mark-white.svg \
  Assets/github-invertocat-black.svg \
  Assets/github-invertocat-white.svg \
  "$app_path/Contents/Resources/"

codesign --force --deep --sign - --entitlements UroBilanz.entitlements "$app_path"
codesign --verify --deep --strict "$app_path"

echo "${app_name}.app built and verified (${bundle_id})"
