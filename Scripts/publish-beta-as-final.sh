#!/bin/zsh

set -euo pipefail

root_directory="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_directory"

requested_version="${1:-}"

release_version() {
    if [[ -n "$requested_version" ]]; then
        echo "${requested_version#v}"
        return
    fi

    xcodebuild \
        -project UroBilanz.xcodeproj \
        -scheme "UroBilanz Dev" \
        -configuration Final \
        -derivedDataPath "$root_directory/.build/xcode-final-derived-data" \
        -showBuildSettings 2>/dev/null \
        | awk -F' = ' '$1 ~ /MARKETING_VERSION$/ { print $2; exit }' \
        | sed 's/^v//'
}

require_clean_worktree() {
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Abbruch: Es gibt ungespeicherte Git-Aenderungen." >&2
        echo "Bitte zuerst committen oder stashen." >&2
        exit 1
    fi
}

ensure_branch_exists() {
    local branch="$1"
    local start_point="$2"
    if ! git show-ref --verify --quiet "refs/heads/$branch"; then
        git branch "$branch" "$start_point"
    fi
}

last_final_tag() {
    git describe --tags --match 'v*' --exclude '*beta*' --abbrev=0 refs/heads/main 2>/dev/null || true
}

write_release_notes() {
    local notes_file="$1"
    local previous_tag="$2"
    local range

    mkdir -p "$(dirname "$notes_file")"
    if [[ -n "$previous_tag" ]]; then
        range="$previous_tag..HEAD"
    else
        range="HEAD"
    fi

    {
        echo "Stable release generated from the current beta branch."
        echo
        echo "## Changes"
        echo
        git log --reverse --no-merges --format='- %s' "$range" 2>/dev/null || echo "- Beta changes"
    } > "$notes_file"
}

create_github_release() {
    local version="$1"
    local target_commit="$2"
    local notes_file="$3"
    local backup_directory="$4"
    local artifact_version="v$version"
    local release_tag="v$version"

    GH_PROMPT_DISABLED=1 gh release create "$release_tag" \
        "$backup_directory/UroBilanz-macOS-Swift-$artifact_version.zip" \
        "$backup_directory/UroBilanz-macOS-Swift-$artifact_version.zip.sha256" \
        "$backup_directory/UroBilanz-macOS-Swift-$artifact_version.dmg" \
        "$backup_directory/UroBilanz-macOS-Swift-$artifact_version.dmg.sha256" \
        "$backup_directory/UroBilanz-Web-$artifact_version.zip" \
        "$backup_directory/UroBilanz-Web-$artifact_version.zip.sha256" \
        --target "$target_commit" \
        --title "UroBilanz $version" \
        --notes-file "$notes_file"
}

require_clean_worktree
ensure_branch_exists beta main
ensure_branch_exists main beta

version="$(release_version)"
if [[ -z "$version" ]]; then
    echo "Abbruch: Final-Version fehlt." >&2
    echo "Aufruf: $0 1.8.0" >&2
    exit 1
fi

git switch main
git merge --ff-only beta
final_commit="$(git rev-parse HEAD)"

UROBILANZ_VERSION="$version" \
UROBILANZ_ALLOW_RELEASE_PACKAGE=YES \
    "$root_directory/Scripts/build-release-package.sh" final "$version"

previous_final_tag="$(last_final_tag)"
backup_directory="$root_directory/Backup/releases/final/$version"
release_notes_file="$backup_directory/UroBilanz-$version-release-notes.md"
write_release_notes "$release_notes_file" "$previous_final_tag"

git tag -f "v$version" "$final_commit"

if [[ "${UROBILANZ_ALLOW_PUSH:-}" == "YES" ]]; then
    if ! command -v gh >/dev/null 2>&1; then
        echo "Abbruch: GitHub CLI 'gh' wurde nicht gefunden." >&2
        exit 1
    fi
    git push origin main "v$version"
    create_github_release "$version" "$final_commit" "$release_notes_file" "$backup_directory"
else
    echo "Final lokal erstellt. Kein Push, weil UROBILANZ_ALLOW_PUSH nicht YES ist."
fi

echo "Final commit: $final_commit"
echo "Backup: $backup_directory"
