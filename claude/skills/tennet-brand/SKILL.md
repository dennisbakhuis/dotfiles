---
name: tennet-brand
description: TenneT brand guidelines for colors, typography, logo, Pulse/Burst patterns, layout, posters, presentations, web UI, email, social, and writing tone. Ships the official logo files and a full set of Pulse/Burst PNGs in every brand color. Use this skill whenever you are designing, generating, or reviewing any TenneT-branded output — posters, slides, web apps, dashboards, email templates, social posts, CSS/design tokens, UI components, report headers, or any visual content that should feel like it came from TenneT. Apply it even when the user does not explicitly mention branding but the audience or context is TenneT. Pairs with tennet-ai-coding when building branded applications.
---

# TenneT Brand

You are a TenneT brand expert. Apply these guidelines whenever you are creating, reviewing, or advising on visual output for TenneT — in any medium.

TenneT is one of Europe's leading electricity transmission system operators. The brand communicates reliability, innovation, sustainability, and energy-transition leadership. Everything you produce should feel professional, trustworthy, forward-looking, and technically excellent — approachable but authoritative.

## Bundled assets

Assets ship inside this skill. Resolve paths relative to this `SKILL.md`:

- `assets/logos/tennet-logo-color.png` — full-color logo, for white or light backgrounds
- `assets/logos/tennet-logo-white.png` — white logo, for dark blue backgrounds or photo overlays
- `assets/pulse-burst/Burst {1..7}/` — seven Burst patterns, each in Bright blue, Dark blue, Green, Orange, and White
- `assets/pulse-burst/Pulse {1..3}/` — three Pulse patterns, same color set

When generating code that loads these, resolve from the skill directory (`Path(__file__).parent / "assets" / ...`) or pass the absolute path explicitly. Filenames sometimes use "Wit" for white and include minor spacing variations — glob-match on the color keyword rather than hardcoding filenames.

## Core principles

Seven rules that most of this skill reduces to. When an edge case isn't covered elsewhere, return to these.

1. **Dark Blue is dominant.** `#003584`. Use it for at least 60% of branded surface area. If a composition doesn't have dark blue in it, it probably doesn't read as TenneT.

2. **Orange is an accent, never a fill.** `#FF6428`. CTAs, accent lines, warnings, small emphasis. A large orange panel or background is off-brand.

3. **Green means sustainability.** `#33A92F`. Reserve it for sustainability messaging, growth indicators, success states. Using green for unrelated decoration weakens its signal.

4. **Bright Blue is for interaction.** `#3C8CFA`. Links, hovers, active states, highlights in digital interfaces.

5. **Write the name correctly.** `TenneT`. Capital T, lowercase `ennе`, capital T. Never `Tennet`, `TENNET`, or `Ten Net`.

6. **One Pulse or Burst per composition.** Never both. Always as a semi-transparent overlay (15–40% opacity), never centered over important content.

7. **Photography is authentic, not staged.** Real infrastructure, real people, real situations. No generic stock.

## Quick reference

### Color palette (the bare minimum)

| Name | Hex | RGB | Use |
|---|---|---|---|
| Dark Blue | `#003584` | `(0, 53, 132)` | Primary. Headers, backgrounds, text on light |
| Bright Blue | `#3C8CFA` | `(60, 140, 250)` | Accents, links, interactive |
| Orange | `#FF6428` | `(255, 100, 40)` | CTA, emphasis, warnings |
| Green | `#33A92F` | `(51, 169, 47)` | Sustainability, success |
| White | `#FFFFFF` | `(255, 255, 255)` | Backgrounds, text on dark |

Full palette (functional colors, CSS tokens, Python constants) is in `references/colors.md`.

### Typography (the bare minimum)

- Font stack: **Helvetica Neue → Helvetica → Arial → sans-serif**
- Weights in use: Bold (700), Medium (500), Regular (400), Light (300)
- Headlines bold. Body regular. No centered body text.

Full type scales for print and digital, rules for uppercase treatment, line-height, tracking are in `references/typography.md`.

### Logo (the bare minimum)

- **Color logo** on white/light backgrounds. **White logo** on dark blue or photo overlays.
- Clear space around the logo: height of the "T" character.
- Minimum size: 25mm print, 120px screen.
- Never rotate, stretch, recolor, or add effects.

Full logo-on-photo backing patterns, positioning rules, and code snippets are in `references/logo.md`.

### Pulse and Burst (the bare minimum)

- Pulse = radiating dot pattern from a corner (steady flow). Burst = concentrated dot pattern (dynamic energy).
- Always semi-transparent overlay (15–40% opacity).
- Place in corners or edges, never centered over important content.
- One Pulse **or** one Burst per composition — never both.

Full list of 10 variants, visual descriptions, color combinations, and a Python helper are in `references/pulse-burst.md`.

## When to apply this skill

Apply whenever you are producing output for a TenneT audience — even when the user doesn't say "brand" explicitly. Concrete triggers:

- Creating any visual design, poster, banner, or graphic
- Building a website, app, or dashboard that TenneT users will see
- Generating a presentation, document, or report cover
- Designing an email template, signature, or marketing mailer
- Writing or reviewing branded content and communications
- Setting up CSS, design tokens, theme variables, or a component library
- Preparing social media assets
- Reviewing existing material for brand compliance

When generating code, use exact hex values and RGB tuples from the quick reference (or the detailed palette in `references/colors.md`). When in doubt about composition, default to Dark Blue + White + one accent color.

## Do's and don'ts (the short list)

**Do**
- Use Dark Blue as the dominant color
- Maintain generous whitespace
- Use authentic TenneT photography
- Keep the logo clearly visible and properly spaced
- Use Orange sparingly, for impact
- Apply Pulse/Burst at low opacity as texture
- Write clear, confident, forward-looking copy
- Check accessibility contrast

**Don't**
- Fill large areas with Orange
- Stretch, rotate, recolor, or decorate the logo
- Use more than 2 brand colors in one composition (+ white)
- Place colored text on colored backgrounds (except white on Dark Blue)
- Use stock photography
- Center-align body text
- Use more than one Pulse/Burst per composition
- Add drop shadows, bevels, gradients between brand colors, or other dated effects
- Use the full-color logo on dark backgrounds — switch to the white version
- Write "Tennet", "TENNET", or "Ten Net"

## Reference files

Go deeper when the question calls for it:

- `references/colors.md` — Full palette including functional colors, color rules, CSS variables, Python constants, gradient policy
- `references/typography.md` — Font stack, weight mapping, print and digital type scales, uppercase / line-height / tracking rules
- `references/logo.md` — Clear space, minimum sizes, placement, photo-backing patterns, forbidden modifications
- `references/pulse-burst.md` — All 10 variants with visual descriptions, color/background combinations, Python overlay helper
- `references/posters.md` — Five poster patterns (A–E), print sizes, photo treatment for posters
- `references/web-digital.md` — Buttons, cards, navigation, data visualization, design tokens
- `references/presentations-email-social.md` — PowerPoint theme colors, slide types, email templates, social media sizes
- `references/writing-tone.md` — Tone of voice, naming conventions, content structure patterns
- `references/accessibility.md` — Contrast ratios, focus states, alt text, information-through-color caveats

## Related

- `skills/tennet-ai-coding` — TenneT AI-assisted coding standards. When building a branded TenneT application, apply both: `tennet-brand` shapes the visual output, `tennet-ai-coding` shapes the code and infrastructure underneath.
