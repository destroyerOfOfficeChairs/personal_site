+++
title = "Helix Is Better Than Neovim"
date = 2026-05-09
description = "Neovim asks you to build an editor before you can use one. Helix ships with the parts already attached."

# This is how you set the slug:
# slug = "neovim-sucks"

[taxonomies]
categories = ["computers"]
tags = ["helix", "rust", "linux", "coding", "writing"]

[extra]
# hero: on-site image. Native pixel-art resolution (96x64), scaled up
# by CSS with image-rendering: pixelated. Keep it small -- do NOT
# pre-upscale, or the browser blurs an already-blurry file.
hero = "helix_logo_pixelplumb.png"

# share: Open Graph / Twitter card image. Must be a real 1200x630 file,
# pre-upscaled with nearest-neighbor (120x63 native at 10x). Social
# platforms resize server-side with smooth filters and ignore CSS, and
# they drop images below ~300px entirely. Omit this key to fall back to
# the site default share card.

# UNCOMMENT THE FOLLOWING LINE WHEN YOU MAKE A SHARE IMAGE
#share = "/images/helix_share.png"

subtitle = "I escaped configuration hell. You can too, if you stop enjoying it."
+++

You saw your favorite tech YouTuber using Neovim and decided to try it yourself. It's hard to get anything done because you spend so much time trying to understand why your copy-pasted config files are not working the way you want.

It's not your fault. Neovim actually sucks.

I did the same thing for years. Let me show you what I stopped doing.

# Exhibit A: Turning The Editor On

You have installed Neovim. You would like it to know what a Rust function is.

First, your config downloads a package manager. At runtime. From the internet. Here is the officially recommended bootstrap block:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none",
    "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
```

Your **text editor configuration** needs you to write a fucking bootstrapper just to _start_ working with packages. And that's before any of it does anything. Now you need:

- `nvim-lspconfig`, to talk to language servers
- `mason.nvim`, to install the language servers
- `mason-lspconfig`, to make those two agree on what a language server is called
- `nvim-cmp`, for completion
- `cmp-nvim-lsp`, to bridge completion to LSP
- `LuaSnip`, because `nvim-cmp` requires a snippet engine whether or not you want snippets
- `cmp_luasnip`, to bridge the snippet engine to the completion engine

Seven plugins, three of which exist purely to introduce the other four to each other. Then you get to go through _pages and pages_ of documentation and _hours_ of configuration before any of it produces a single diagnostic.

Want a language server in Helix? Here's what you do:

```
$ rustup component add rust-analyzer
```

That's the whole thing. You just install a language server.

So does the Neovim user, eventually, after assembling the machine that installs it. The difference is that the LSP client already shipped in the Helix binary. You dropped a server on the disk and Helix knew what to do with it.

# Exhibit B: The Config

Here is my entire `config.toml`. This is not an excerpt.

```toml
[editor]
bufferline = "multiple"

[keys.insert]
j = { j = "normal_mode" }

[editor.soft-wrap]
wrap-indicator = ""

[editor.statusline]
left = ["mode", "spinner"]
center = ["file-name"]
right = ["diagnostics", "position", "position-percentage", "file-type"]
```

Four settings and a keybind. A buffer line, `jj` to escape insert mode, a status line arrangement I like, and one cosmetic tweak to soft wrap.

Not one line of that is required. Delete the file and Helix still opens, still highlights, still completes, still shows me diagnostics. It just looks slightly less like I want it to.

I also have a `languages.toml`:

```toml
# A grammar checker for prose
[language-server.harper-ls]
command = "harper-ls"
args = ["--stdio"]

# Wrap plain text and Typst at 80 columns, with a ruler
[[language]]
name = "typst"
scope = "source.typst"
file-types = ["typ", "md"]
text-width = 80
rulers = [81]
soft-wrap.enable = true
soft-wrap.wrap-at-text-width = true
language-servers = ["tinymist", "harper-ls"]

# Tailwind class completion inside HTML
[language-server.tailwindcss-ls]
command = "tailwindcss-language-server"
args = ["--stdio"]

