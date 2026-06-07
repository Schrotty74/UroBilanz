#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

repo_dir="$(cd "$script_dir/../.." && pwd)"
csv="${1:-$repo_dir/docs/demo/urobilanz-demo.csv}"

if [[ ! -f "$csv" ]]; then
  echo "Fehlende Testdatei: $csv" >&2
  echo "Aufruf: ./smoke_test.sh [Urinote-CSV]" >&2
  exit 1
fi

./build_app.sh
build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI --test-import "$csv"
