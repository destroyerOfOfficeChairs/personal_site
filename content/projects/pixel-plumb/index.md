+++
title = "Pixel Plumb"
weight = 1
[extra]
tagline = "A pixel-art image pipeline in Rust and WebAssembly."
url = "https://pixelplumb.wjcreations.com"
repo = "https://github.com/destroyerOfOfficeChairs/pixel-plumb"
before = "pp_source.png"
after = "pp_output.png"
featured = true
+++

Pixel Plumb turns photographs into pixel art. You upload an image, stack up few operations, and hit run. It works entirely in your browser — nothing is uploaded anywhere, because there is no server.

That part isn't unusual. There are a dozen web tools that will pixelate an image. What's unusual is that this one does the colour maths correctly.

## The problem with most pixel art tools

Two operations happen when you convert a photograph to pixel art: colours get matched to a limited palette, and the error from that matching gets spread across neighbouring pixels so the eye blends it back into something that looks like the original.

Almost every tool does both of these in sRGB, treating the numbers in the file as if they were quantities of light. They aren't. sRGB is gamma-encoded — the value 128 is not half as bright as 255, it's about 22% as bright. Averaging those numbers produces results that are measurably and visibly wrong.

{{ compare(before="gamma_wrong.png", after="gamma_right.png",
           before_label="Naive sRGB", after_label="Linear light",
           caption="The same image, dithered with the same palette. The naive version loses contrast in the midtones and shifts the sky green.") }}

The second problem is distance. To match a colour to a palette you need to ask which palette entry is *closest*, and in sRGB the answer is often wrong in a way that's obvious once you see it — two colours that are numerically near each other can look nothing alike, and two that look nearly identical can be far apart.

Pixel Plumb does palette matching in [OkLab](https://bottosson.github.io/posts/oklab/), a perceptual colour space where numerical distance actually corresponds to how different two colours look. Error diffusion happens in linear light, where adding and averaging mean what they're supposed to mean.

{% note(title="Why this matters more than it sounds") %}
Perceptual colour distance isn't an aesthetic preference — it's the difference between a palette match that preserves the structure of an image and one that flattens it. The effect is strongest in skin tones, skies, and anywhere the source has a smooth gradient.
{% end %}

## Operations

A pipeline is a list of operations applied in order. Each one is small and composable; the interesting results come from stacking them.

{{ compare(before="op_palette_before.png", after="op_palette_after.png",
           title="Adaptive palette",
           before_label="Full colour", after_label="16 colours",
           caption="Builds a palette from the image itself rather than snapping to a fixed one.") }}

{{ compare(before="op_dither_before.png", after="op_dither_after.png",
           title="Error diffusion",
           before_label="Flat quantisation", after_label="Atkinson dithering",
           caption="Atkinson diffuses only 6/8 of the error, which lightens the image. That's why Mac-era art looks the way it does.") }}

{{ compare(before="op_saturation_before.png", after="op_saturation_after.png",
           title="Saturation",
           before_label="Original", after_label="Saturation +40",
           caption="Applied in OkLab, so increasing saturation doesn't drag hues toward the primaries.") }}

{{ compare(before="op_contrast_before.png", after="op_contrast_after.png",
           title="Contrast",
           before_label="Original", after_label="Contrast +30",
           caption="Often worth applying before palette matching — a flat source gives the matcher less to work with.") }}

{% note(title="Dithering algorithms", collapsible=true, open=false) %}
Floyd–Steinberg, Atkinson, Sierra, and ordered Bayer are all implemented. Atkinson is the default, chosen empirically rather than on principle: it produces the cleanest results on photographic sources at small palette sizes, at the cost of lightening the image.

Bayer is the odd one out — it's ordered rather than error-diffusing, so it produces a regular crosshatch instead of organic noise. Better for anything that needs to tile.
{% end %}

## Using it

Drag an image in. Add operations from the sidebar. Reorder them by dragging. Hit run.

{{ pixel_art(src="ui_pipeline.png", alt="The pipeline editor with several operations stacked",
             caption="The pipeline is the interface. Everything else is detail.") }}

A few things worth knowing:

**Stage previews.** Every operation renders its own output, so you can see what each step did rather than guessing from the final result. Useful when a pipeline isn't doing what you expected — the culprit is usually two steps earlier than you think.

**Pipelines are data.** The current pipeline is shown as YAML with a copy-to-clipboard button. Paste it into a file and run it through the `plumb` CLI to batch-process a directory, or paste it back into the web UI later.

```yaml
- resize:
    width: 96
- contrast:
    amount: 30
- adaptive_palette:
    colors: 16
- dither:
    algorithm: atkinson
```

**Indexed PNG output.** A 96x64 image with a 16-colour palette should be about a kilobyte. Storing it as 32-bit RGBA makes it twenty times that for no benefit, so the encoder builds a real palette and writes an indexed PNG.

## How it's built

{% note(title="Implementation notes", collapsible=true, open=false) %}
The core is a plain Rust library with no WASM dependency. The web UI is [Leptos](https://leptos.dev/) compiled to WebAssembly, and there's a CLI that uses the same core. Nothing in the colour code knows or cares which frontend called it.

**Pipeline as data.** An operation is an enum variant with serde derives, not a trait object. That was a deliberate choice: trait objects would have been the obvious OO answer, but they can't be serialised, and being able to round-trip a pipeline through YAML turned out to be the feature that made the CLI possible at all.

**The value bag.** The UI needs a different shape than the core does. The core wants a strongly-typed `Operation`; the editor wants something it can render generic config cards from without knowing what operations exist. So the UI holds `OpInstance { tag, values: BTreeMap<String, ParamValue> }` and converts at the boundary. Schema-driven cards fall out of that for free — adding an operation means adding a schema entry, not writing a new component.

**One write path.** Every mutation goes through a single `edit_op` function. This sounds obvious and was not obvious at the time; the version where the drag handler, the config cards, and the delete button each mutated state directly was the source of most of the bugs in the first month.
{% end %}

## Status

Version 0.1.0. It works, it's fast, and I use it — every image on this site was made with it.

Known rough edges: the palette editor is functional but plain, there's no undo, and large images can take a few seconds since everything runs on one thread. Threading is possible in WASM but needs `SharedArrayBuffer`, which needs response headers GitHub Pages can't set — so that's a hosting decision as much as a code one.

[Try it](https://pixelplumb.wjcreations.com) ·
[Source](https://github.com/destroyerOfOfficeChairs/pixel-plumb)
