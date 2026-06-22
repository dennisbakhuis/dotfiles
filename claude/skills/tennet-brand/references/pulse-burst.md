# Pulse and Burst

The Pulse and Burst are TenneT's signature graphic elements — dot-grid patterns that represent energy flow, connectivity, and the pulse of the electrical grid.

## Types

- **Pulse:** Radiating dot pattern from a corner/edge. Dots grow larger toward the source. Represents steady, reliable energy flow.
- **Burst:** More concentrated, explosive dot pattern. Represents energy, impact, and dynamic power.

## Available variants

- **Pulse:** Pulse 1, Pulse 2, Pulse 3 — three different densities / layouts
- **Burst:** Burst 1 through Burst 7 — seven shapes and concentrations

Each available in five colors: **Dark Blue**, **Bright Blue**, **Orange**, **Green**, **White** (some files say "Wit" for white, some say "White" — scripts should match on the color keyword, not the exact filename).

## Asset location

Bundled with this skill at `assets/pulse-burst/`. Subfolders: `Burst 1/` through `Burst 7/`, `Pulse 1/` through `Pulse 3/`. Filenames follow `<Pattern> - <Color>.png`.

All assets are PNGs with transparent backgrounds, intended for direct overlay use.

## Visual descriptions

Summaries of each pattern so you can pick the right one for a layout without loading it first.

- **Burst 1:** Dot grid growing from top-left toward bottom-left. Largest dots at bottom-left corner, fading to tiny dots at top-right. ~12 rows × ~9 cols. Dramatic corner-anchored piece.
- **Burst 2:** Concentrated burst pattern, medium density. Good for mid-edge overlays.
- **Burst 3:** Dot grid concentrated in upper-center area. Largest dots in center of cluster, fading outward. Good for top-center placement.
- **Burst 4:** Wide burst spread, medium density. Two "Dark blue" variants ship — one with `_1` suffix — pick either; they're visually near-identical.
- **Burst 5:** Dot grid in top-right area. Dots grow larger toward right edge. ~5 rows, ideal for top-right corner overlays on dark backgrounds.
- **Burst 6:** Balanced burst, less directional. Good for centered or near-center accents.
- **Burst 7:** Compact dot grid in top-right corner. ~4 rows, most concentrated variant. Best for tight corner accents.
- **Pulse 1:** Dot grid growing from bottom-left corner outward. Largest dots at bottom-left, fading to tiny dots at top-right. ~7 rows. Corner-anchored energy flow.
- **Pulse 2:** Broader pulse, similar direction to Pulse 1 but less dense.
- **Pulse 3:** Radiating pulse from a central edge. Less corner-anchored than 1 and 2.

## Usage rules

- Always use as **semi-transparent overlays** (15–40% opacity)
- Place in corners or edges — **never centered** over important content
- Use as decorative accents, not as primary design elements
- Maximum **one Pulse OR one Burst** per composition — never both
- Choose a color that **complements** the background
- Ensure the pattern does not obscure text, logos, or key imagery

## Recommended combinations

| Background | Pattern Color | Opacity |
|---|---|---|
| Dark Blue panel | Bright Blue | 15–20% |
| Photo with dark gradient | Dark Blue or Bright Blue | 25–30% |
| White / light background | Orange or Green | 30–40% |
| Header band (Dark Blue) | Bright Blue | 15–20% |
| Green sustainability card | Dark Blue | 20–25% |

## Code helpers

Python helper to load and overlay patterns:

```python
from pathlib import Path
from PIL import Image

SKILL_DIR = Path(__file__).parent  # or resolve relative to the skill directory
ASSETS = SKILL_DIR / "assets"

def load_pattern(pattern: str, color: str) -> Image.Image:
    """
    pattern: e.g. 'Burst 1', 'Pulse 2'
    color: e.g. 'Bright blue', 'Dark blue', 'Orange', 'Green', 'Wit', 'White'
    """
    folder = ASSETS / "pulse-burst" / pattern
    matches = list(folder.glob(f"*{color}*.png"))
    if not matches:
        raise FileNotFoundError(f"No {color} variant in {folder}")
    return Image.open(matches[0]).convert("RGBA")

def overlay_pattern(canvas, pattern_img, x, y, target_w, opacity=0.3):
    """Overlay a Pulse/Burst pattern onto a canvas at semi-transparent opacity."""
    ratio = target_w / pattern_img.width
    target_h = int(pattern_img.height * ratio)
    resized = pattern_img.resize((target_w, target_h), Image.LANCZOS)
    r, g, b, a = resized.split()
    alpha = a.point(lambda p: int(p * opacity))
    resized.putalpha(alpha)
    canvas.paste(resized, (x, y), resized)
    return canvas
```

Typical usage:

```python
bg = Image.new("RGB", (4961, 7016), DARK_BLUE)  # A2 portrait at 300dpi
pulse = load_pattern("Pulse 1", "Bright blue")
# Place pulse in bottom-left, 60% of width, 18% opacity
overlay_pattern(bg, pulse, x=0, y=int(bg.height * 0.55), target_w=int(bg.width * 0.6), opacity=0.18)
```

## Choosing a pattern

Quick guidance when asked to use a Pulse or Burst without more specifics:

- **Need dynamic, energetic feel:** Burst (3, 5, or 7)
- **Need steady, reliable, flow feel:** Pulse (1 preferred)
- **Corner accent on a dark panel:** Burst 5 or Burst 7, Bright Blue, 15–20%
- **Hero image overlay:** Pulse 1 or Pulse 2, Dark Blue, 25–30%
- **Light background with accent:** Burst 1 or Burst 3, Orange or Green, 30–40%

## What not to do

- Never use both a Pulse and a Burst in the same composition
- Never place them centered over body copy or faces in photography
- Never use at 100% opacity
- Never recolor outside the five provided color variants (do not invert white to create a black version, do not apply tint filters)
- Never scale so large that the pattern becomes the dominant visual element
- Never place against a busy photo without a gradient backing — the pattern will muddy the image
