# Web and Digital

Web UI components, design tokens, and data visualization patterns.

## Design tokens

See `colors.md` for the full CSS-variables block. The minimum you need:

```css
:root {
  --tennet-dark-blue: #003584;
  --tennet-bright-blue: #3C8CFA;
  --tennet-orange: #FF6428;
  --tennet-green: #33A92F;
  --tennet-white: #FFFFFF;
  --tennet-near-white: #F5F7FA;
  --tennet-dark-text: #1A2B4A;
  --tennet-muted-text: #3C465A;
}
```

## Buttons

```css
.btn-primary {
  background: var(--tennet-dark-blue);
  color: white;
  border-radius: 4px;
  padding: 12px 24px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.02em;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  border: none;
  cursor: pointer;
  transition: background 0.15s ease;
}
.btn-primary:hover { background: var(--tennet-bright-blue); }
.btn-primary:focus-visible {
  outline: 2px solid var(--tennet-bright-blue);
  outline-offset: 2px;
}

.btn-accent {
  background: var(--tennet-orange);
  color: white;
  /* Reserve for high-emphasis CTAs only — one per view */
}

.btn-ghost {
  background: transparent;
  color: var(--tennet-dark-blue);
  border: 2px solid var(--tennet-dark-blue);
}
```

Use `btn-primary` as the default. `btn-accent` is the emphasized CTA — one per viewport, never stacked. `btn-ghost` for secondary actions next to a primary.

## Cards

```css
.card {
  background: white;
  border-left: 4px solid var(--tennet-dark-blue);
  box-shadow: 0 2px 8px rgba(0, 53, 132, 0.08);
  border-radius: 4px;
  padding: 20px 24px;
}
.card--highlight {
  border-left-color: var(--tennet-orange);
}
.card--sustainability {
  border-left-color: var(--tennet-green);
}
```

The left border is a recurring TenneT motif — it signals category without a full-color fill. Use modifier classes (`--highlight`, `--sustainability`) rather than overriding the base.

## Navigation

- Dark Blue header bar across the top
- White text and logo inside the bar
- Active item: white text with Orange underline (2–3px, 8–12px below the text)
- Hover: Bright Blue background on the item, or Bright Blue underline
- Dropdown menus: white background, dark blue hover state, 1–2px shadow

Left-side nav pattern:

- Near White background
- Dark Text for labels
- Dark Blue left border on active item (4px)
- Bright Blue for hover / keyboard focus

## Form inputs

```css
.input {
  border: 1.5px solid #D5DCE6;
  border-radius: 4px;
  padding: 10px 14px;
  font-family: inherit;
  color: var(--tennet-dark-text);
  background: white;
}
.input:focus {
  outline: none;
  border-color: var(--tennet-bright-blue);
  box-shadow: 0 0 0 3px rgba(60, 140, 250, 0.15);
}
.input--error {
  border-color: var(--tennet-orange);
}
```

Labels: Dark Text, medium weight, 14px, positioned above the input.

Error messages: Dark Text (not Orange — reserve Orange for the border / icon). Orange body text on white fails accessibility contrast.

## Data visualization

Primary palette for charts:

1. Dark Blue — primary series, most important data
2. Bright Blue — secondary series
3. Orange — accent / highlighted / critical series
4. Green — positive / growth / sustainability series
5. Light Blue — tertiary
6. Muted Text — neutral baseline or comparison

Rules:

- Grid lines: Light Blue at 20% opacity. Avoid solid grid lines.
- Axis labels: Muted Text, Regular, 12–14px
- Axis titles: Dark Text, Medium, 14–16px
- Legend: top or right of the chart, Dark Text, clear color chips
- Never convey information through color alone — always include a text label, data label, or pattern fill
- Charts that only have one series: default to Dark Blue
- Categorical palettes of more than 6 series: avoid. If you must, shift to a neutral palette (Muted Text, Light Blue shades) with Dark Blue / Orange reserved for emphasized categories.

```python
# Matplotlib example
import matplotlib.pyplot as plt

TENNET_PALETTE = ["#003584", "#3C8CFA", "#FF6428", "#33A92F", "#A0C4E8", "#3C465A"]
plt.rcParams["axes.prop_cycle"] = plt.cycler(color=TENNET_PALETTE)
plt.rcParams["font.family"] = ["Helvetica Neue", "Helvetica", "Arial", "sans-serif"]
plt.rcParams["axes.grid"] = True
plt.rcParams["grid.color"] = "#A0C4E8"
plt.rcParams["grid.alpha"] = 0.2
```

```javascript
// Chart.js / Plotly example
const TENNET_COLORS = ["#003584", "#3C8CFA", "#FF6428", "#33A92F", "#A0C4E8", "#3C465A"];
```

## Spacing

Use a 4px / 8px grid:

- 4, 8, 12, 16, 20, 24, 32, 40, 56, 64, 80px

Avoid arbitrary spacings (7px, 13px, 19px). The visual rhythm comes from consistent spacing.

## Responsive behavior

- Breakpoints: 480px (mobile), 768px (tablet), 1024px (desktop), 1440px (wide)
- Text scale down to ~87.5% at mobile for H1 and H2
- Touch targets: 44×44px minimum on mobile
- Padding increases at tablet+ (24–32px) vs mobile (16–20px)

## Component composition

- Don't mix competing signals in one component (don't give a primary button an orange border "for emphasis" — the solid dark blue already carries the emphasis)
- Don't stack accents (orange border + orange icon + orange text all together reads as noise)
- Keep one level of color emphasis per section of the page

## Background textures

- Default background: White
- Section breaks: Near White (#F5F7FA)
- Hero sections: Dark Blue with optional Pulse/Burst overlay (see `pulse-burst.md`)
- Full Dark Blue backgrounds: use sparingly — typically the hero, the footer, or a single emphasized section
