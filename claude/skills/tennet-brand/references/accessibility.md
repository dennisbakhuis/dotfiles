# Accessibility

TenneT's visual material must be usable by people with varying visual, motor, and cognitive abilities. Accessibility is a brand standard, not a legal afterthought.

## Contrast

WCAG AA minimum, AAA preferred.

- **Normal text (under 18pt / 14pt bold):** 4.5:1 minimum, 7:1 for AAA
- **Large text (18pt+ or 14pt bold+):** 3:1 minimum, 4.5:1 for AAA
- **UI components and graphics:** 3:1 minimum against adjacent colors

### Common TenneT combinations

| Foreground | Background | Ratio | WCAG |
|---|---|---|---|
| Dark Blue `#003584` | White `#FFFFFF` | ~10.4:1 | AAA |
| White `#FFFFFF` | Dark Blue `#003584` | ~10.4:1 | AAA |
| Dark Text `#1A2B4A` | White `#FFFFFF` | ~14:1 | AAA |
| Dark Text `#1A2B4A` | Near White `#F5F7FA` | ~13:1 | AAA |
| Bright Blue `#3C8CFA` | White `#FFFFFF` | ~3.2:1 | AA large only |
| Orange `#FF6428` | White `#FFFFFF` | ~3.2:1 | AA large only |
| Green `#33A92F` | White `#FFFFFF` | ~3.5:1 | AA large only |
| White `#FFFFFF` | Orange `#FF6428` | ~3.2:1 | AA large only |
| White `#FFFFFF` | Green `#33A92F` | ~3.5:1 | AA large only |
| Muted Text `#3C465A` | White `#FFFFFF` | ~9.1:1 | AAA |

### Practical consequences

- **Don't** use Orange, Green, or Bright Blue for body text on white — they pass only at large sizes (18pt+). Use them for icons, headlines, accents, or with a darker background.
- **Don't** put Dark Blue body text on Dark Overlay or Dark Blue backgrounds — same color family, too close in luminosity.
- **Do** use Dark Text (`#1A2B4A`) for body copy on white — it clears AAA comfortably.
- **Do** use white on Dark Blue for any text size — both directions pass AAA.

## Color is not the only signal

Never convey information through color alone. Add a text label, icon, data label, or pattern fill.

Examples:
- A green "success" checkmark: include the word "Success" or a ✓ icon
- An orange warning bar: include "Warning" text or an ⚠ icon
- A red "error" border (we use Orange): include the error message text next to it
- Charts with series differentiated by color: also use line style (dashed, dotted) or markers (circle, square)

## Focus states

Keyboard users need to see where focus is. Every interactive element must have a visible focus indicator.

```css
*:focus-visible {
  outline: 2px solid var(--tennet-bright-blue);
  outline-offset: 2px;
}
```

Do not remove the outline without providing an alternative indicator of equal or greater visibility. `:focus { outline: none }` without replacement is an accessibility violation.

## Touch targets

Minimum hit area: 44×44 px. Applies to buttons, links, form controls, and any interactive element on touch devices.

## Alternative text

Every meaningful image needs alt text:

- **Photos** — describe the content ("Offshore converter platform under construction at IJmuiden Ver Alpha site")
- **Logos** — describe the brand and the variant ("TenneT logo, white variant")
- **Charts** — describe the key takeaway, not the shape ("Line chart showing grid reliability above 99.99% for 2020–2025")
- **Icons that convey meaning** — describe the meaning ("Sustainability indicator")
- **Decorative images** — `alt=""` so screen readers skip them

Alt text goes in image `alt` attributes in HTML, or the equivalent metadata field in PDFs, Word, and PowerPoint.

## Captions and transcripts

- Videos need captions (burned-in or separate caption track)
- Audio needs transcripts
- Live events: consider live captioning for significant audiences

## Text size and zoom

- Content must remain usable at 200% browser zoom
- Don't lock text sizes in CSS with absolute units; prefer `rem` over `px`, with `16px` as the base
- Don't disable pinch-to-zoom on mobile sites (`user-scalable=no` is forbidden)

## Reduced motion

Respect `prefers-reduced-motion`:

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

TenneT motion design is subtle by default, but even subtle parallax or transitions can trigger vestibular issues for some users.

## Language attributes

On web pages, set the `lang` attribute on `<html>` to the correct language:

```html
<html lang="nl">  <!-- Dutch -->
<html lang="de">  <!-- German -->
<html lang="en">  <!-- English -->
```

For mixed-language content (e.g., an English page quoting a Dutch station name), wrap the non-primary language section in an element with its own `lang` attribute so screen readers switch pronunciation.

## Checklist

Before shipping a web page or digital asset:

- [ ] Text contrast passes AA (AAA for anything critical)
- [ ] Every interactive element has a visible focus state
- [ ] Every meaningful image has alt text
- [ ] Information isn't conveyed by color alone
- [ ] Video has captions, audio has transcript
- [ ] Content works at 200% zoom
- [ ] `prefers-reduced-motion` respected
- [ ] Language attributes set
- [ ] Forms have labels, not just placeholder text
- [ ] Errors are announced and readable
