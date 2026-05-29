---
name: Vitality Dark
colors:
  surface: '#00180b'
  surface-dim: '#00180b'
  surface-bright: '#1f402d'
  surface-container-lowest: '#001207'
  surface-container-low: '#002111'
  surface-container: '#032515'
  surface-container-high: '#0f301f'
  surface-container-highest: '#1b3b29'
  on-surface: '#c6ebd1'
  on-surface-variant: '#bbcabf'
  inverse-surface: '#c6ebd1'
  inverse-on-surface: '#163725'
  outline: '#86948a'
  outline-variant: '#3c4a42'
  surface-tint: '#4edea3'
  primary: '#4edea3'
  on-primary: '#003824'
  primary-container: '#10b981'
  on-primary-container: '#00422b'
  inverse-primary: '#006c49'
  secondary: '#95d3ba'
  on-secondary: '#003829'
  secondary-container: '#0b513d'
  on-secondary-container: '#83c2a9'
  tertiary: '#45dfa4'
  on-tertiary: '#003825'
  tertiary-container: '#00b982'
  on-tertiary-container: '#00422c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#6ffbbe'
  primary-fixed-dim: '#4edea3'
  on-primary-fixed: '#002113'
  on-primary-fixed-variant: '#005236'
  secondary-fixed: '#b0f0d6'
  secondary-fixed-dim: '#95d3ba'
  on-secondary-fixed: '#002117'
  on-secondary-fixed-variant: '#0b513d'
  tertiary-fixed: '#68fcbf'
  tertiary-fixed-dim: '#45dfa4'
  on-tertiary-fixed: '#002114'
  on-tertiary-fixed-variant: '#005137'
  background: '#00180b'
  on-background: '#c6ebd1'
  surface-variant: '#1b3b29'
typography:
  headline-xl:
    fontFamily: Sora
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Sora
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Sora
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
  headline-md:
    fontFamily: Sora
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: Sora
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Sora
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: Sora
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: Sora
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 40px
  xl: 64px
  gutter: 16px
  margin-mobile: 20px
  margin-desktop: 48px
---

## Brand & Style

This design system is engineered for high-performance healthcare environments, prioritizing clarity, precision, and trust. The aesthetic leans into a **Corporate / Modern** style with subtle **Glassmorphism** influences to denote depth in complex medical data. 

The target audience includes both medical professionals requiring rapid data synthesis and patients seeking a secure, premium wellness experience. The UI evokes a sense of "technological calm"—using a deep, monochromatic base to reduce eye strain in clinical settings, punctuated by vibrant emerald accents that draw attention to critical health metrics and primary actions.

## Colors

The palette is anchored by a deep, "obsidian-emerald" neutral (#002111), which serves as the primary canvas. This creates a high-end, tech-oriented medical environment. 

- **Primary Emerald:** Used for critical touchpoints, active states, and successful health indicators.
- **Secondary Forest:** Utilized for structural elements, inactive progress bars, and subtle surface layering.
- **Tertiary Mint:** Reserved for hover states and secondary data visualizations to ensure legibility against the dark background.
- **Surface Strategy:** Backgrounds utilize the neutral base, while containers use slightly lighter increments of the secondary green to establish hierarchy without relying on heavy shadows.

## Typography

The design system utilizes **Sora** exclusively to maintain a clean, geometric, and technical appearance. Its high x-height and distinctive apertures ensure maximum legibility for numerical data, such as heart rates and laboratory results.

Headlines use tighter letter-spacing and heavier weights to command authority. Body text is kept airy with a generous line height (1.5x) to ensure long medical reports remain readable. Small labels and "Overlines" utilize uppercase styling and increased tracking to differentiate metadata from actionable content.

## Layout & Spacing

The spacing philosophy follows a strict **8px base grid**, ensuring mathematical harmony across all components. 

- **Fluid Grid:** For mobile devices, the design system employs a 4-column fluid grid with 20px side margins.
- **Fixed Grid:** On desktop, a 12-column grid is used with a maximum content width of 1440px. 
- **Rhythm:** Information-dense areas (like patient charts) utilize `xs` and `sm` spacing to keep data connected, while high-level dashboard views utilize `lg` and `xl` spacing to create a sense of premium "breathing room."

## Elevation & Depth

In this dark-themed system, depth is communicated through **Tonal Layers** and **Subtle Glows** rather than traditional black shadows. 

1.  **Level 0 (Base):** The #002111 background.
2.  **Level 1 (Cards/Panels):** A slightly lighter green-tinted surface with a 1px border (#ffffff08) to define edges.
3.  **Level 2 (Modals/Popovers):** These use a backdrop blur (12px) and a subtle emerald-tinted outer glow (primary color at 10% opacity) to suggest they are floating closer to the user.
4.  **Interactions:** Hover states on interactive cards should slightly increase the brightness of the surface color rather than moving the element physically.

## Shapes

The design system uses a **Soft (Level 1)** shape language. A base radius of 8px (0.5rem) is applied to standard components like input fields, buttons, and small cards. 

- **Large Containers:** Use 12px (`rounded-lg`) for main dashboard widgets.
- **Section Wrappers:** Use 16px (`rounded-xl`) for full-page takeovers or modal overlays.
- **Selection Indicators:** Small radio buttons and checkboxes retain the 4px radius to feel precise and medical, avoiding the "bubbly" appearance of full circles.

## Components

- **Buttons:** Primary buttons are solid Emerald (#10B981) with black text for maximum contrast. Secondary buttons use a ghost style with a 1px emerald border.
- **Cards:** Defined by a 1px border in a semi-transparent white (#ffffff10). Backgrounds are slightly lighter than the app base.
- **Input Fields:** Darker than the card background to create an "inset" feel. Focus states utilize a 2px Emerald border and a subtle outer glow.
- **Chips/Status Tags:** Use low-opacity background fills (e.g., 15% Emerald for "Stable," 15% Amber for "Pending") to maintain a clean look without overwhelming the dark theme.
- **Vitals Displays:** Specialized components featuring large Sora-Bold numbers with a subtle gradient sparkline beneath them to show 24-hour trends.
- **Lists:** High-density list items are separated by subtle dividers (#ffffff05) rather than large gaps to maximize information density.