# Roadmap

Remaining work for wjcreations.com. Conventions, front matter reference, and
build instructions live in `README.md`.

## Next session — start here

1. Write the Pixel Plumb project page from the Operations section onward.
   The colour-maths section is done; everything below it is still draft.
2. Verify the invented claims in that draft (see Content, below).
3. Delete `instructions.txt` — superseded by `dev.sh` and the README.

---

## Blocking launch

### Content

- **Pixel Plumb project page, Operations onward.** Consider mixing
  `{{ compare() }}` and `{% media() %}` rather than four identical
  two-panel boxes in a row — `compare` where the difference is subtle,
  `media` where one result plus an explanation is enough.
- **Verify the drafted claims.** Several lines in the current draft were
  written from description, not from the code:
  - the `edit_op` "source of most of the bugs in the first month" line
  - "Atkinson is the default, chosen empirically"
  - the dithering list (Floyd–Steinberg, Atkinson, Sierra, Bayer)
  - the YAML pipeline example — replace with real copy-button output
  - "less than 24 colours" in the OkLab-falls-short note. If measured,
    say so; if it's an impression, soften it.
  - the Status section still says v0.1.0
- **Projects section blurb.** Currently a placeholder about having one
  project.
- **Fix Exhibit B in the Helix article.** The `auto-format = true` example
  is a no-op; it's already the default for Rust. Use the real
  `config.toml` / `languages.toml`, and make the sharper point: the config
  is entirely *optional*. There is no Rust section in it at all —
  rust-analyzer, tree-sitter, and diagnostics all run on built-in
  defaults. Consider pasting real `hx --health rust` output as evidence.
- **Add cascading error messages to the Typst article.** One real LaTeX
  mistake producing a wall of unrelated errors.
- **`description` front matter on every page.** Only `about.md` has one.
  `meta_macro.html` reads it first for the meta description and
  `og:description`; without it, previews fall back to the first 150
  characters of the article.

### Contact

- Decide between a footer link, a contact page, or both.
- **Set up domain forwarding** rather than exposing the Gmail address:
  `hello@wjcreations.com` → Gmail via ImprovMX (free tier, MX records in
  Route 53) or Cloudflare Email Routing. Killable if it gets scraped, and
  it looks better on a portfolio site.
- Note that the Gmail address is already public in git commit metadata,
  so obfuscation on the page would be theatre. A separate address is the
  actual fix.
- Use a real `mailto:` link so it works on mobile.

### Assets

- **Shrink the large source images before launch.** `pp_source.png` is
  1.2 MB and `ship_in_the_night_*.webp` is 507 KB — together they dwarf
  the entire rest of the site, which is under 50 KB. Both display at a
  few hundred pixels.

### Templates

- `blog.html` and `section.html` need `{% block title %}` overrides. Their
  browser tabs currently show only the site title.

### Deploy

- Set `base_url` in `zola.toml` to `https://wjcreations.com`. Every
  permalink and Open Graph tag depends on it.
- Add `*:Zone.Identifier` to `.gitignore` — WSL artifact from the work
  machine. Watch for CRLF line endings from that box too.
- **Site → GitHub Pages.** Repo settings → Pages, custom domain, CNAME
  record in Route 53. Requires a public repo on the free tier.
- **Pixel Plumb → Cloudflare Pages, not GitHub Pages.** CF can set
  response headers via a `_headers` file; GitHub Pages cannot set them at
  all. That matters because threading in WASM needs `SharedArrayBuffer`,
  which needs COOP/COEP headers — so GitHub Pages would permanently close
  the door on rayon. Same free tier, same custom domains, same auto-TLS.
  Subdomain: `pixelplumb.wjcreations.com`.
- Enforce HTTPS on both once certs provision.
- Add a `← wjcreations.com` back-link in the Pixel Plumb app header.
  Separate origin means no shared nav, and a visitor who clicks through
  currently has no way back.
- The site and the subdomain deploy independently. `pixelplumb.` can go
  live first.

### Before shipping

- Click through every page of a `zola build`, including the taxonomy
  pages. `taxonomy_list.html` and `taxonomy_single.html` haven't been
  touched since the restructure.
- Confirm `gen-share-cards.sh` has the `magick`/`convert` detection block.
  This machine has ImageMagick 6, where the binary is `convert`.
- Check whether the q16 build is emitting 16-bit PNGs. If `file` says
  16-bit, add `-depth 8` to the share-card command.
- Update `README.md`: it predates the `media()` shortcode, the revised
  `compare()` parameters, and the lightbox.

---

## Backlog

- **Learn CSS and layout properly.** Vibe-coding the styling stopped
  paying off. Most of the recent pain would have been ten seconds in the
  DevTools Elements panel — inspect the element, read the computed width,
  see which rule wins. Reach for that before changing markup.
