#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

CSS_IN="sass/tailwind.css"
CSS_OUT="static/css/style.css"

# Build once in the foreground. If Tailwind errors, stop here —
# no point serving a site whose CSS silently didn't regenerate.
echo "==> Building CSS"
./tailwind_cli -i "$CSS_IN" -o "$CSS_OUT"

cleanup() {
  trap - EXIT INT TERM
  echo
  echo "==> Shutting down"
  kill "${css_pid:-}" "${zola_pid:-}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

echo "==> Starting watchers (Ctrl+C to stop)"
./tailwind_cli -i "$CSS_IN" -o "$CSS_OUT" --watch &
css_pid=$!
zola serve &
zola_pid=$!

wait
