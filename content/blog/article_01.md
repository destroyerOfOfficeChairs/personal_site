+++
title = "Helix Is Better Than Neovim"
date = 2026-05-02
[taxonomies]
categories = ["computers"]
tags = ["helix", "linux", "coding", "writing"]
[extra]
hero = "/images/helix_editor_pixelart_upscaled.png"
subtitle = "I said what I said."
+++

I spent way too many hours trying to get a good Neovim setup. After endless hours of following tutorials, and gluing together way too many plugins, and generally not really knowing what was going on, I decided I needed a modal editor that _just works_.

Enter Helix.

# The Out-of-the-Box Experience

Helix ships with all the good stuff built into a single binary. You open a `.rs` file, and you instantly have syntax highlighting, auto-completion, and inline diagnostics. The same goes for typesetting in Typst; the language support is just there, ready to go. It respects your time.

Neovim requires a plugin manager, an LSP configuration layer, and a tree-sitter setup before it even knows what a Rust borrow checker is. 

## My Own Config

I know I just told you that you that Helix is great out-of-the-box, but you _can_ configure it. Here's my config:

https://github.com/destroyerOfOfficeChairs/helix_config

my own config is a handful of lines in 2 files. That's hardly worth noting compared to what I've been through to get Vim and Neovim working right.

# Noun-Verb over Verb-Noun

If you're coming from traditional Vim keybindings, Helix's Kakoune-inspired selection model feels backwards for about five minutes. Then, it feels like enlightenment. 

In Neovim, you press `dw` to delete a word (verb -> noun). You hope it deletes exactly what you think it will. In Helix, you press `wd` to select the word, *see exactly what is highlighted*, and *then* delete it (noun -> verb). It removes the mental overhead and the constant need to undo mistakes because you misjudged a spatial motion. 

# I Use Rust BTW

It's made with Rust!

It’s no secret that Helix is written in Rust, and that matters more than just aesthetic alignment. When you are pushing the limits of the borrow checker or debugging complex GPU pipelines in `wgpu`, you want an editor that is as stable and performant as the code you’re trying to ship.

- **Native Speed:** Because it is a compiled Rust binary, Helix doesn't suffer from the "garbage collection stutters" or the interpreted script lag that can plague other editors once they are weighed down by plugins.
- **The Best LSP Integration:** Since the community is heavily overlapping with the Rust-Analyzer contributors, the Rust support in Helix is arguably the best in the business. It handles massive workspaces and complex macros without breaking a sweat.
- **Modern Systems Thinking:** Just like Rust, Helix was built with "modern defaults." It doesn't force you to live in 1976. It assumes you want multi-cursors, it assumes you want Tree-sitter, and it assumes you want a fast, reliable terminal experience.

# The Verdict

Neovim is a fantastic hobby if you want to build a personalized IDE from scratch. I don't have time for that.

But if you want a modern, terminal-based editor that provides a world-class development experience without the configuration sinkhole, Helix is the undeniable winner.

I said what I said.
