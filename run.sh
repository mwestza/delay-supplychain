#!/bin/sh
set -eu

uv_path="$HOME/.config/uv/uv.toml"
npm_path="$HOME/.npmrc"
bun_path="$HOME/.bunfig.toml"

case "$(uname -s)" in
  Darwin)
    pnpm_path="$HOME/Library/Preferences/pnpm/rc"
    ;;
  *)
    pnpm_path="$HOME/.config/pnpm/rc"
    ;;
esac


ensure_config() {
  label=$1
  file=$2
  create_content=$3
  shift 3

  if [ ! -f "$file" ]; then
    mkdir -p "$(dirname "$file")"
    printf '%s\n' "$create_content" > "$file"
    printf '[CREATED] %s: %s\n' "$label" "$file"
    return 0
  fi

  missing_lines=''

  while [ "$#" -gt 0 ]; do
    pattern=$1
    line=$2
    shift 2

    if ! grep -q "$pattern" "$file"; then
      missing_lines="${missing_lines}${line}
"
    fi
  done

  if [ -z "$missing_lines" ]; then
    printf '[OK]      %s: %s already configured\n' "$label" "$file"
    return 0
  fi

  printf '[WARN]    %s: %s exists but missing setting(s). Add manually:\n' "$label" "$file"
  printf '%s' "$missing_lines" | while IFS= read -r line; do
    [ -n "$line" ] || continue
    printf '            %s\n' "$line"
  done
}

ensure_config \
  "uv" \
  "$uv_path" \
  'exclude-newer = "7 days"  # delay package updates' \
  '^exclude-newer[[:space:]]*=[[:space:]]*"7 days"' \
  'exclude-newer = "7 days"  # delay package updates'

ensure_config \
  "npm" \
  "$npm_path" \
  'min-release-age=7 # days
ignore-scripts=true' \
  '^min-release-age[[:space:]]*=[[:space:]]*7' \
  'min-release-age=7 # days' \
  '^ignore-scripts[[:space:]]*=[[:space:]]*true' \
  'ignore-scripts=true'

ensure_config \
  "pnpm" \
  "$pnpm_path" \
  'minimum-release-age=10080 # minutes' \
  '^minimum-release-age[[:space:]]*=[[:space:]]*10080' \
  'minimum-release-age=10080 # minutes'

ensure_config \
  "bun" \
  "$bun_path" \
  '[install]
minimumReleaseAge = 604800 # seconds' \
  '^minimumReleaseAge[[:space:]]*=[[:space:]]*604800' \
  '[install]
minimumReleaseAge = 604800 # seconds'
