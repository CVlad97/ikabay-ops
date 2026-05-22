#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${BASE_DIR:-/root/vladclaw}"
REPORT_DIR="${REPORT_DIR:-$BASE_DIR/ikabay-ops/reports}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
REPORT_FILE="$REPORT_DIR/global-check-$STAMP.md"

mkdir -p "$REPORT_DIR"

repos=(
  "DELIKREOL|npm run typecheck;npm run lint;npm run build;npm run test:e2e"
  "anbaybot|npm run typecheck;npm run lint;npm run build"
  "Kaygo|pnpm run typecheck;pnpm run build"
)

urls=(
  "DELIKREOL|https://cvlad97.github.io/DELIKREOL/"
  "anbaybot|https://cvlad97.github.io/anbaybot/"
  "Kaygo|https://cvlad97.github.io/Kaygo/"
)

echo "# Global Checks - $STAMP" >"$REPORT_FILE"
echo >>"$REPORT_FILE"

overall_fail=0

run_cmd() {
  local repo="$1"
  local cmd="$2"
  local workdir="$BASE_DIR/$repo"

  echo "- \`$cmd\`" >>"$REPORT_FILE"
  if (cd "$workdir" && eval "$cmd") >>"$REPORT_FILE" 2>&1; then
    echo "  - status: PASS" >>"$REPORT_FILE"
  else
    echo "  - status: FAIL" >>"$REPORT_FILE"
    overall_fail=1
  fi
}

for entry in "${repos[@]}"; do
  repo="${entry%%|*}"
  cmd_list="${entry#*|}"

  echo "## Repo: $repo" >>"$REPORT_FILE"
  echo >>"$REPORT_FILE"

  local_sha="$(git -C "$BASE_DIR/$repo" rev-parse --short HEAD)"
  remote_sha="$(git -C "$BASE_DIR/$repo" ls-remote origin refs/heads/main | awk '{print substr($1,1,7)}')"
  dirty="$(git -C "$BASE_DIR/$repo" status --porcelain | wc -l | tr -d ' ')"

  echo "- local sha: \`$local_sha\`" >>"$REPORT_FILE"
  echo "- remote sha (main): \`$remote_sha\`" >>"$REPORT_FILE"
  if [[ "$local_sha" == "$remote_sha" ]]; then
    echo "- sync: YES" >>"$REPORT_FILE"
  else
    echo "- sync: NO" >>"$REPORT_FILE"
    overall_fail=1
  fi
  echo "- dirty files: \`$dirty\`" >>"$REPORT_FILE"
  if [[ "$dirty" != "0" ]]; then
    overall_fail=1
  fi
  echo >>"$REPORT_FILE"
  echo "### Commands" >>"$REPORT_FILE"

  IFS=';' read -r -a commands <<<"$cmd_list"
  for cmd in "${commands[@]}"; do
    run_cmd "$repo" "$cmd"
  done
  echo >>"$REPORT_FILE"
done

echo "## Public URLs" >>"$REPORT_FILE"
echo >>"$REPORT_FILE"
for entry in "${urls[@]}"; do
  name="${entry%%|*}"
  url="${entry#*|}"
  code="$(curl -s -L -o /dev/null -w "%{http_code}" "$url" || true)"
  echo "- $name: [$url]($url) -> HTTP \`$code\`" >>"$REPORT_FILE"
  if [[ "$code" != "200" ]]; then
    overall_fail=1
  fi
done

echo >>"$REPORT_FILE"
if [[ "$overall_fail" -eq 0 ]]; then
  echo "## Result: PASS" >>"$REPORT_FILE"
  echo "PASS: $REPORT_FILE"
  exit 0
fi

echo "## Result: FAIL" >>"$REPORT_FILE"
echo "FAIL: $REPORT_FILE"
exit 1
