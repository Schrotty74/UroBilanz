#!/bin/zsh

set -euo pipefail

root_directory="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_directory"

branch="$(git branch --show-current)"

case "$branch" in
    dev|main)
        scheme="UroBilanz Dev"
        configuration="Dev"
        ;;
    beta)
        echo "Beta wird ueber ./Scripts/create-beta-from-dev.sh <version> gebaut." >&2
        exit 1
        ;;
    *)
        scheme="UroBilanz Dev"
        configuration="Dev"
        ;;
esac

xcodebuild \
    -project UroBilanz.xcodeproj \
    -scheme "$scheme" \
    -configuration "$configuration" \
    -destination 'platform=macOS' \
    -derivedDataPath "$root_directory/.build/xcode-dev-derived-data" \
    build
