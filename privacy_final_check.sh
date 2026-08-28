#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
cd "$script_dir"

failures=0

fail() {
  echo "FEHLER: $1" >&2
  failures=$((failures + 1))
}

check_empty() {
  local title="$1"
  local output="$2"
  if [[ -n "$output" ]]; then
    fail "$title"
    echo "$output" >&2
  fi
}

echo "Pruefe aktuellen Git-Stand und vollstaendige Git-Historie ..."

tracked_sensitive="$(git ls-files | grep -Ei '\.(csv|tsv|xlsx?|numbers|ods)$|(^|/).*(backup|gesundheit|health|tagesdaten).*$' | grep -Ev '^docs/demo/urobilanz-demo(-daily)?\.csv$' || true)"
check_empty "Unerlaubte sensible Datendateien werden von Git verfolgt." "$tracked_sensitive"

historical_sensitive="$(git rev-list --objects --all | grep -Ei '\.(csv|tsv|xlsx?|numbers|ods)$|(^|/).*(backup|gesundheit|health|tagesdaten).*$' | grep -Ev ' docs/demo/urobilanz-demo(-daily)?\.csv$' || true)"
check_empty "Unerlaubte sensible Datendateien stehen in der Git-Historie." "$historical_sensitive"

current_paths="$(git grep -nI -E '/Users/|/home/|C:\\Users\\|lokaler Mac' HEAD -- . ':(exclude)privacy_final_check.sh' ':(exclude)AGENTS.md' || true)"
check_empty "Der aktuelle Git-Stand enthaelt lokale Benutzerpfade oder Hostnamen." "$current_paths"

protected_name_pattern="$(printf '%s' 'QnJ1bm8gTWFydGluIEt1cnRofE1hcnRpbiBLdXJ0aA==' | openssl base64 -d -A)"

real_name_current="$(git grep -nIi -E "$protected_name_pattern" HEAD -- . ':(exclude)privacy_final_check.sh' || true)"
check_empty "Der aktuelle Git-Stand enthaelt den realen Entwicklernamen." "$real_name_current"

history_paths="$(
  for commit in $(git rev-list --all); do
    git grep -nI -E '/Users/|/home/|C:\\Users\\|lokaler Mac' "$commit" -- . ':(exclude)privacy_final_check.sh' ':(exclude)AGENTS.md' 2>/dev/null || true
  done | sort -u
)"
check_empty "Die Git-Historie enthaelt lokale Benutzerpfade oder Hostnamen." "$history_paths"

real_name_history="$(
  for commit in $(git rev-list --all); do
    git grep -nIi -E "$protected_name_pattern" "$commit" -- . ':(exclude)privacy_final_check.sh' 2>/dev/null || true
  done | sort -u
)"
check_empty "Die Git-Historie enthaelt den realen Entwicklernamen." "$real_name_history"

real_name_metadata="$(
  git log --all --format='%an%n%cn' |
    grep -Ei "$protected_name_pattern" || true
)"
check_empty "Commit-Metadaten enthalten den realen Entwicklernamen." "$real_name_metadata"

private_commit_emails="$(
  git log --all --format='%ae%n%ce' |
    sort -u |
    grep -Ev '^$|@users\.noreply\.github\.com$|^noreply@github\.com$' || true
)"
check_empty "Die Git-Historie enthaelt nicht freigegebene Commit-E-Mail-Adressen." "$private_commit_emails"

private_tag_emails="$(
  git for-each-ref refs/tags --format='%(taggeremail)' |
    tr -d '<>' |
    sort -u |
    grep -Ev '^$|@users\.noreply\.github\.com$' || true
)"
check_empty "Die Git-Tags enthalten nicht freigegebene E-Mail-Adressen." "$private_tag_emails"

secrets="$(git grep -nEI 'BEGIN (RSA|OPENSSH|EC|DSA|PGP) PRIVATE KEY|github_pat_[A-Za-z0-9_]+|gh[pousr]_[A-Za-z0-9]{20,}|AKIA[A-Z0-9]{16}|sk-[A-Za-z0-9]{20,}' HEAD -- . ':(exclude)privacy_final_check.sh' || true)"
check_empty "Der aktuelle Git-Stand enthaelt moegliche Zugangsdaten oder private Schluessel." "$secrets"

network_apis="$(
  git grep -nEI 'fetch\(|XMLHttpRequest|sendBeacon|WebSocket|URLSession|NSURLConnection|import Network' HEAD -- apps |
    grep -Ev '^HEAD:apps/macos-swift/Sources/UroUpdateChecker\.swift:.*(URLSession|URLSession\.shared\.data)' || true
)"
check_empty "Die Apps enthalten Netzwerk-APIs, die manuell geprueft werden muessen." "$network_apis"

external_web_resources="$(git grep -nEI '<(script|img)[^>]+src=\"https?://|<link[^>]+href=\"https?://' HEAD -- apps/web || true)"
check_empty "Die Web-App bindet externe Ressourcen ein." "$external_web_resources"

for sample in private.csv health.xlsx Gesundheit.numbers Tagesdaten.tsv backup.zip private.log build/test release/test; do
  if ! git check-ignore -q "$sample"; then
    fail ".gitignore schliesst '$sample' nicht aus."
  fi
done

if (( failures > 0 )); then
  echo
  echo "Datenschutz-Finalpruefung fehlgeschlagen: $failures Problem(e)." >&2
  exit 1
fi

echo "Statische Datenschutz-Finalpruefung bestanden."
echo "Vor einer Final-Veroeffentlichung zusaetzlich beide Apps starten und das Laufzeit-Netzwerkverhalten pruefen."
