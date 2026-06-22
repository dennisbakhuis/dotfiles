# Typography

## Font stack

In priority order:

1. **Helvetica Neue** — preferred for all TenneT materials
2. **Helvetica** — fallback
3. **Arial** — system fallback
4. **sans-serif** — generic fallback

For CSS:

```css
body, h1, h2, h3, h4, h5, h6 {
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
}
```

## Weights in use

| Weight | Style Name | Use |
|---|---|---|
| Bold (700) | Helvetica Neue Bold | Headlines, titles, strong emphasis |
| Medium (500) | Helvetica Neue Medium | Subheadings, labels |
| Regular (400) | Helvetica Neue Regular | Body text, descriptions |
| Light (300) | Helvetica Neue Light | Large display text, subtitles, elegant callouts |
| Condensed Bold | Helvetica Neue Condensed Bold | Tight spaces, badges, tags |

Do not use italic or extra-heavy weights.

## Print type scale (A2 poster at 300dpi)

Sizes are percent of canvas width; multiply by width-in-pixels to get px size.

| Element | Size (% of width) | Weight | Color |
|---|---|---|---|
| Main Title | 4–5% | Bold | White or Dark Blue |
| Subtitle | 2–2.5% | Light / Regular | White, Light Blue, or Muted |
| Body / Function | 1.7–1.9% | Regular | White or Dark Text |
| Key Points | 1.5–1.7% | Regular | White or Muted |
| Labels | 1.7–1.9% | Bold | Orange or Bright Blue |
| Caption | 1.2–1.4% | Light | Muted Text |

For A1, A3, and other sizes: scale linearly from the A2 percentages. A 4961px-wide A2 poster has a 4% title at ~200px; a 9933px-wide A1 should use the same 4% → ~397px.

## Digital type scale

| Element | Size | Weight |
|---|---|---|
| H1 | 36–48px | Bold |
| H2 | 28–32px | Bold |
| H3 | 22–26px | Medium |
| Body | 16–18px | Regular |
| Small / Caption | 13–14px | Regular / Light |

Use `rem` over `px` when possible, with `16px` as the `rem` base.

## Rules

### Case and alignment

- Titles: **UPPERCASE** for impact, **Title Case** for approachability. Both are acceptable — UPPERCASE for posters and strong calls-to-attention, Title Case for warmer editorial content.
- All body text: **left-aligned**, never centered. Centered titles are OK for posters and hero sections.

### Line height

- Body: 1.4–1.6
- Headlines: 1.1–1.2
- Captions and small text: 1.3–1.5

### Line length

- Body text: 65–75 characters maximum per line. Break into columns or reduce width when lines get longer.

### Tracking

- UPPERCASE titles: slight positive tracking (`letter-spacing: 0.02em` or `+20` in design tools)
- Regular text: default tracking (no override)
- Small caps or badges: moderate positive tracking (`letter-spacing: 0.04em`)

## Examples

### Good

- An A2 event poster: 4.5% main title in UPPERCASE bold on dark blue, 2% subtitle in light, body text left-aligned at 1.8%.
- A web hero: H1 at 44px bold dark-blue, H2 at 28px medium, body at 16px regular dark-text, links in bright blue.

### Bad

- Dark Blue body text on Orange background (low contrast, colored-on-colored)
- Centered paragraph body text ("for visual balance")
- Italic Helvetica Neue in headlines (out of brand)
- A mix of three font families ("to add variety")
