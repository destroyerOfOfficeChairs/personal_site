# Roadmap

Working notes for wjcreations.com. Delete or archive once the site is live
and the backlog is empty.

## Next session — start here

1. Regenerate all images with the fixed Pixel Plumb encoder. Verify with
   `file content/**/*.png` — every one should say **8-bit colormap**, not
   RGBA. (`pp_output.png` was 13.4 KB as RGBA; should land at 1–2 KB.)
2. Create the missing images (table below).
3. Write the Pixel Plumb project page body.

---

## Blocking launch

### Images to create

| Image                   | Size       | Used by                         |
|-------------------------|------------|---------------------------------|
| Share card (default)    | 1200x630   | `meta_macro.html` fallback      |
| Favicon                 | 32x32      | `base.html` — none exists yet   |
| Pixel Plumb body images | varies     | `{{ pixel() }}` on project page |

Featured before/after images exist (`content/projects/pixel-plumb/`) but
need regenerating as indexed PNG.

Reminders:
- On-site pixel art: native resolution, indexed PNG, scaled by CSS.
  Display size must be an integer multiple of native size.
- Share cards: real 1200x630 files, pre-upscaled nearest-neighbor.
  Social platforms resize server-side and ignore CSS. Live in
  `static/images/share/`, referenced by absolute path.

### Content to write

- **Pixel Plumb project page body.** Currently placeholder. Cover OkLab
  palette matching, linear-light error diffusion, why most tools get this
  wrong, pipeline architecture. Use the `{{ pixel() }}` shortcode for
  dithering comparisons.
- **Projects section blurb.** Currently "Things I've built."
- **Fix Exhibit B in the Helix article.** The `auto-format = true` example
  is a no-op — it's already the default for Rust. Replace with the real
  `config.toml` / `languages.toml`, and make the point that the entire
  config is *optional*: no Rust section exists in it at all. Consider
  pasting real `hx --health rust` output as evidence.
- **Add cascading error messages to the Typst article.** One real mistake
  producing a wall of unrelated errors.

### Templates

- `projects.html` listing is a plain stub. Build a `project_card` macro in
  `project_macros.html` and use it here.
- Consider whether `article.html` and `page.html` have actually diverged.
  If not, one of them is dead weight. Same question for `section.html` vs
  `blog.html`.
- `blog.html` / `section.html` still need `{% block title %}` overrides —
  their browser tabs currently show the site title only.

### Deploy

- Set `base_url` in `zola.toml` to `https://wjcreations.com`.
- Add `*:Zone.Identifier` to `.gitignore` (WSL artifact from the work
  machine). Watch for CRLF line endings from that box too.
- GitHub Pages for the site: repo settings → Pages, custom domain,
  CNAME record in Route 53.
- GitHub Pages for `pixel-plumb`: same, subdomain
  `pixelplumb.wjcreations.com` → `destroyerofofficechairs.github.io`.
  Note: Pages requires a **public** repo on the free tier.
- Enforce HTTPS on both once certs provision.
- Add a `← wjcreations.com` back-link in the Pixel Plumb app header —
  separate origin means no shared nav.
- The site and the subdomain deploy independently. `pixelplumb.` can go
  live before wjcreations.com is finished.

---

## Backlog

- **Heading levels.** Articles use `#` for section headings, which is an
  h1 alongside the page title. Shift everything down one level.
- **Taxonomies.** 7 tag pages and a category page for 2 articles. Revisit
  once there's enough content to justify them.
- **`instructions.txt`** in the repo root — read it, then delete or fold
  into a README.
- **README.md** — none exists. Document the build (`./dev.sh`), the image
  size conventions, and the front matter fields each template expects.
- **Git-based CMS.** Sveltia CMS for markdown editing in a browser
  (Decap is stagnant; Sveltia needs no auth backend). Pinned; revisit
  after launch. Verify TOML front matter support on a throwaway repo
  first — these tools default to YAML.
- **Article series ideas:** "Anything Is Better Than WordPress"
  (strongest — you have the EC2 story and the ending writes itself),
  Cargo vs CMake, OkLab vs HSL, nearest-neighbor vs bilinear,
  data-driven Lua, Leptos vs React. Consider one "X is great" piece so
  the blog isn't only contempt.
- **Colocation for `about.md`** — still a flat file. Fine as-is unless it
  gains images.

### Pixel Plumb (separate repo)

- **Rename is incomplete.** Repo and docs say Pixel Plumb, internal crate
  names still say `pixelizer`. Do before v0.2.0. The mechanical part:
  two `git mv`s plus `git grep -lz pixelizer | xargs -0 sed -i` — the
  time cost is reading the diff, not making the change.
- **Tag v0.1.1** for the PNG encoder fix.
- **Check for duplicate encode paths.** The RGBA bug suggests preview and
  export may be separate code. If so, consolidate to one function with a
  final-output flag.

---

## Conventions

Decisions already made, recorded so they don't get relitigated.

### Images

- **Pixel art: never resized by Zola.** Native resolution, indexed PNG,
  scaled by CSS with `image-rendering: pixelated` (the `pixelated`
  utility in `sass/tailwind.css`). `resize_image` resamples in the wrong
  color space and blurs hard edges.
- **Photographs: do use `resize_image`,** with `format="webp",
  quality=80`. Smooth resampling is correct for photos. Without an
  explicit `quality`, WebP output is lossless and barely smaller.
  (`format` defaults to `"auto"`, which preserves the input format —
  hence PNG in, PNG out.)
- The distinction is whether hard pixel edges carry meaning.
- **Display sizes are integer multiples of native size.** 64px source →
  128 or 192, never 96. Non-integer scaling gives uneven pixel widths.
- `static/processed_images/` is Zola's build cache and belongs in the
  source tree — that's by design, not duplication. Orphaned entries
  accumulate when resize arguments change; clear with
  `rm -rf static/processed_images && zola build`.

### Paths

- **Colocated assets are page-relative**, so templates must prefix them:
  `{{ page.permalink }}{{ page.extra.hero }}`. A bare relative path
  resolves against whatever URL the browser is on, which breaks anywhere
  the image is rendered off its own page (feeds, listings, homepage).
- **`hero` vs `share`** are separate front matter fields with different
  requirements. `hero` is colocated and relative; `share` is global and
  absolute. Omit `share` to fall back to the site default card.

### Structure

- **Every image on the site is made with Pixel Plumb.** The site is a
  demonstration of the tool.
- **`dev.sh` runs in the foreground.** Initial CSS build fails loudly
  before any watcher starts. The old backgrounded version hid Tailwind
  errors in `/tmp` and silently served stale CSS.
- **Tera macros can't call sibling macros in the same file via `self::`**
  when invoked through template inheritance, and self-importing causes
  infinite recursion. Inline the markup instead.
- **Shortcode filename = shortcode name.** `templates/shortcodes/pixel.html`
  is called as `{{ pixel(...) }}`.

### Baseline

Production page weight (homepage, excluding `zola serve`'s injected
68 KB `livereload.js`): ~65 KB once images are re-indexed. CSS is the
largest asset at ~34 KB, which compresses to ~8 KB over the wire.
No webfonts — `font-sans` uses the system stack. Keep it that way.