- **Replace the lightbox.** `base.html` has a vibe-coded `<dialog>` +
  delegated click handler. It works, but it hasn't been reviewed line by
  line. Revisit once the CSS/JS knowledge is there.
- **Design tokens.** Replace hardcoded `slate-*` / `teal-*` with `@theme`
  tokens in `sass/tailwind.css`, ideally in OkLCH. Makes a palette change
  one edit instead of a find-and-replace across eleven templates. Cost
  scales with template count, so sooner is cheaper. (This is what "make a
  theme" actually means here — a Zola *theme* is a distribution format for
  sharing and wouldn't centralise anything.)
- **Heading levels, refined.** `page.html` emits no `<h1>`, so About
  starting its sections at `#` is correct. But `article.html` and
  `project.html` both emit `<h1>{{ page.title }}</h1>`, so in blog posts
  and project pages the `#` headings are siblings of the title rather
  than children. Only those two need shifting.
- **Taxonomies.** Seven tag pages and a category page for two articles.
  Revisit once there's content to justify them.
- **Colocation for `about.md`** — still a flat file. Fine unless it gains
  images.
- **Watercolour gallery**, promised on the About page.
- **Git-based CMS.** Sveltia CMS for browser-based markdown editing
  (Decap is stagnant; Sveltia needs no auth backend). Verify TOML front
  matter support on a throwaway repo first — these tools default to YAML.
  Revisit after launch.

### Multi-page projects

Not needed yet, but the mechanism, so it isn't rediscovered later:

- Rename a project's `index.md` to `_index.md` and it becomes a section.
  Child pages then nest under the project URL
  (`/projects/pixel-plumb/architecture/`). The project's own URL doesn't
  change, and front matter carries over unchanged.
- `projects.html` would need `section.subsections` instead of
  `section.pages`.
- Split when the audiences differ (pitch vs. implementation) or when part
  of it deserves its own URL — not merely when the page gets long.

### Content ideas

- **"X is better than Y" series:** "Anything Is Better Than WordPress"
  (strongest — the EC2 story is yours and the ending writes itself),
  Cargo vs CMake, OkLab vs HSL, nearest-neighbour vs bilinear,
  data-driven Lua, Leptos vs React.
- Consider one "X is great" piece so the blog isn't only contempt.

### Project ideas

- **Lines and veils tool.** TTRPG safety tool; existing options are poor.
  Needs a database — participants must submit their own entries, and
  that's the whole point. Good excuse to learn serverless.
  - Traffic is bursty and tiny, so per-request pricing fits.
  - `workers-rs` on Cloudflare Workers keeps it in Rust and reuses WASM
    knowledge; Fly.io + Axum is the pragmatic fallback if the ergonomics
    fight back.
  - Schema is small: `tables(id, created_at, expires_at)` and
    `entries(id, table_id, kind, text, created_at)`. No accounts — the
    table code is the credential.
  - **Anonymity is the product.** No accounts, no IP logging, and think
    about whether display order leaks who submitted first. Shuffle on
    read.
  - **Expire the data.** A permanent database of people's trauma triggers
    is a liability. Auto-delete after the session or 30 days.
  - Own subdomain — independent stack, independent deploy, and the blog
    can't go down because a database did.
- **QRC client** (JSON-RPC over TCP 1710) and a **Q-SYS Lua linter** —
  from the AV work. The linter is the stronger portfolio piece.

---

## Pixel Plumb (separate repo)

- **Rename is incomplete.** Repo and docs say Pixel Plumb; internal crate
  names still say `pixelizer`. Do before v0.2.0. Mechanically it's two
  `git mv`s plus `git grep -lz pixelizer | xargs -0 sed -i` — the time
  cost is reading the diff, not making the change.
- **Tag a release** covering the PNG encoder fix and the RGB/OkLab
  mapping selector. Then update the project page's Status section to
  match.
- **PNG compression level.** Output was written at "superfast" — running
  it back through `convert -define png:compression-level=9` cut a file
  from 646 KB to 352 KB, a 46% reduction with identical pixels. Verify
  the encoder now sets max compression on export. Preview can stay fast;
  export should not.
- **Check for duplicate encode paths.** Both the RGBA bug and the
  compression bug point at preview and export being separate code. If so,
  consolidate to one function with a final-output flag.
- **Adaptive palette selection is weaker than median cut.** At equal
  palette sizes and equal source, ImageMagick's median cut beat it. The
  diffusion maths wins when the palette is held fixed — so this is a
  palette-selection problem, not a colour-space one, and it's the single
  biggest quality lever left.
- **Keep the comparison as a regression test.** Fixed Lacking64 palette,
  same source, both tools, same algorithm. Reproducible evidence for the
  project page and a check against future changes.
