+++
title = "Typst Is Better Than LaTeX"
date = 2026-05-10
slug = "typst-vs-latex"
[taxonomies]
categories = ["computers"]
tags = ["typst", "rust", "typesetting", "writing"]
[extra]
hero = "/images/typst_logo_pixelplumb.png"
share = "/images/typst_share.png"
subtitle = "A eulogy nobody asked for, delivered at a funeral nobody scheduled."
+++

I can hear the contrarians now: "BuT LaTeX iS InDuStRy StAnDaRd!"

Cool. So was asbestos.

Let me show you what you've been defending.

# Exhibit A: Saying Hello

Here is a complete, valid LaTeX document that puts one word on one page.

```latex
\documentclass[11pt]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage[margin=1in]{geometry}

\begin{document}
Hello.
\end{document}
```

Nine lines. Five of them exist to inform a piece of software written in 1978 that it is no longer 1978. You are manually telling your typesetter that Unicode happened. You are *importing a package* to explain the concept of a margin.

Here is the same document in Typst.

```typst
Hello.
```

That's it. That's the file. The margins are already sane. The font already renders. It already knows what a letter is.

If your response to this is "but the boilerplate is in a template I copy around," congratulations, you've invented a workaround for a problem that shouldn't exist and you're bragging about it.

# Exhibit B: The Time You Wanted A Reusable Note Box

You want a little callout box. Bold label, indented, shaded background. A thing every word processor has had since Clippy was alive.

LaTeX:

```latex
\usepackage{xcolor}
\usepackage{mdframed}

\newmdenv[
  backgroundcolor=gray!15,
  linewidth=0pt,
  innerleftmargin=8pt,
  innerrightmargin=8pt,
  innertopmargin=8pt,
  innerbottommargin=8pt,
]{notebox}

\newcommand{\note}[1]{%
  \begin{notebox}%
  \textbf{Note:} #1%
  \end{notebox}%
}
```

Look at those percent signs. Do you know what those are for? They're there to eat the newline. Because if you don't manually suppress the whitespace, LaTeX inserts a space, and your box gets a mystery gap.

You either spend 40 minutes looking at decades-old forum posts, or you pray to the LLM gods, only to find out that the fix is an arbitrary punctuation mark at the end of a line.

You are hand-managing invisible whitespace. In a document. In this century.

Typst:

```typst
#let note(body) = block(
  fill: luma(240),
  inset: 8pt,
  radius: 4pt,
  width: 100%,
)[*Note:* #body]
```

It's a function. It takes an argument. The argument has a *name*, not a number. Nothing is invisible. Nothing needs to be suppressed. It works the first time.

# Exhibit C: Basic Arithmetic

Suppose you want to add two numbers together and print the result. I want you to really sit with how modest a request this is.

LaTeX:

```latex
\newcounter{total}
\setcounter{total}{40}
\addtocounter{total}{2}
The answer is \thetotal.
```

You have to allocate a counter. There is a finite number of them, by the way --- classic TeX gives you 256, and yes, people have run out. You then mutate it with a dedicated command, and read it back with a *different* command that is the word "the" glued onto the front of your variable name.

Typst:

```typst
#let total = 40 + 2
The answer is #total.
```

It's a variable. Mind-boggling, I know.

# Exhibit D: A Loop

```latex
\usepackage{pgffor}
\foreach \i in {1,...,3}{Item \i\ }
```

Note the `\i\ ` at the end. That trailing backslash-space is a literal escaped space, because otherwise LaTeX eats the whitespace after a control sequence. Forget it and your items fuse into `Item 1Item 2Item 3`.

LaTeX loop syntax is objectively terrible.

Meanwhile, here's how you loop with Typst:

```typst
#for i in range(1, 4) [Item #i ]
```

It reads a lot like Python, no? Fantastic.

# Exhibit E: The Error Messages

This is my favorite part. Here is LaTeX telling you something is wrong:

```
Underfull \hbox (badness 10000) in paragraph at lines 12--18
```

Badness. Ten thousand. That's the actual word. Not "your line spacing looks stretched." *Badness.* A number on a scale you were never told about, representing a quality you cannot see, in a box you didn't know existed.

Typst points at the line, tells you what it expected, and tells you what it got. In English. Like software that respects you.

# Your Objections Are Terrible

**"The ecosystem isn't as mature."** Correct. LaTeX has had 50 years to accumulate 6,000 packages, roughly nine of which are maintained, and the one you need conflicts with the one your university template requires.

A landfill can be mature too.

**"My journal requires LaTeX submission."** Then submit LaTeX. Nobody is asking you to fall on your sword for this.

**"You just don't understand TeX's box model."** I understand it fine. I also understand that I shouldn't have to. The entire pitch of a typesetting system is that it handles the typesetting. If mastering the internals is a prerequisite for producing a two-page PDF, the abstraction has failed and you have Stockholm syndrome about it.

**"I'm not learning a new typesetting engine!"** You learned LaTeX even though it hurt. You'll be up and running with Typst in a fraction of the time, and it won't fight you every step of the way.

# The Verdict

Knuth built TeX because typesetting in 1978 was genuinely terrible and he was genuinely a genius. That's not in dispute. He solved his problem so thoroughly that we've spent five decades refusing to notice it was *his* problem, in *his* decade, with *his* constraints.

You are allowed to stop. The 4GB distribution is not a personality. Download a single binary, open Helix, and write something.

The `\hbox` is empty. It was always empty. Let it go.
