+++
title = "Helix Is Better Than Neovim"
date = 2026-05-09
slug = "helix-vs-neovim"
[taxonomies]
categories = ["computers"]
tags = ["helix", "rust", "linux", "coding", "writing"]
[extra]
# hero: on-site image. Native pixel-art resolution (96x64), scaled up
# by CSS with image-rendering: pixelated. Keep it small — do NOT
# pre-upscale, or the browser blurs an already-blurry file.
hero = "/images/helix_logo_pixelplumb.png"

# share: Open Graph / Twitter card image. Must be a real 1200x630 file,
# pre-upscaled with nearest-neighbor (120x63 native at 10x). Social
# platforms resize server-side with smooth filters and ignore CSS, and
# they drop images below ~300px entirely. Omit this key to fall back to
# the site default share card.

# UNCOMMENT THE FOLLOWING LINE WHEN YOU MAKE A SHARE IMAGE
#share = "/images/helix_share.png"

subtitle = "I escaped configuration hell. You can too, if you stop enjoying it."
+++

You saw your favorite tech YouTuber using NeoVim and decided to try it yourself. It's hard to get anything done because you spend so much time trying to understand why your copy-pasted config files are not working the way you want.

It's not your fault. NeoVim actually sucks.

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

Read that again. Your **text editor configuration** contains error handling for a failed `git clone`. There is a code path in your `init.lua` for "the network is down." You have written a bootstrapper. You were trying to edit a file.

Here is the Helix equivalent:

```
$ rustup component add rust-analyzer
```

That's the whole thing. Syntax highlighting, completion, inline diagnostics, goto-definition. It shipped in the binary. Nobody had to be introduced to anyone.

# Exhibit B: The Config

Here is a Helix config that turns on format-on-save for Rust and picks a theme.

```toml
# config.toml
theme = "base16_default_dark"

[editor]
line-number = "relative"
```

```toml
# languages.toml
[[language]]
name = "rust"
auto-format = true
```

Six meaningful lines. Two files. Done.

The equivalent in NeoVim is _several_ files of bullshit. I will not be adding that here for comparison's sake.

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

# Your Objections Are Terrible

**"Just use kickstart.nvim / LazyVim / AstroNvim."** Sure. And notice what you just did: you recommended a *distribution* of an editor. Distributions exist when the defaults are wrong. You've conceded the entire argument and dressed it up as a solution. Also, now you're running four thousand lines of someone else's Lua that you don't understand, which is precisely the situation you think Neovim's configurability was protecting you from.

**"Helix has no plugin system."** This one's fair, and it's the real answer to "why not Helix." The Steel/Scheme plugin work has been in progress for a long time and isn't stable. If you need a niche integration, Helix may genuinely not have it, and I'm not going to pretend otherwise.

But interrogate what you actually need plugins *for*. LSP: built in. Tree-sitter: built in. Fuzzy file picker: built in. Multi-cursors: built in. Git gutter: built in. Debugger: built in. The overwhelming majority of a Neovim plugin list is reconstructing features Helix ships.

**"Muh muscle memory."** You learned Vim's keybinds. You are capable of learning a second thing.

**"Neovim is more powerful because it's programmable."** Emacs is more programmable than both and you don't use that either, so let's be honest that this was never the criterion.

# The Verdict

Neovim is a shitty hobby that's been marketed to you as a tool. The cost of the hobby is billed in hours you thought you were working on something.

I wanted to write software. I downloaded one binary. It worked.

That's the whole review.
