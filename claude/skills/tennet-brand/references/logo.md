# Logo

## Files

Bundled with this skill under `assets/logos/`:

- `tennet-logo-color.png` — full-color, for white and light backgrounds
- `tennet-logo-white.png` — white, for dark blue backgrounds or photo overlays

When loading in code:

```python
from pathlib import Path
SKILL_DIR = Path(__file__).parent  # skill root
LOGO_COLOR = SKILL_DIR / "assets" / "logos" / "tennet-logo-color.png"
LOGO_WHITE = SKILL_DIR / "assets" / "logos" / "tennet-logo-white.png"
```

## Which logo to use

- **Color logo** on white, near-white (#F5F7FA), and light photos
- **White logo** on dark blue (#003584), dark overlays, and dark photo gradients
- Never the color logo on a dark background — switch to white

## Clear space

- Maintain clear space around all four sides equal to **the height of the "T" character** in the logo
- Nothing inside that clear space — no text, no graphics, no photo detail
- When backed by a rectangle on busy photography, the backing should respect the clear space

## Minimum sizes

- Print: **25mm** wide minimum
- Screen: **120px** wide minimum

Below these, the wordmark loses definition. For favicons and social avatars, use only the stylized "T" if available, not the scaled-down wordmark.

## Placement

Preferred positions, in order:

1. Top-right
2. Bottom-right
3. Within a dedicated header band (usually dark blue)

Top-left and bottom-left are acceptable for specific layouts (e.g., when the logo anchors a left-side text panel), but check the overall composition balances.

## Logo on photography

Never place the color logo directly on busy photography without a backing. On dark photo gradients, the white logo can sit directly — but verify legibility.

Semi-transparent white backing pattern:

```python
from PIL import Image

def logo_with_backing(logo_path, padding=30, bg_alpha=200):
    logo = Image.open(logo_path).convert("RGBA")
    backing = Image.new(
        "RGBA",
        (logo.width + padding * 2, logo.height + padding * 2),
        (255, 255, 255, bg_alpha),
    )
    backing.paste(logo, (padding, padding), logo)
    return backing
```

Tune `bg_alpha`:
- 200 (78%) — default, unobtrusive
- 230 (90%) — busy photo, need stronger legibility
- 255 (100%) — solid backing; use when the photo is very busy or text-heavy

## What not to do

- Never rotate the logo
- Never stretch non-uniformly (don't change the aspect ratio)
- Never recolor (no blue-tinted "brand-match" logos, no gradient fills)
- Never apply drop shadows, outer glows, bevels, or other effects
- Never place the logo inside a shape that alters its outline (circle crops, wave shapes)
- Never resize below the minimum size
- Never use in-sentence as a wordmark substitute — always write "TenneT" in the surrounding copy

## Backing when in header band

When the logo sits inside a Dark Blue header band or panel, no backing needed — use the white logo directly. Leave clear space equal to the "T" character height between the logo and any other band content (title text, navigation).

## Logo with accent line

A common TenneT layout motif: Orange or Green accent line directly below or beside the logo, 2–4px thick, 8–15% of container width.

- Place the accent line after maintaining logo clear space
- Never cross the logo's clear space with the accent line
- Use the accent line sparingly — not on every logo occurrence, typically only in the primary header
