---
name: Vitality Core
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daea'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eefe'
  surface-container-high: '#e2e8f8'
  surface-container-highest: '#dce2f3'
  on-surface: '#151c27'
  on-surface-variant: '#3f4942'
  inverse-surface: '#2a313d'
  inverse-on-surface: '#ebf1ff'
  outline: '#6f7a71'
  outline-variant: '#bec9bf'
  surface-tint: '#006d44'
  primary: '#005232'
  on-primary: '#ffffff'
  primary-container: '#006d44'
  on-primary-container: '#93ecb8'
  inverse-primary: '#80d8a6'
  secondary: '#55615c'
  on-secondary: '#ffffff'
  secondary-container: '#d6e3dc'
  on-secondary-container: '#596560'
  tertiary: '#00531c'
  on-tertiary: '#ffffff'
  tertiary-container: '#006e28'
  on-tertiary-container: '#68f47f'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9cf5c1'
  primary-fixed-dim: '#80d8a6'
  on-primary-fixed: '#002111'
  on-primary-fixed-variant: '#005232'
  secondary-fixed: '#d9e5df'
  secondary-fixed-dim: '#bdc9c3'
  on-secondary-fixed: '#131e1a'
  on-secondary-fixed-variant: '#3d4944'
  tertiary-fixed: '#72fe88'
  tertiary-fixed-dim: '#53e16f'
  on-tertiary-fixed: '#002107'
  on-tertiary-fixed-variant: '#00531c'
  background: '#f9f9ff'
  on-background: '#151c27'
  surface-variant: '#dce2f3'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  display-md:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-lg:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 26px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Manrope
    fontSize: 10px
    fontWeight: '700'
    lineHeight: 14px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 20px
  gutter-mobile: 12px
---

## Brand & Style

The design system is anchored in the concept of "Nurturing Clarity." It is designed for a modern healthcare audience that seeks efficiency without sacrificing the human touch. The brand personality is calm, optimistic, and highly professional, aiming to reduce the anxiety typically associated with medical environments.

The visual style is **Corporate Modern with a Soft Edge**. It utilizes a light-filled interface that prioritizes legibility and ease of navigation. By mixing high-contrast primary actions with soft, tonal surfaces and generous whitespace, the design system creates an environment that feels both high-tech and deeply caring. Visual interest is maintained through subtle depth, utilizing backdrop blurs and soft shadows rather than harsh lines.

## Colors

The palette is centered around **Deep Forest Teal (#006D44)**, a color that evokes stability and growth. This is balanced by **Mint Tint (#E8F5EE)**, which serves as a soothing secondary color for large surfaces and background accents.

- **Primary:** Used for main actions, active states, and brand-critical elements.
- **Secondary:** Used for container backgrounds, chip selections, and subtle highlights.
- **Tertiary:** A vibrant accent green for success states and health indicators.
- **Neutrals:** A scale of cool greys is used for typography and borders to maintain a professional, clinical-yet-warm atmosphere. 
- **Backgrounds:** Pure white is reserved for cards and elevated surfaces, while the primary app background uses a very soft off-white to reduce eye strain.

## Typography

This design system uses **Manrope** for all levels to ensure a modern, geometric, yet highly legible experience. The typeface is chosen for its excellent rendering at small sizes (essential for medical data) and its friendly, open apertures.

- **Headlines:** Use a bold weight with slightly tighter letter-spacing to create a sense of authority and focus.
- **Body:** Set primarily in 16px for optimal readability. Use a medium weight (500) for interactive text and regular (400) for long-form descriptions.
- **Labels:** Use a semi-bold or bold weight to ensure small metadata remains legible and distinct from body copy.

## Layout & Spacing

The layout follows a **Fluid Grid** model with a focus on mobile-first constraints. 

- **Grid:** A 4-column grid for mobile and an 8-column grid for tablet. 
- **Rhythm:** All spacing is based on a 4px baseline unit. A 16px (md) unit is the standard padding for cards and containers, while 24px (lg) is used for vertical section separation.
- **Safe Areas:** Mobile screens must maintain a 20px horizontal margin to ensure content does not hug the glass edges, providing a spacious, premium feel.

## Elevation & Depth

Hierarchy is established through **Tonal Layers** and **Ambient Shadows**. Instead of heavy shadows, this design system uses:

- **Level 0 (Base):** Background color (#F9FAFB).
- **Level 1 (Cards):** White surface with a very soft, diffused shadow (0px 4px 20px rgba(0, 0, 0, 0.04)) and a 1px solid border in a very light grey (#F1F5F9).
- **Level 2 (Interactive/Floating):** Higher elevation used for FABs or active modals with a more pronounced shadow (0px 8px 30px rgba(0, 109, 68, 0.08)) to indicate interactivity.
- **Overlays:** Use a 20px background blur (System Material) for navigation bars and headers to maintain context of the content underneath.

## Shapes

The shape language is **Rounded**, favoring organic, approachable curves that feel safe and friendly.

- **Small Elements (Chips, Checkboxes):** 8px radius.
- **Medium Elements (Buttons, Inputs):** 12px-16px radius.
- **Large Elements (Cards, Bottom Sheets):** 24px radius. 
- **Visual Style:** Avoid sharp corners entirely. All container intersections should be smoothed to maintain the "Nurturing Clarity" brand narrative.

## Components

- **Buttons:** Primary buttons are pill-shaped or high-radius rectangles using the primary teal. Text is white, centered, and bold. Secondary buttons use the Mint Tint background with Teal text.
- **Cards:** The hallmark of the system. Cards feature 24px corner radii, a subtle 1px border, and 16px internal padding. Content should be grouped logically with plenty of "breathing room."
- **Inputs:** Text fields use a light grey stroke that turns Teal on focus. Labels should be floating or placed directly above the field in a smaller, bold font.
- **Chips:** Used for categories (e.g., "Cardiologist"). Active state: Teal background/White text. Inactive state: Mint background/Teal text.
- **Selection Controls:** Checkboxes and Radio buttons should be oversized for accessibility, using the Primary color for the "Checked" state.
- **Progress Indicators:** Use soft, rounded bars for health tracking, employing the Tertiary green for positive progress.