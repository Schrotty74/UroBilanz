#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

csv="${1:-docs/demo/urobilanz-demo.csv}"

./build_app.sh
build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI --test-import "$csv"
