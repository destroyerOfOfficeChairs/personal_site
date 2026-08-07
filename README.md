# wjcreations.com

Personal site and blog. Built with [Zola](https://www.getzola.org/), styled
with Tailwind CSS v4, deployed to GitHub Pages.

Every image on this site is made with
[Pixel Plumb](https://pixelplumb.wjcreations.com) — the site is a
demonstration of the tool.

---

## Running it

```sh
./dev.sh
```

Builds the CSS once in the foreground, then starts the Tailwind watcher and
`zola serve` together. Ctrl+C stops both.

The initial build runs in the foreground on purpose: if Tailwind fails, the
script exits before any watcher starts. An earlier version backgrounded
everything and logged to `/tmp`, which meant a broken `@plugin` line silently
served stale CSS with no visible error.

Site runs at `http://127.0.0.1:1024`.

### Clean build

```sh
rm -rf public static/processed_images
zola build
```

### Share cards

```sh
./gen-share-cards.sh        # only what's missing or stale
./gen-share-cards.sh -n     # dry run
./gen-share-cards.sh -f     # rebuild everything
```

Reads the `hero` filename from each page's front matter, upscales it 8x with
nearest-neighbor, and centers it on a 1200x630 canvas. Requires ImageMagick.

---

## Layout

```
content/            markdown, colocated with its images
  _index.md         homepage
  about.md
  blog/             one directory per article
  projects/         one directory per project
sass/tailwind.css   Tailwind entry point + custom utilities
static/             copied verbatim to the site root
  images/share/     generated share cards
  processed_images/ Zola's resize cache (committed on purpose)
templates/
  shortcodes/       callable from markdown
public/             build output — gitignored
```

### Templates

| Template            | Renders                                    |
|---------------------|--------------------------------------------|
| `base.html`         | shell: head, nav, main, footer              |
| `index.html`        | homepage                                    |
| `page.html`         | standalone pages (About)                    |
| `article.html`      | blog articles (`page_template`)             |
| `blog.html`         | blog index (paginated)                      |
| `section.html`      | generic section fallback                    |
| `project.html`      | project detail pages                        |
| `projects.html`     | projects index                              |
| `nav.html`          | nav + footer macros                         |
| `macros.html`       | blog cards, taxonomy links                  |
| `project_macros.html` | project `featured()` and `card()` layouts |
| `meta_macro.html`   | SEO and Open Graph tags                     |

`article.html` and `page.html` are near-identical today, as are `blog.html`
and `section.html`. They're split deliberately so blog-specific chrome can
diverge without touching the generic case.

---

## Front matter reference

### Blog articles — `content/blog/<slug>/index.md`

```toml
+++
title = "Helix Is Better Than Neovim"
date = 2026-05-09
# slug = "override-the-directory-name"   # optional
[taxonomies]
categories = ["computers"]
tags = ["helix", "rust"]
[extra]
hero = "helix_logo_pixelplumb.png"       # colocated, relative
share = "/images/share/helix-vs-neovim.png"   # absolute; omit for default
subtitle = "I escaped configuration hell."
+++
```

### Projects — `content/projects/<slug>/index.md`

```toml
+++
title = "Pixel Plumb"
weight = 1                    # lower sorts first
[extra]
tagline = "A pixel-art image pipeline in Rust and WebAssembly."
url = "https://pixelplumb.wjcreations.com"
repo = "https://github.com/destroyerOfOfficeChairs/pixel-plumb"
before = "pp_source.png"      # pairs with `after`
after = "pp_output.png"
# hero = "screenshot.png"     # single-image alternative to before/after
featured = true               # show on the homepage
+++
```

Note that `hero` means different things by section: on a blog article it's
the header image; on a project it's the single-image fallback when there's
no before/after pair.

### Homepage — `content/_index.md`

```toml
[extra]
roles = ["Rust developer", "AV control systems programmer"]
```

Rendered as a joined byline beside the avatar.

---

## Shortcodes

```
{{ pixel_art(src="bayer.png", alt="Bayer dithering") }}
{{ pixel_art(src="x.png", alt="...", caption="...", width="max-w-2xl") }}
```

Shortcode filename determines the name: `templates/shortcodes/pixel_art.html`
is called as `{{ pixel_art(...) }}`.

---

## Conventions

Decisions already made, recorded so they don't get relitigated.

### Images

- **Pixel art is never resized by Zola.** Native resolution, indexed PNG,
  scaled by CSS with the `pixelated` utility defined in
  `sass/tailwind.css`. `resize_image` resamples in the wrong color space
  and blurs hard edges.
- **Photographs do use `resize_image`,** with `format="webp", quality=80`.
  Smooth resampling is correct for photos. Without an explicit `quality`,
  WebP output is lossless and barely smaller. `format` defaults to
  `"auto"`, which preserves the input format — hence PNG in, PNG out.
- The distinction is whether hard pixel edges carry meaning.
- **Display sizes are integer multiples of native size.** A 64px source
  displays at 128 or 192, never 96. Non-integer scaling gives uneven
  pixel widths.
- **Indexed PNG for all pixel art.** Typical sizes: 64x64 avatar ~3 KB,
  96x64 article hero <1 KB. If a small image is unexpectedly large, check
  `file` — RGBA output means something in the export path is wrong.
- `static/processed_images/` is Zola's resize cache and lives in the
  source tree by design. Orphaned entries accumulate when resize
  arguments change; clear with the clean build above.

### Paths

- **Colocated assets are page-relative**, so templates must prefix them
  with `{{ page.permalink }}`. A bare relative path resolves against
  whatever URL the browser is on, which breaks anywhere the image renders
  off its own page — feeds, listings, the homepage.
- **Share cards are the exception**: global, absolute, in
  `static/images/share/`. They're referenced by absolute URL in meta tags
  and cached by external scrapers, so their paths must stay stable.

### Tera gotchas

- **Macros can't call sibling macros in the same file via `self::`** when
  invoked through template inheritance — `self` resolves to the template
  being rendered, not the file the macro lives in. Self-importing to fix
  it causes infinite recursion and a stack overflow. Inline the markup.
- **`{% set %}` inside `{% if %}` doesn't escape the block.** Duplicate
  the call instead of hoisting a variable.
- **Context variables aren't reliably visible inside macros.** Pass them
  in explicitly, as `base.html` does with `current_path`.

### Performance baseline

Homepage, production build: ~65 KB. CSS is the largest asset at ~34 KB
(~8 KB gzipped). No webfonts — `font-sans` uses the system stack, and
adding one family would roughly double the page weight.

`zola serve` injects a 68 KB `livereload.js` that is not in the production
build. Measure against `zola build` output, not the dev server.
