# Colors

Full color palette, rules, and machine-readable tokens.

## Primary colors

| Name | Hex | RGB | Use |
|---|---|---|---|
| **TenneT Dark Blue** | `#003584` | `(0, 53, 132)` | Primary brand color. Headers, backgrounds, text on light bg |
| **TenneT Bright Blue** | `#3C8CFA` | `(60, 140, 250)` | Accents, highlights, interactive elements, links |
| **White** | `#FFFFFF` | `(255, 255, 255)` | Backgrounds, text on dark bg |

## Secondary colors

| Name | Hex | RGB | Use |
|---|---|---|---|
| **TenneT Orange** | `#FF6428` | `(255, 100, 40)` | Accent lines, CTAs, warnings, emphasis |
| **TenneT Green** | `#33A92F` | `(51, 169, 47)` | Sustainability, success states, bullet accents |
| **TenneT Light Blue** | `#A0C4E8` | `(160, 196, 232)` | Subtle backgrounds, secondary text on dark |

## Functional colors

| Name | Hex | RGB | Use |
|---|---|---|---|
| **Near White** | `#F5F7FA` | `(245, 247, 250)` | Light backgrounds, cards, footer areas |
| **Dark Overlay** | `#001E50` | `(0, 30, 80)` | Photo overlays, gradients |
| **Dark Text** | `#1A2B4A` | `(26, 43, 74)` | Body text on light backgrounds |
| **Muted Text** | `#3C465A` | `(60, 70, 90)` | Secondary text, captions |

## Rules

- Dark Blue is the **dominant** brand color — use it for at least 60% of branded surface area. If a composition doesn't look mostly dark blue, it doesn't read as TenneT.
- Orange is an **accent only** — never as a large background fill. Accent lines, CTAs, small emphasis.
- Green is reserved for **sustainability messaging** and small accents. Using it elsewhere weakens its signal.
- Bright Blue for **digital interactions** (links, hover states, highlights). Not for static print emphasis — use Orange there.
- Always maintain **sufficient contrast** (WCAG AA minimum, AAA preferred). See `accessibility.md`.
- Never use gradients between brand colors. The only acceptable gradient is **Dark Blue to transparent** for photo overlays.

## CSS variables

```css
:root {
  --tennet-dark-blue: #003584;
  --tennet-bright-blue: #3C8CFA;
  --tennet-orange: #FF6428;
  --tennet-green: #33A92F;
  --tennet-light-blue: #A0C4E8;
  --tennet-white: #FFFFFF;
  --tennet-near-white: #F5F7FA;
  --tennet-dark-overlay: #001E50;
  --tennet-dark-text: #1A2B4A;
  --tennet-muted-text: #3C465A;
}
```

## Python constants

```python
DARK_BLUE = (0, 53, 132)
BRIGHT_BLUE = (60, 140, 250)
ORANGE = (255, 100, 40)
GREEN = (51, 169, 47)
WHITE = (255, 255, 255)
LIGHT_BLUE = (160, 196, 232)
NEAR_WHITE = (245, 247, 250)
DARK_OVERLAY = (0, 30, 80)
DARK_TEXT = (26, 43, 74)
MUTED_TEXT = (60, 70, 90)
```

## Hex / RGB / HSL reference

If a tool expects a specific format:

| Color | Hex | RGB | HSL |
|---|---|---|---|
| Dark Blue | `#003584` | `rgb(0, 53, 132)` | `hsl(216, 100%, 26%)` |
| Bright Blue | `#3C8CFA` | `rgb(60, 140, 250)` | `hsl(215, 95%, 61%)` |
| Orange | `#FF6428` | `rgb(255, 100, 40)` | `hsl(17, 100%, 58%)` |
| Green | `#33A92F` | `rgb(51, 169, 47)` | `hsl(118, 57%, 42%)` |
| Light Blue | `#A0C4E8` | `rgb(160, 196, 232)` | `hsl(210, 61%, 77%)` |

## Color pairing for data visualization

Default series order when plotting multiple data series:

1. Dark Blue (primary / most important)
2. Bright Blue (secondary)
3. Orange (highlighted or critical series)
4. Green (positive / growth / sustainability series)
5. Light Blue (tertiary, background)
6. Muted Text (neutral / comparison baseline)

See `web-digital.md` for the full data-viz guidance.
