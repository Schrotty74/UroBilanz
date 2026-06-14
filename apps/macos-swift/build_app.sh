#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

mkdir -p /private/tmp/urobilanz-clang-cache \
  build

rm -rf build/UroBilanz.app
mkdir -p build/UroBilanz.app/Contents/MacOS \
  build/UroBilanz.app/Contents/Resources

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
  <string>1.7.0-beta.2</string>
  <key>CFBundleVersion</key>
  <string>28</string>
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
  Sources/UroTablesAndCharts.swift \
  Sources/UroSmokeTests.swift \
  Sources/UrinprotokollSwiftUI.swift \
  -o build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI \
  -framework SwiftUI \
  -framework AppKit

cp Assets/UroBilanz.icns build/UroBilanz.app/Contents/Resources/UroBilanz.icns
rm -f build/UroBilanz.app/Contents/Resources/urobilanz-icon-light.svg \
  build/UroBilanz.app/Contents/Resources/urobilanz-icon-dark.svg
cp Assets/urobilanz-app-icon.png \
  Assets/github-invertocat-black.svg \
  Assets/github-invertocat-white.svg \
  build/UroBilanz.app/Contents/Resources/

codesign --force --deep --sign - build/UroBilanz.app
codesign --verify --deep --strict build/UroBilanz.app

echo "UroBilanz.app built and verified"
