#!/usr/bin/env bash
#
# Generate Open Graph share cards from article hero images.
#
# For each page with a `hero` in its front matter, upscales that image 8x
# with nearest-neighbor (96x64 -> 768x512) and centers it on a 1200x630
# canvas in the site background colour. Integer scale keeps the pixels
# square; 1.91:1 is the ratio social platforms crop to.
#
# The hero filename is read from the front matter rather than guessed from
# the directory, so hero images keep descriptive names and body images
# added later are never mistaken for heroes.
#
# Cards are skipped when they already exist and are newer than their hero.
#
# Usage:
#   ./gen-share-cards.sh        # only what's missing or stale
#   ./gen-share-cards.sh -f     # rebuild everything
#   ./gen-share-cards.sh -n     # dry run, report what would happen

set -euo pipefail

cd "$(dirname "$0")"

BG='#0f172a'          # slate-900, matches base.html
SCALE=800             # percent; 96x64 -> 768x512
CANVAS=1200x630
OUT_DIR=static/images/share
SECTIONS=(content/blog content/projects)

force=false
dry_run=false

while getopts ":fn" opt; do
  case $opt in
    f) force=true ;;
    n) dry_run=true ;;
    *) echo "usage: $0 [-f] [-n]" >&2; exit 1 ;;
  esac
done

if command -v magick >/dev/null 2>&1; then
  IM=magick
elif command -v convert >/dev/null 2>&1; then
  IM=convert
else
  echo "error: ImageMagick not found on PATH" >&2
  echo "       install with: sudo apt install imagemagick" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

made=0
skipped=0
warned=0

shopt -s nullglob

for section in "${SECTIONS[@]}"; do
  for md in "$section"/*/index.md; do
    dir=$(dirname "$md")
    slug=$(basename "$dir")

    # First uncommented `hero = "..."` line. The ^ anchor skips the
    # commented documentation block above it.
    hero_file=$(grep -m1 '^hero *= *"' "$md" | sed 's/.*"\(.*\)".*/\1/' || true)

    if [[ -z "$hero_file" ]]; then
      continue    # no hero is fine; page falls back to the default card
    fi

    # An absolute path means the image isn't colocated. Skip rather than
    # guess — those live in static/ and are managed by hand.
    if [[ "$hero_file" == /* ]]; then
      printf '  warn  %s: hero is an absolute path, skipping\n' "$slug" >&2
      warned=$((warned + 1))
      continue
    fi

    hero="$dir/$hero_file"

    if [[ ! -f "$hero" ]]; then
      printf '  warn  %s: front matter names %s, which does not exist\n' \
        "$slug" "$hero_file" >&2
      warned=$((warned + 1))
      continue
    fi

    out="$OUT_DIR/${slug}.png"

    if [[ "$force" == false && -f "$out" && "$out" -nt "$hero" ]]; then
      printf '  skip  %s\n' "$out"
      skipped=$((skipped + 1))
      continue
    fi

    if [[ "$dry_run" == true ]]; then
      printf '  would %s  (from %s)\n' "$out" "$hero"
      made=$((made + 1))
      continue
    fi

    "$IM" -size "$CANVAS" "xc:$BG" \
      \( "$hero" -filter point -resize "${SCALE}%" \) \
      -gravity center -composite \
      "$out"

    printf '  make  %s\n' "$out"
    made=$((made + 1))
  done
done

echo
if [[ "$dry_run" == true ]]; then
  echo "$made would be generated, $skipped skipped, $warned warnings. (dry run)"
else
  echo "$made generated, $skipped skipped, $warned warnings."
fi

if [[ $made -gt 0 && "$dry_run" == false ]]; then
  echo
  echo "Add to each article's front matter:"
  echo '  share = "/images/share/<slug>.png"'
fi
