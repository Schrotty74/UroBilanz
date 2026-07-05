#!/bin/zsh

set -euo pipefail

if [[ "${UROBILANZ_ALLOW_RELEASE_PACKAGE:-}" != "YES" ]]; then
    echo "Release-Paket abgebrochen: ausdrueckliche Freigabe fehlt." >&2
    echo "Nur nach Benutzerfreigabe mit UROBILANZ_ALLOW_RELEASE_PACKAGE=YES ausfuehren." >&2
    exit 1
fi

channel="${1:-}"
if [[ "$channel" != "beta" && "$channel" != "final" ]]; then
    echo "Aufruf: $0 beta|final [version]" >&2
    exit 1
fi

requested_version="${2:-${UROBILANZ_VERSION:-}}"
root_directory="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_directory"

configuration="Final"
app_name="UroBilanz"
bundle_identifier="local.martin.urobilanz"
if [[ "$channel" == "beta" ]]; then
    configuration="Beta"
    app_name="UroBilanz Beta"
    bundle_identifier="local.martin.urobilanz.beta"
fi

build_setting() {
    local name="$1"
    xcodebuild \
        -project UroBilanz.xcodeproj \
        -scheme "UroBilanz Dev" \
        -configuration "$configuration" \
        -derivedDataPath "$root_directory/.build/xcode-$channel-derived-data" \
        -showBuildSettings 2>/dev/null \
        | awk -F' = ' -v setting="$name" '$1 ~ setting "$" { print $2; exit }'
}

version="$requested_version"
if [[ -z "$version" ]]; then
    version="$(build_setting MARKETING_VERSION)"
fi
if [[ -z "$version" ]]; then
    version="1.7.2"
fi
version="${version#v}"

build_number="${UROBILANZ_BUILD_NUMBER:-$(build_setting CURRENT_PROJECT_VERSION)}"
if [[ -z "$build_number" ]]; then
    build_number="1"
fi

artifact_version="v$version"
case "$version" in
    *local*|*test*)
        backup_directory="$root_directory/Backup/local-test/$version"
        release_directory="$root_directory/dist/local-test/$version"
        ;;
    *)
        backup_directory="$root_directory/Backup/releases/$channel/$version"
        release_directory="$root_directory/dist/releases/$channel/$version"
        ;;
esac

mac_zip="$backup_directory/UroBilanz-macOS-Swift-$artifact_version.zip"
mac_dmg="$backup_directory/UroBilanz-macOS-Swift-$artifact_version.dmg"
web_zip="$backup_directory/UroBilanz-Web-$artifact_version.zip"
app_bundle="$release_directory/$app_name.app"

"$root_directory/privacy_final_check.sh"

rm -rf "$release_directory"
mkdir -p "$backup_directory" "$release_directory"

UROBILANZ_BUILD_CHANNEL="$channel" \
UROBILANZ_VERSION="$version" \
UROBILANZ_BUILD_NUMBER="$build_number" \
    "$root_directory/apps/macos-swift/build_app.sh"

ditto "$root_directory/apps/macos-swift/build/$app_name.app" "$app_bundle"

rm -f "$mac_zip" "$mac_dmg" "$web_zip" \
    "$mac_zip.sha256" "$mac_dmg.sha256" "$web_zip.sha256"

ditto -c -k --sequesterRsrc --keepParent "$app_bundle" "$mac_zip"

dmg_staging_directory="$release_directory/DMG"
rm -rf "$dmg_staging_directory"
mkdir -p "$dmg_staging_directory"
ditto "$app_bundle" "$dmg_staging_directory/$app_name.app"
ln -s /Applications "$dmg_staging_directory/Applications"

if ! hdiutil create \
    -volname "$app_name $artifact_version" \
    -srcfolder "$dmg_staging_directory" \
    -ov \
    -format UDZO \
    "$mac_dmg"
then
    rm -f "$mac_dmg"
    hdiutil makehybrid \
        -hfs \
        -hfs-volume-name "$app_name $artifact_version" \
        -o "$mac_dmg" \
        "$dmg_staging_directory"
fi

"$root_directory/apps/web/build_web.sh"
ditto -c -k --sequesterRsrc \
    "$root_directory/apps/web/build/UroBilanz-Web" \
    "$web_zip"

(
    cd "$backup_directory"
    for artifact in "$(basename "$mac_zip")" "$(basename "$mac_dmg")" "$(basename "$web_zip")"; do
        shasum -a 256 "$artifact" > "$artifact.sha256"
    done
)

echo "Release package created"
echo "Channel: $channel"
echo "Version: $version"
echo "Bundle ID: $bundle_identifier"
echo "Backup: $backup_directory"
echo "Dist: $release_directory"
