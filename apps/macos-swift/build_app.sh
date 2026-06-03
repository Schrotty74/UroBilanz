#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

mkdir -p /private/tmp/urobilanz-clang-cache \
  build/UroBilanz.app/Contents/MacOS \
  build/UroBilanz.app/Contents/Resources

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
cp Assets/urobilanz-icon-light.svg Assets/urobilanz-icon-dark.svg build/UroBilanz.app/Contents/Resources/

codesign --force --deep --sign - build/UroBilanz.app
codesign --verify --deep --strict build/UroBilanz.app

echo "UroBilanz.app built and verified"
