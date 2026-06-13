#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

mkdir -p /private/tmp/urobilanz-clang-cache \
  build

rm -rf build/UroBilanz.app
mkdir -p build/UroBilanz.app/Contents/MacOS \
  build/UroBilanz.app/Contents/Resources

rm -rf build/UroBilanz.iconset
mkdir -p build/UroBilanz.iconset
for spec in \
  "16 icon_16x16.png" \
  "32 icon_16x16@2x.png" \
  "32 icon_32x32.png" \
  "64 icon_32x32@2x.png" \
  "128 icon_128x128.png" \
  "256 icon_128x128@2x.png" \
  "256 icon_256x256.png" \
  "512 icon_256x256@2x.png" \
  "512 icon_512x512.png" \
  "1024 icon_512x512@2x.png"; do
  size="${spec%% *}"
  file="${spec#* }"
  sips -z "$size" "$size" Assets/urobilanz-app-icon.png --out "build/UroBilanz.iconset/$file" >/dev/null
done
iconutil -c icns build/UroBilanz.iconset -o build/UroBilanz.icns

cat > build/UroBilanz.app/Contents/Info.plist <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>de</string>
  <key>CFBundleDisplayName</key>
  <string>UroBilanz</string>
  <key>CFBundleExecutable</key>
  <string>UrinprotokollSwiftUI</string>
  <key>CFBundleIconFile</key>
  <string>UroBilanz</string>
  <key>CFBundleIdentifier</key>
  <string>local.martin.urobilanz</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>UroBilanz</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.7.0-beta.1</string>
  <key>CFBundleVersion</key>
  <string>27</string>
  <key>LSMinimumSystemVersion</key>
  <string>26.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

CLANG_MODULE_CACHE_PATH=/private/tmp/urobilanz-clang-cache \
  swiftc -parse-as-library \
  Sources/UroCSVSupport.swift \
  Sources/UroModels.swift \
  Sources/UroControls.swift \
  Sources/UroTablesAndCharts.swift \
  Sources/UroSmokeTests.swift \
  Sources/UrinprotokollSwiftUI.swift \
  -o build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI \
  -framework SwiftUI \
  -framework AppKit

cp build/UroBilanz.icns build/UroBilanz.app/Contents/Resources/UroBilanz.icns
rm -f build/UroBilanz.app/Contents/Resources/urobilanz-icon-light.svg \
  build/UroBilanz.app/Contents/Resources/urobilanz-icon-dark.svg
cp Assets/urobilanz-app-icon.png \
  Assets/github-invertocat-black.svg \
  Assets/github-invertocat-white.svg \
  build/UroBilanz.app/Contents/Resources/

codesign --force --deep --sign - build/UroBilanz.app
codesign --verify --deep --strict build/UroBilanz.app

echo "UroBilanz.app built and verified"
