#!/bin/zsh
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

original_csv="${1:-$script_dir/docs/demo/urobilanz-demo.csv}"
daily_csv="${2:-$script_dir/docs/demo/urobilanz-demo-daily.csv}"

require_file() {
  if [[ ! -f "$1" ]]; then
    echo "Fehlende Testdatei: $1" >&2
    echo "Aufruf: ./verify_apps.sh [Urinote-CSV] [Tagesdaten-CSV]" >&2
    exit 1
  fi
}

require_file "$original_csv"
require_file "$daily_csv"

node apps/web/tests/core-smoke-test.js
node apps/web/tests/workflow-smoke-test.js
node apps/web/tests/medical-report-smoke-test.js
node --check apps/web/assets/js/core.js
node --check apps/web/assets/js/charts.js
node --check apps/web/assets/js/medical-report.js
node --check apps/web/app.js
apps/web/build_web.sh

apps/macos-swift/build_app.sh
apps/macos-swift/build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI --test-import "$original_csv"
apps/macos-swift/build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI --test-import "$daily_csv"
apps/macos-swift/build/UroBilanz.app/Contents/MacOS/UrinprotokollSwiftUI --test-import "$original_csv" --test-workflow

git diff --check

echo "UroBilanz verification passed"
