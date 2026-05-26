---
name: Vitality Dark & Light
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
  on-surface-variant: '#bec9bf'
  inverse-surface: '#c6ebd1'
  inverse-on-surface: '#163725'
  outline: '#88938a'
  outline-variant: '#3f4942'
  surface-tint: '#80d8a6'
  primary: '#80d8a6'
  on-primary: '#003921'
  primary-container: '#006d44'
  on-primary-container: '#93ecb8'
  inverse-primary: '#006d44'
  secondary: '#40e78c'
  on-secondary: '#00391c'
  secondary-container: '#00ca73'
  on-secondary-container: '#004e29'
  tertiary: '#ffb3b1'
  on-tertiary: '#5c171b'
  tertiary-container: '#984546'
  on-tertiary-container: '#ffcdcc'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#9cf5c1'
  primary-fixed-dim: '#80d8a6'
  on-primary-fixed: '#002111'
  on-primary-fixed-variant: '#005232'
  secondary-fixed: '#5dffa1'
  secondary-fixed-dim: '#37e187'
  on-secondary-fixed: '#00210e'
  on-secondary-fixed-variant: '#00522b'
  tertiary-fixed: '#ffdad8'
  tertiary-fixed-dim: '#ffb3b1'
  on-tertiary-fixed: '#3f0209'
  on-tertiary-fixed-variant: '#792e30'
  background: '#00180b'
  on-background: '#c6ebd1'
  surface-variant: '#1b3b29'
typography:
  display-lg:
    fontFamily: manrope
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: manrope
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
  headline-md:
    fontFamily: manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-lg:
    fontFamily: manrope
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: manrope
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-sm:
    fontFamily: manrope
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 16px
  lg: 24px
  xl: 32px
  gutter: 16px
  margin-mobile: 16px
  margin-desktop: 64px
---

## Brand & Style
The design system is centered on a "Deep Vitality" philosophy, merging the clinical precision of healthcare with the immersive, premium feel of high-end wellness apps. The target audience includes health-conscious individuals and patients seeking a calm, authoritative, and sophisticated monitoring experience.

The visual style is **Corporate Modern with Glassmorphism**. It utilizes high-quality typography and strategic translucent layers to create a sense of depth and data hierarchy. The emotional response should be one of "Trusted Growth"—the deep greens provide a sense of stability, while the soft rounded corners and glass effects ensure the interface remains approachable and cutting-edge.

## Colors
The palette is built upon a foundation of "Emerald Growth." 

**Dark Mode (Primary):** The base uses `#002111`, a deep black-green, providing a more sophisticated and less straining environment than pure black. Surfaces are slightly elevated using `#012b17` to create tonal separation.

**Light Mode:** The base shifts to a clean, clinical `#f0fdf4` tint to maintain brand continuity, using pure white for primary content surfaces.

**Action Colors:** The primary action color is `#006d44` (Emerald Green). For highlights and positive data trends, a vibrant secondary `#32de84` is utilized. Semantic colors (Red for alerts, Amber for warnings) should be desaturated in dark mode to prevent visual vibration.

## Typography
This design system utilizes **Manrope** for its balanced, modern, and highly legible characteristics. 

The type scale is optimized for data density. Headlines use a tighter letter-spacing and heavier weights to establish a strong hierarchy. Body text is set with generous line heights to ensure readability of medical information and long-form wellness articles. For mobile devices, top-level headlines scale down slightly to ensure words do not break awkwardly on narrow viewports.

## Layout & Spacing
The layout follows a **Fluid Grid** model based on an 8px square rhythm. 

- **Mobile:** 4-column grid with 16px margins and 16px gutters.
- **Tablet:** 8-column grid with 24px margins and 16px gutters.
- **Desktop:** 12-column grid with dynamic margins (up to 1440px max-width) and 24px gutters.

Spacing between related elements (like an input and its label) should use `xs` or `base`. Spacing between distinct sections or cards should use `lg` or `xl`.

## Elevation & Depth
Depth is expressed through a combination of **Tonal Layers** and **Glassmorphism**.

1.  **Background:** The base level (Dark: `#002111`).
2.  **Surface Level:** Standard cards and containers use a slightly lighter fill. In dark mode, this is `#012b17`.
3.  **Floating/Glass Layer:** For high-priority data or navigation bars, use a backdrop-filter (`blur(12px)`) with a semi-transparent white (Light Mode, 70% opacity) or dark green (Dark Mode, 40% opacity) fill.
4.  **Shadows:** Shadows are soft and diffused. Use a "tinted shadow" approach—instead of pure black, use a semi-transparent version of the primary background color to avoid a "muddy" look.

## Shapes
The shape language is defined by **Round Eight (8px)**.

- **Small elements (Buttons, Inputs, Chips):** Use a standard 8px radius.
- **Medium elements (Cards, Modals):** Use 16px (`rounded-lg`) to create a softer, more protective feel around data groups.
- **Large elements (Bottom Sheets):** Use 24px (`rounded-xl`) on top corners for a fluid, organic transition.

## Components

**Buttons**
Primary buttons use the Emerald Green (`#006d44`) with white text. Secondary buttons use a subtle "Glass" style: a semi-transparent stroke with a light background blur.

**Cards**
The "Vitality Card" is the core unit. It features a 1px inner stroke (border) of `#ffffff10` in dark mode to define the edge against the dark background. Large cards (e.g., Activity Tracking) should use glassmorphism for the header section.

**Inputs**
Fields are 48px in height with an 8px radius. In dark mode, the input fill is `#002111` with a 1px stroke of `#ffffff20`. On focus, the stroke transitions to Emerald Green.

**Chips/Badges**
Small, 32px height elements with fully rounded (pill) ends. These are used for health categories (e.g., "Heart Rate," "Sleep").

**Health Charts**
Gradients should be used for data lines, transitioning from `#006d44` to `#32de84`. Chart backgrounds should be clear of unnecessary grid lines to maintain the minimalist aesthetic.