#!/bin/zsh

set -euo pipefail

root_directory="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root_directory"

requested_version="${1:-}"
temporary_index=""

cleanup() {
    if [[ -n "$temporary_index" && -f "$temporary_index" ]]; then
        rm -f "$temporary_index"
    fi
}
trap cleanup EXIT

build_setting() {
    local name="$1"
    xcodebuild \
        -project UroBilanz.xcodeproj \
        -scheme "UroBilanz Dev" \
        -configuration Beta \
        -derivedDataPath "$root_directory/.build/xcode-beta-derived-data" \
        -showBuildSettings 2>/dev/null \
        | awk -F' = ' -v setting="$name" '$1 ~ setting "$" { print $2; exit }'
}

release_version() {
    if [[ -n "$requested_version" ]]; then
        echo "${requested_version#v}"
        return
    fi

    local marketing_version
    marketing_version="$(build_setting MARKETING_VERSION)"
    marketing_version="${marketing_version#v}"
    if [[ -z "$marketing_version" ]]; then
        echo "Abbruch: Beta-Version fehlt." >&2
        echo "Aufruf: $0 1.8.0-beta.1" >&2
        exit 1
    fi
    echo "$marketing_version"
}

ensure_beta_ref() {
    if git show-ref --verify --quiet refs/heads/beta; then
        return
    fi

    if git show-ref --verify --quiet refs/remotes/origin/beta; then
        git update-ref refs/heads/beta refs/remotes/origin/beta
        return
    fi

    git update-ref refs/heads/beta HEAD
}

worktree_tree() {
    local changed_paths

    temporary_index="$(mktemp "${TMPDIR:-/tmp}/urobilanz-beta-index.XXXXXX")"
    GIT_INDEX_FILE="$temporary_index" git read-tree HEAD

    changed_paths=()
    while IFS= read -r path; do
        changed_paths+=("$path")
    done < <(
        {
            git diff --name-only HEAD --
            git diff --cached --name-only
            git ls-files --others --exclude-standard
        } | sort -u
    )

    if (( ${#changed_paths[@]} > 0 )); then
        GIT_INDEX_FILE="$temporary_index" git add -A -- "${changed_paths[@]}"
    fi

    GIT_INDEX_FILE="$temporary_index" git write-tree
}

create_beta_commit() {
    local version="$1"
    local tree="$2"
    local parent
    local parent_tree

    parent="$(git rev-parse refs/heads/beta)"
    parent_tree="$(git rev-parse "$parent^{tree}")"
    if [[ "$tree" == "$parent_tree" ]]; then
        echo "$parent"
        return
    fi

    printf '%s\n' "Create beta $version from local dev" | git commit-tree "$tree" -p "$parent"
}

last_beta_tag() {
    git describe --tags --match 'v*-beta*' --abbrev=0 refs/heads/beta 2>/dev/null || true
}

write_release_notes() {
    local notes_file="$1"
    local previous_tag="$2"
    local target_commit="$3"
    local range

    mkdir -p "$(dirname "$notes_file")"
    if [[ -n "$previous_tag" ]]; then
        range="$previous_tag..$target_commit"
    else
        range="$target_commit^..$target_commit"
    fi

    {
        echo "Beta build generated from the current local development state."
        echo
        echo "## Changes"
        echo
        git log --reverse --no-merges --format='- %s' "$range" 2>/dev/null || echo "- Local development changes"
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
        --notes-file "$notes_file" \
        --prerelease
}

version="$(release_version)"
ensure_beta_ref

UROBILANZ_VERSION="$version" \
UROBILANZ_ALLOW_RELEASE_PACKAGE=YES \
    "$root_directory/Scripts/build-release-package.sh" beta "$version"

tree="$(worktree_tree)"
beta_commit="$(create_beta_commit "$version" "$tree")"
git update-ref refs/heads/beta "$beta_commit"

previous_beta_tag="$(last_beta_tag)"
backup_directory="$root_directory/Backup/releases/beta/$version"
release_notes_file="$backup_directory/UroBilanz-Beta-$version-release-notes.md"
write_release_notes "$release_notes_file" "$previous_beta_tag" "$beta_commit"

case "$version" in
    *local*|*test*)
        ;;
    *)
        git tag -f "v$version" "$beta_commit"
        ;;
esac

if [[ "${UROBILANZ_ALLOW_PUSH:-}" == "YES" ]]; then
    case "$version" in
        *local*|*test*)
            echo "Abbruch: lokale/test Beta-Versionen werden nicht gepusht." >&2
            exit 1
            ;;
    esac
    if ! command -v gh >/dev/null 2>&1; then
        echo "Abbruch: GitHub CLI 'gh' wurde nicht gefunden." >&2
        exit 1
    fi
    git push origin beta "v$version"
    create_github_release "$version" "$beta_commit" "$release_notes_file" "$backup_directory"
else
    echo "Beta lokal erstellt. Kein Push, weil UROBILANZ_ALLOW_PUSH nicht YES ist."
fi

echo "Beta commit: $beta_commit"
echo "Backup: $backup_directory"
