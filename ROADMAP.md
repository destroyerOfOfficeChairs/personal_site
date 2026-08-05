# Roadmap

Working notes for wjcreations.com. Delete or archive once the site is live
and the backlog is empty.

## Next session — start here

1. Rename `templates/shortcodes/pixel_image.html` → `pixel.html` so the
   shortcode is `{{ pixel(...) }}`, matching the usage comment inside it.
2. Do the colocation restructure (see below). Everything else is easier
   once paths are stable.

---

## Blocking launch

### Colocation restructure

Move each page to its own directory so images live next to the content
that uses them.

```
content/blog/helix-vs-neovim/index.md
content/blog/typst-vs-latex/index.md
content/projects/pixel-plumb/index.md
```

- Directory name becomes the slug — drop the `slug =` lines from front matter.
- Image references become bare filenames: `hero = "helix.png"`.
- `zola build` afterward and confirm URLs land where expected.
- Share cards stay in `static/images/share/` — they're referenced by
  absolute URL from meta tags and scraped by external services, so their
  paths need to stay stable.

### Images to create

| Image | Size | Used by |
|---|---|---|
| Featured "before" | source res | homepage featured block |
| Featured "after" | 96x64 | homepage featured block |
| Share card (default) | 1200x630 | `meta_macro.html` fallback |
| Pixel Plumb body images | varies | `{{ pixel() }}` on project page |

Reminders:
- On-site images: native resolution, indexed PNG, scaled by CSS. Display
  size must be an integer multiple of native size.
- Share cards: real 1200x630 files, pre-upscaled nearest-neighbor.
  Social platforms resize server-side and ignore CSS.

### Content to write

- **Pixel Plumb project page body.** Currently placeholder. Cover OkLab
  palette matching, linear-light error diffusion, why most tools get this
  wrong, pipeline architecture. Use the `{{ pixel() }}` shortcode for
  dithering comparisons.
- **Projects section blurb.** Currently "Things I've built."
- **Fix Exhibit B in the Helix article.** The `auto-format = true` example
  is a no-op — it's already the default for Rust. Replace with the real
  `config.toml` / `languages.toml`, and make the point that the entire
  config is *optional*: no Rust section exists in it at all.
- **Add cascading error messages to the Typst article.** One real mistake
  producing a wall of unrelated errors.

### Templates

- `projects.html` listing is a plain stub. Build a `project_card` macro in
  `project_macros.html` and use it here.
- Consider whether `article.html` and `page.html` have actually diverged.
  If not, one of them is dead weight.

### Deploy

- Set `base_url` in `zola.toml` to `https://wjcreations.com`.
- Favicon — none exists. 32x32 pixel art, matching the avatar.
- GitHub Pages for the site: repo settings → Pages, custom domain,
  CNAME record in Route 53.
- GitHub Pages for `pixel-plumb`: same, subdomain
  `pixelplumb.wjcreations.com` → `destroyerofofficechairs.github.io`.
- Enforce HTTPS on both once certs provision.
- Add a `← wjcreations.com` back-link in the Pixel Plumb app header —
  separate origin means no shared nav.

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
- **Git-based CMS.** Sveltia CMS for markdown editing in a browser.
  Pinned; revisit after launch.
- **Pixel Plumb rename** is incomplete: repo and docs say Pixel Plumb,
  internal crate names still say `pixelizer`. Before v0.2.0.
- **Article series ideas:** "Anything Is Better Than WordPress",
  Cargo vs CMake, OkLab vs HSL, nearest-neighbor vs bilinear,
  data-driven Lua, Leptos vs React.

---

## Conventions

Decisions already made, recorded so they don't get relitigated.

- **Pixel art at native resolution**, scaled with `image-rendering:
  pixelated` via the `pixelated` utility in `sass/tailwind.css`. Never
  pre-upscale on-site images; never use Zola's `resize_image` on them
  (it resamples in the wrong color space and blurs hard edges).
- **Display sizes are integer multiples of native size.** 64px source →
  128 or 192, never 96. Non-integer scaling gives uneven pixel widths.
- **`hero` vs `share`** are separate front matter fields with different
  requirements. Omit `share` to fall back to the site default card.
- **Indexed PNG** for all pixel art. Typical sizes: 64x64 avatar ≈ 3 KB,
  96x64 article hero < 1 KB.
- **Every image on the site is made with Pixel Plumb.** The site is a
  demonstration of the tool.
- **`dev.sh` runs in the foreground.** Initial CSS build fails loudly
  before any watcher starts.