[[language]]
name = "html"
language-servers = ["tailwindcss-ls", "vscode-html-language-server"]
```

Every one of those is something I *added*. It's just adding a grammar checker and some Tailwind support that Helix doesn't ship, as well as wrapping text in the way I prefer.

Here's the part I want you to notice. There is no section in that file turning on Rust support. There is no section installing rust-analyzer, or wiring it to the language server, or registering a tree-sitter grammar. I never added any of that to my config because I never needed to -- Helix did it for me.

You've seen my config. Those 2 files are _all of it_. Now look at this `--health` output:

```
mind@peace:~/repos/helix_config$ hx --health rust
Configured language servers:
  ✓ rust-analyzer: /home/mind/.cargo/bin/rust-analyzer
Configured debug adapter:
  ✘ 'lldb-dap' not found in $PATH
Configured formatter: None
Tree-sitter parser: ✓
Highlight queries: ✓
Textobject queries: ✓
Indent queries: ✓
Tags queries: ✓
Rainbow queries: ✓
```

That's not from my config. Helix compiles a default `languages.toml` into
the binary, covering every language it supports and the servers people
actually use for them. The file in my config directory doesn't *enable*
things -- it *overrides* things. Mine is entirely additions and preferences,
which is why it's all optional.

The debug adapter line is a ✘ because I've never installed one. That's Helix telling me the truth about my own machine, not a failure -- and notice it still knew what adapter to look for.

## The bottom line on configs

My config is a list of opinions. Yours is a list of prerequisites.

# Exhibit C: Multiple Cursors

Neovim: install `vim-visual-multi`. Learn its keybinds, which are not Vim keybinds. Discover it conflicts with your surround plugin. Read three GitHub issues. Add a workaround to your config with a comment explaining the workaround. Feel a small, hollow pride.

Helix:

Type `%` to select the whole file, then `s` to split the selection, then `foo`, and every occurrence of `foo` in the file is a cursor.

No plugins. No modes. In Helix, selections are the primitive and everything else is built on them.

# Exhibit D: The Thing That Actually Matters

In Neovim, you press `dw`. Delete word. Verb, then noun.

You have now told the editor to do something to a region of text **you cannot see**. You are predicting the outcome. If you were wrong -- if the word boundary wasn't where you thought, if there was punctuation, if you were one character off -- you find out *after* the text is gone, and you press `u`, and you try again with a different motion.

In Helix, you press `w`. The word lights up. You can see it. It is exactly the text that will be affected, rendered on your screen, before anything happens. *Then* you press `d`.

Vim's model asks you to hold a mental simulation of the editor's text objects and check your work by undoing. Helix's model puts the simulation on the screen. One of these is a user interface. The other is a memory test that you have gotten good at and now mistake for a skill.

It takes about a day to switch. You will spend that day pressing `dw` and deleting a character and selecting a word. Then it will be over and you will never think about it again.

# Your Objections Are Stupid

**"Just use kickstart.nvim / LazyVim / AstroNvim."** Sure. And notice what you just did: you recommended a *distribution* of an editor. Distributions exist when the defaults are wrong. You've conceded the entire argument and dressed it up as a solution. Also, now you're running four thousand lines of someone else's Lua that you don't understand, which is precisely the situation you think Neovim's configurability is protecting you from.

**"Muh muscle memory."** You learned Vim's keybinds. You are capable of learning a second thing.

**"Neovim is more powerful because it's programmable."** Emacs is more programmable than both and you don't use that either, so let's be honest that this was never the criterion.

**"Helix has no plugin system."** This one's fair. The Steel/Scheme plugin work has been in progress for a long time and isn't stable. If you need a niche integration, Helix may genuinely not have it.

But interrogate what you actually need plugins *for*. LSP: built in. Tree-sitter: built in. Fuzzy file picker: built in. Multi-cursors: built in. Git gutter: built in. The overwhelming majority of a Neovim plugin list is reconstructing features Helix ships.

# The Verdict

Neovim is a shitty hobby that YouTube clickbait has convinced you is an actual tool. The cost of the hobby is billed in hours you thought you were spending on programming.

I wanted to write software. I downloaded one binary. It worked.

That's the whole review.
