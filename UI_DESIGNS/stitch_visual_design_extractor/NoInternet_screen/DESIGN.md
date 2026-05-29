---
name: Vitality Dark
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c2c8c1'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8c928c'
  outline-variant: '#424843'
  surface-tint: '#abcfb6'
  primary: '#abcfb6'
  on-primary: '#163725'
  primary-container: '#002111'
  on-primary-container: '#698c75'
  inverse-primary: '#446651'
  secondary: '#f5fff2'
  on-secondary: '#003919'
  secondary-container: '#36ff8b'
  on-secondary-container: '#007238'
  tertiary: '#ffb4aa'
  on-tertiary: '#690003'
  tertiary-container: '#410001'
  on-tertiary-container: '#f9362c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c6ebd1'
  primary-fixed-dim: '#abcfb6'
  on-primary-fixed: '#002111'
  on-primary-fixed-variant: '#2d4d3a'
  secondary-fixed: '#61ff97'
  secondary-fixed-dim: '#00e476'
  on-secondary-fixed: '#00210c'
  on-secondary-fixed-variant: '#005227'
  tertiary-fixed: '#ffdad5'
  tertiary-fixed-dim: '#ffb4aa'
  on-tertiary-fixed: '#410001'
  on-tertiary-fixed-variant: '#930005'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Sora
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-md:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 24px
  gutter: 16px
  stack-sm: 12px
  stack-md: 24px
  stack-lg: 48px
---

## Brand & Style
The design system is a high-performance, medical-grade aesthetic tailored for health-tech and bio-hacking platforms. It evokes a sense of deep immersion and technical precision through a dark, atmospheric environment.

The style is defined by **High-Contrast Glassmorphism**. It utilizes deep emerald voids as the foundation, layered with translucent frosted surfaces that suggest biological depth. Neon accents function as "active signals," representing vitality and data flow. This system prioritizes a premium, nocturnal feel that reduces eye strain while highlighting critical health metrics and system statuses through luminous feedback.

## Colors
This design system utilizes a palette rooted in deep darkness to make interactive elements "pop" with bio-luminescent intensity.

- **Primary (Deep Emerald):** #002111. Used for the base background and core branding. It provides a rich, organic foundation.
- **Secondary (Neon Mint):** #00FF85. The primary action color. It represents "Active" states, health, and progression.
- **Tertiary (Neon Crimson):** #FF3B30. Reserved exclusively for error states, critical warnings, and destructive actions.
- **Surface (Glass):** Semi-transparent variants of the primary color with a 60% opacity and high-saturation blur.
- **Neutrals:** A range of ultra-dark grays to support hierarchy without breaking the immersion of the dark mode.

## Typography
The typography strategy balances technical efficiency with human readability.

**Sora** is used for headlines to provide a geometric, futuristic character. Its wide stance conveys stability and modernity.
**Manrope** is the workhorse for all body copy and interface elements, chosen for its refined, balanced legibility in low-light environments.
**JetBrains Mono** is introduced for labels and technical data points (like heart rate or timestamps), reinforcing the "data-driven" nature of the design system.

Large display type should utilize a slight negative letter-spacing to maintain a tight, editorial feel. Labels should be uppercase with increased tracking for maximum clarity at small sizes.

## Layout & Spacing
The design system employs a **Fluid Grid** model with a strict 8px rhythmic spacing system. 

- **Desktop:** 12-column grid with 24px gutters and variable side margins (minimum 80px).
- **Mobile:** 4-column grid with 16px gutters and 24px side margins.

Layouts for state screens (errors, empty states) must be vertically centered within the viewport. Spacing between illustrative elements and their supporting text should follow the `stack-lg` (48px) unit to ensure the feedback feels significant and un-cluttered. Components should use `stack-sm` for internal padding to maintain a compact, "instrument panel" feel.

## Elevation & Depth
Depth is created through light and transparency rather than traditional shadows.

1.  **Base Layer:** The solid #002111 background.
2.  **Glass Layer:** Surfaces use `backdrop-filter: blur(20px)` and a background color of `rgba(0, 33, 17, 0.7)`. 
3.  **Edge Definition:** Every glass container must have a 1px solid border. Use a top-down linear gradient border (White at 15% opacity to Transparent) to simulate a subtle light source hitting the top edge.
4.  **Neon Glow:** Interactive elements use an `outer-glow` (box-shadow) that matches their accent color but with a very high blur (20-40px) and low opacity (20%), creating a bio-luminescent effect that bleeds into the glass layers.

## Shapes
The shape language is "Squircle-inspired," utilizing a consistent **Rounded (0.5rem)** base for standard components. This softens the technical aesthetic, making the health-focused data feel more approachable.

- **Standard Components:** 8px (0.5rem) radius.
- **Large Cards & Glass Containers:** 16px (1rem) radius.
- **Retry/Action Buttons:** 100px (Pill-shaped) to maximize clickability and contrast against the rectangular grid.

## Components

### Illustrative Feedback
Error and empty states feature "Wireframe-Bio" illustrations. These are stroke-based icons using 1.5px lines in Neon Mint or Neon Crimson. They should appear partially "digitized" with 50% opacity segments to suggest a scanning or system-loading effect.

### Buttons (Retry & Primary)
The **Retry Button** is a high-visibility component designed to stand out in error states. It features a solid Neon Mint (#00FF85) background with black text. In a hovered state, it gains a matching green glow. Secondary buttons use the ghost style: a 1px Neon Mint border with no fill.

### Glass Cards
All content containers must be glassmorphic. They should never be fully opaque. Use them to group related health metrics or to house error messages.

### Input Fields
Inputs are dark-filled containers with a subtle bottom-border in Neon Mint. When in an error state, the bottom border and the helper text shift to Neon Crimson (#FF3B30).

### Chips & Tags
Small, pill-shaped indicators for status. Use a low-opacity fill of the status color (e.g., 10% Green) with a high-saturation text color to ensure readability against the dark background.