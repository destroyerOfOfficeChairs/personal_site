# Roadmap

Remaining work for wjcreations.com. Conventions, front matter reference, and
build instructions live in `README.md`.

## Next session — start here

1. Write the Pixel Plumb project page body. It's the last substantial piece
   and the reason the projects section exists.
2. Delete `instructions.txt` — superseded by `dev.sh` and the README.

---

## Blocking launch

### Content

- **Pixel Plumb project page body.** Currently placeholder. Cover OkLab
  palette matching, linear-light error diffusion, why most tools get this
  wrong, and the pipeline architecture. Use `{{ pixel_art() }}` for
  dithering comparisons — make the images as you need them.
- **Projects section blurb.** Currently a placeholder about having one
  project.
- **Fix Exhibit B in the Helix article.** The `auto-format = true` example
  is a no-op; it's already the default for Rust. Use the real
  `config.toml` / `languages.toml` instead, and make the sharper point:
  the config is entirely *optional*. There is no Rust section in it at
  all — rust-analyzer, tree-sitter, and diagnostics run on built-in
  defaults. Consider pasting real `hx --health rust` output as evidence.
- **Add cascading error messages to the Typst article.** One real LaTeX
  mistake producing a wall of unrelated errors.

### Templates

- `blog.html` and `section.html` need `{% block title %}` overrides. Their
  browser tabs currently show only the site title.

### Deploy

- Set `base_url` in `zola.toml` to `https://wjcreations.com`. Every
  permalink and Open Graph tag depends on it.
- Add `*:Zone.Identifier` to `.gitignore` — WSL artifact from the work
  machine. Watch for CRLF line endings from that box too.
- GitHub Pages for the site: repo settings → Pages, custom domain, CNAME
  record in Route 53.
- GitHub Pages for `pixel-plumb`: same, with subdomain
  `pixelplumb.wjcreations.com` → `destroyerofofficechairs.github.io`.
  Pages requires a public repo on the free tier.
- Enforce HTTPS on both once certs provision.
- Add a `← wjcreations.com` back-link in the Pixel Plumb app header.
  Separate origin means no shared nav, and a visitor who clicks through
  currently has no way back.
- The site and the subdomain deploy independently. `pixelplumb.` can go
  live before wjcreations.com is finished.

### Before shipping

- Click through every page of a `zola build`, including the taxonomy
  pages. `taxonomy_list.html` and `taxonomy_single.html` haven't been
  touched since the restructure and may reference things that moved.

---

## Backlog

- **Design tokens.** Replace hardcoded `slate-*` / `teal-*` classes with
  `@theme` tokens in `sass/tailwind.css`, ideally in OkLCH. Makes a
  palette change one edit instead of a find-and-replace across eleven
  templates. Mechanical refactor; cost scales with template count, so
  sooner is cheaper. (This is what "make a theme" actually means here —
  a Zola *theme* is a distribution format for sharing, and wouldn't
  centralize anything.)
- **Heading levels.** Articles use `#` for section headings, producing
  multiple h1s alongside the page title. Shift everything down one level.
- **Taxonomies.** Seven tag pages and a category page for two articles.
  Revisit once there's enough content to justify them.
- **Colocation for `about.md`** — still a flat file. Fine unless it gains
  images.
- **Git-based CMS.** Sveltia CMS for browser-based markdown editing
  (Decap is stagnant; Sveltia needs no auth backend). Verify TOML front
  matter support on a throwaway repo first — these tools default to YAML.
  Revisit after launch.

### Content ideas

- **Article series, "X is better than Y":** "Anything Is Better Than
  WordPress" (strongest — the EC2 story is yours and the ending writes
  itself), Cargo vs CMake, OkLab vs HSL, nearest-neighbor vs bilinear,
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
  - **Expire the data.** A permanent database of people's trauma
    triggers is a liability. Auto-delete after the session or 30 days.
  - Would live at its own subdomain — independent stack, independent
    deploy, and the blog can't go down because a database did.
- **QRC client** (JSON-RPC over TCP 1710) and a **Q-SYS Lua linter** —
  from the AV work. The linter is the stronger portfolio piece.

### Pixel Plumb (separate repo)

- **Rename is incomplete.** Repo and docs say Pixel Plumb; internal crate
  names still say `pixelizer`. Do before v0.2.0. Mechanically it's two
  `git mv`s plus `git grep -lz pixelizer | xargs -0 sed -i` — the time
  cost is reading the diff, not making the change.
- **Tag v0.1.1** for the PNG encoder fix (was emitting 32-bit RGBA at
  superfast compression instead of indexed).
