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
    if [[ -n "$(git status --porcelain)" ]]; then
        echo "Abbruch: Es gibt ungespeicherte Git-Aenderungen." >&2
        echo "Bitte zuerst committen oder stashen." >&2
        exit 1
    fi
}

fetch_remote_branch() {
    local branch="$1"
    git fetch origin "$branch"
    if ! git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        echo "Abbruch: origin/$branch wurde nicht gefunden." >&2
        exit 1
    fi
}

last_final_tag() {
    git describe --tags --match 'v*' --exclude '*beta*' --abbrev=0 refs/heads/main 2>/dev/null || true
}

write_release_notes() {
    local notes_file="$1"
    local version="$2"
    local changelog_section

    mkdir -p "$(dirname "$notes_file")"
    changelog_section="$(
        awk -v heading="## $version -" '
            $0 == heading || index($0, heading) == 1 { found = 1; next }
            found && /^## / { exit }
            found { print }
        ' "$root_directory/CHANGELOG.md"
    )"

    if [[ -z "$changelog_section" ]]; then
        echo "Abbruch: Kein Changelog-Abschnitt fuer $version gefunden." >&2
        exit 1
    fi

    {
        echo "## UroBilanz $version"
        echo
        printf '%s\n' "$changelog_section"
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

version="$(release_version)"
if [[ -z "$version" ]]; then
    echo "Abbruch: Final-Version fehlt." >&2
    echo "Aufruf: $0 1.8.0" >&2
    exit 1
fi

fetch_remote_branch main
fetch_remote_branch beta

git switch main
git merge --ff-only origin/main
git branch -f beta origin/beta
git merge --ff-only beta
final_commit="$(git rev-parse HEAD)"

UROBILANZ_VERSION="$version" \
UROBILANZ_ALLOW_RELEASE_PACKAGE=YES \
    "$root_directory/Scripts/build-release-package.sh" final "$version"

backup_directory="$root_directory/Backup/releases/final/$version"
release_notes_file="$backup_directory/UroBilanz-$version-release-notes.md"
write_release_notes "$release_notes_file" "$version"

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
