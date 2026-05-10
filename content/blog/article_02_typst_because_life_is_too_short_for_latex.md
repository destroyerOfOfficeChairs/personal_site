+++
title = "Typst: Because Life Is Too Short For LaTeX"
date = 2026-05-10
[taxonomies]
categories = ["computers"]
tags = ["typst", "rust", "typesetting", "writing"]
[extra]
hero = "/images/typst_pixelart_upscaled.png"
subtitle = "Leave the 1980s behind."
+++

"I love downloading a 4GB TeX Live distribution just to write a two-page PDF." 

Said no one, ever.

For decades, if you wanted to write anything that looked remotely professional --- academic papers, technical documentation, or even a nicely formatted resume --- you were told to use LaTeX. We all accepted this. We accepted that typesetting required learning a Turing-complete macro language designed in 1978. We accepted that finding a missing bracket meant deciphering ancient runes.

We suffered from Stockholm Syndrome. It is time to wake up.

Enter [Typst](https://typst.app/). 

# The LaTeX Problem

Let’s be honest about what using LaTeX actually feels like in the modern era. 

First, you install it. You go make coffee while gigabytes of packages you will never use are written to your drive. Then, you start writing. You want to change the margin? Better hit StackOverflow and paste in five lines of cryptic `\usepackage` boilerplate from a forum post written in 2009. 

And the errors. Oh, the errors. 
`Underfull \hbox (badness 10000)`
`! Missing $ inserted.`

LaTeX doesn't want to help you fix your document; it wants to punish you for not understanding the inner workings of its typesetting engine. It is a system maintained by sheer institutional inertia.

# The Typst Solution

Typst is a modern markup-based typesetting system. It is designed to be as powerful as LaTeX, but with the syntax of a modern programming language and the speed of a native application. 

Unsurprisingly, it is written in Rust. 

## Native Speed

Typst compiles instantly. It uses incremental compilation, meaning the moment you save your file, the PDF updates. There is no waiting for a multi-pass build system to figure out where your references are. It is the exact kind of high-performance, single-binary tooling that makes modern Linux environments actually enjoyable to use.

## A Sane Scripting Language

In LaTeX, everything is a macro. In Typst, you have actual functions, variables, and scoped logic. If you want to create a custom block for your technical documentation, you write a simple function. It feels like writing modern code, not like trying to trick a 40-year-old engine into doing your bidding.

## Errors That Actually Help

When you make a mistake in Typst, it points directly to the line and tells you exactly what went wrong in plain English. It respects your time and your mental energy.

# What I Use It For

I use Typst for almost all of my serious writing now. 

Whether I'm drafting highly structured technical documentation or creating templates for speculative fiction worldbuilding, Typst gets out of the way. I can define my styles once in a `.typ` file, keep my environment stripped down and terminal-centric, and let the compiler do the heavy lifting instantly. 

# My Templates

You can find my own templates here:

[My templates](https://github.com/destroyerOfOfficeChairs/typst-templates)

I have a template for writing technical documentation, and one for narrative content. Maybe I'll add my resume template here too but, for now, its in a private repo.

# The Verdict

LaTeX changed the world of typesetting. We should respect its legacy. But we don't have to use it anymore.

If you are tired of fighting your tools just to put words on a page, drop the gigabytes of LaTeX baggage. Install the Typst binary, open up Helix, and experience what writing in the 21st century is actually supposed to feel like.
