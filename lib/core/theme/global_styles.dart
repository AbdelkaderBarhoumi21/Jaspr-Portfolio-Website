// Global styles — CSS reset, font @import, body typography, scroll behavior,
// dot-grid background, and CSS custom properties bound from AppColors so
// raw CSS strings (gradients, glass, keyframes) can reference them as
// `var(--primary)` instead of duplicating hex values.
//
// Picked up automatically by the Jaspr builder via the `@css` annotation on
// the `globalStyles` getter below. Just import this file once from a file
// that participates in the build (e.g. `app.dart`).

import 'package:jaspr/dom.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

@css
List<StyleRule> get globalStyles => [
  // -----------------------------------------------------------------
  // 1. Font loading.
  //
  // The actual <link rel="stylesheet"> lives in main.server.dart so the
  // browser discovers it during HTML parse instead of waiting for our
  // stylesheet to download first (which is what `@import url(...)` would
  // force). We just declare the family stacks here.
  //
  // `font-display: swap` is set in the Google Fonts URL so text paints
  // immediately with the fallback while Inter/JetBrains Mono download.
  // -----------------------------------------------------------------

  // -----------------------------------------------------------------
  // 2. CSS custom properties — DARK palette (default) on :root.
  //
  //    The whole site reads its colors from these vars. To switch
  //    themes, the JS in the ThemeToggle component sets
  //    `data-theme="light"` on <html>; the [data-theme="light"]
  //    block below redefines the same vars with the light palette
  //    and CSS resolution does the rest.
  //
  //    Brand violet/cyan stay the same across themes — only neutral
  //    surfaces and text shift.
  // -----------------------------------------------------------------
  css(':root').styles(raw: {
    // Surfaces
    '--bg': '#080810',
    '--bg-alt': '#0F0F1A',
    '--surface': '#13131F',
    // Glass overlay — white tint at low alpha on dark surfaces.
    '--glass-bg': 'rgba(255, 255, 255, 0.05)',
    '--glass-border': 'rgba(255, 255, 255, 0.10)',
    // Brand
    '--primary': '#6C63FF',
    '--secondary': '#00D9FF',
    '--primary-soft':   'rgba(108, 99, 255, 0.18)',
    '--secondary-soft': 'rgba(0, 217, 255, 0.18)',
    // Text
    '--text-primary': '#E8E8F0',
    '--text-secondary': '#8888AA',
    '--text-muted': '#5A5A75',
    // Hairlines + semantic
    '--divider': 'rgba(255, 255, 255, 0.08)',
    '--shadow': 'rgba(0, 0, 0, 0.40)',
    // Bg color with alpha — used for sticky surfaces (navbar scrolled
    // state, palette backdrop) where we need page-tinted translucency.
    '--bg-translucent':       'rgba(8, 8, 16, 0.65)',
    '--bg-translucent-strong':'rgba(8, 8, 16, 0.55)',
    // Brand gradient (used wherever we need a CSS string).
    '--brand-gradient': AppColors.brandGradient,
    // Easing + layout constants.
    '--ease-out': 'cubic-bezier(0.22, 1, 0.36, 1)',
    '--navbar-h': '${AppSpacing.navbarHeight}px',
    // Color scheme — drives form-control / scrollbar rendering.
    'color-scheme': 'dark',
  }),

  // -----------------------------------------------------------------
  // 2b. LIGHT palette — applied when <html data-theme="light">.
  //
  //     Notes:
  //     - Surfaces shift to near-whites with a hint of cool blue, not
  //       pure white (`#FAFAFC`) — easier on the eyes.
  //     - Glass overlay swaps to BLACK at low alpha. White-on-light
  //       would vanish, black-on-light gives the same depth.
  //     - Hairlines / dividers also swap to dark-on-light.
  //     - Brand violet darkens slightly (`#5A4FEA`) for better contrast
  //       against a light surface; gradient stays brand-gradient string
  //       (still readable on the gradient-text headings against light bg).
  //     - color-scheme: light → scrollbars + form widgets become light.
  // -----------------------------------------------------------------
  css('[data-theme="light"]').styles(raw: {
    // Surfaces — cool off-white, very pale lavender alt, near-white card.
    '--bg': '#FAFAFC',
    '--bg-alt': '#F2F2F8',
    '--surface': '#FFFFFF',
    // Glass overlay — dark tint at low alpha.
    '--glass-bg': 'rgba(15, 15, 26, 0.04)',
    '--glass-border': 'rgba(15, 15, 26, 0.10)',
    // Brand — darken slightly for AA contrast on light surface.
    '--primary': '#5A4FEA',
    '--secondary': '#00B0D8',
    '--primary-soft':   'rgba(90, 79, 234, 0.14)',
    '--secondary-soft': 'rgba(0, 176, 216, 0.14)',
    // Text — near-black for primary, gray ramps below.
    '--text-primary': '#0F0F1A',
    '--text-secondary': '#52526A',
    '--text-muted': '#8A8AA0',
    // Hairlines + shadow.
    '--divider': 'rgba(15, 15, 26, 0.08)',
    '--shadow': 'rgba(0, 0, 0, 0.10)',
    // Sticky-surface translucency on light bg.
    '--bg-translucent':        'rgba(250, 250, 252, 0.78)',
    '--bg-translucent-strong': 'rgba(250, 250, 252, 0.68)',
    // Light-themed gradient — keep brand but darken stops slightly
    // so gradient-text remains legible on white.
    '--brand-gradient': 'linear-gradient(135deg, #5A4FEA, #00B0D8)',
    'color-scheme': 'light',
  }),

  // Smooth the theme transition — applied to a curated list of
  // properties so unrelated transitions (e.g. button hovers) keep
  // their existing snappy 180–240ms feel.
  css('html').styles(raw: {
    'transition':
        'background-color 260ms var(--ease-out), '
        'color 260ms var(--ease-out)',
  }),
  css('body, .glass, .navbar, .neon-btn, .skill-badge, '
      '.bento-tile, .timeline-card, .project-card, '
      '.channel-tile, .cmdk__panel, .cmdk-hint, .nav-toggle, '
      '.scroll-progress__fill, .back-to-top, .footer').styles(raw: {
    'transition':
        'background-color 220ms var(--ease-out), '
        'border-color 220ms var(--ease-out), '
        'color 220ms var(--ease-out), '
        'box-shadow 220ms var(--ease-out)',
  }),

  // -----------------------------------------------------------------
  // 3. Reset.
  // -----------------------------------------------------------------
  css('*, *::before, *::after').styles(
    padding: Padding.zero,
    margin: Margin.zero,
    boxSizing: BoxSizing.borderBox,
  ),

  css('html').styles(
    width: 100.percent,
    raw: {
      'scroll-behavior': 'smooth',
      'scroll-padding-top': 'var(--navbar-h)',
    },
  ),

  css('body').styles(
    minHeight: 100.vh,
    color: AppColors.textPrimary,
    fontFamily: const FontFamily.list([
      AppTypography.fontBody,
      FontFamilies.sansSerif,
    ]),
    fontSize: AppTypography.bodySize,
    lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    backgroundColor: AppColors.bg,
    raw: {
      '-webkit-font-smoothing': 'antialiased',
      '-moz-osx-font-smoothing': 'grayscale',
      'text-rendering': 'optimizeLegibility',
      // Subtle dot-grid background pattern.
      // Uses --divider so it auto-flips between light and dark themes.
      'background-image':
          'radial-gradient(var(--divider) 1px, transparent 1px)',
      'background-size': '24px 24px',
      'background-attachment': 'fixed',
    },
  ),

  // -----------------------------------------------------------------
  // 4. Base typography.
  // -----------------------------------------------------------------
  css('h1, h2, h3, h4').styles(
    color: AppColors.textPrimary,
    fontFamily: const FontFamily.list([
      AppTypography.fontBody,
      FontFamilies.sansSerif,
    ]),
    fontWeight: AppTypography.bold,
    letterSpacing: AppTypography.letterSpacingHeading,
    lineHeight: const Unit.expression('${AppTypography.lineHeightTight}'),
  ),

  // Fluid heading sizes via clamp() — not expressible through the typed
  // `fontSize: Unit?` API (which doesn't model clamp), so use `raw`.
  css('h1').styles(raw: {'font-size': AppTypography.h1Clamp}),
  css('h2').styles(raw: {'font-size': AppTypography.h2Clamp}),
  css('h3').styles(raw: {'font-size': AppTypography.h3Clamp}),

  css('p').styles(
    color: AppColors.textSecondary,
    fontSize: AppTypography.bodySize,
    lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
  ),

  css('a').styles(
    color: AppColors.textPrimary,
    textDecoration: const TextDecoration(line: TextDecorationLine.none),
  ),

  css('code, pre, .mono').styles(
    fontFamily: const FontFamily.list([
      AppTypography.fontMono,
      FontFamilies.monospace,
    ]),
  ),

  // -----------------------------------------------------------------
  // 5. Selection color.
  // -----------------------------------------------------------------
  css('::selection').styles(
    backgroundColor: AppColors.primarySoft,
    color: AppColors.textPrimary,
  ),

  // -----------------------------------------------------------------
  // 6. Film-grain texture.
  //
  // A fixed full-viewport pseudo-element painted with an SVG
  // fractal-noise pattern at 4% opacity. It sits BEHIND every
  // section (z-index 0) but ON TOP of the body background, giving
  // the dark surface a subtle "developer wallpaper" feel without
  // adding a single bitmap request.
  //
  // pointer-events: none so it never blocks clicks.
  // -----------------------------------------------------------------
  css('body::before').styles(raw: {
    'content': '""',
    'position': 'fixed',
    'inset': '0',
    'z-index': '0',
    'pointer-events': 'none',
    'opacity': '0.04',
    // Inline SVG → no extra HTTP request, no asset to track.
    'background-image':
        'url("data:image/svg+xml;utf8,'
        '<svg xmlns=%22http://www.w3.org/2000/svg%22 width=%22200%22 height=%22200%22>'
        '<filter id=%22n%22>'
        '<feTurbulence type=%22fractalNoise%22 baseFrequency=%220.85%22 numOctaves=%222%22 stitchTiles=%22stitch%22/>'
        '<feColorMatrix values=%221 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0.6 0%22/>'
        '</filter>'
        '<rect width=%22100%25%22 height=%22100%25%22 filter=%22url(%23n)%22/>'
        '</svg>")',
    'background-size': '200px 200px',
  }),

  // -----------------------------------------------------------------
  // 7. Focus styles — accessibility.
  //
  // Use `:focus-visible` so mouse clicks don't get a ring but keyboard
  // navigation does. The ring uses the brand violet and matches the
  // radius of the focused control (via inheritance from its `border-
  // radius`). Sits 2px outside the control so it never overlaps content.
  // -----------------------------------------------------------------
  css(':focus').styles(raw: {'outline': 'none'}),
  css(':focus-visible').styles(raw: {
    'outline': '2px solid var(--primary)',
    'outline-offset': '3px',
    'border-radius': 'inherit',
  }),
  // Inputs get a soft ring + matching border, no offset (looks cleaner
  // inside an input row).
  css('input:focus-visible, textarea:focus-visible').styles(raw: {
    'outline': 'none',
    'box-shadow': '0 0 0 2px rgba(108, 99, 255, 0.45)',
  }),

  // -----------------------------------------------------------------
  // 8. Reduced-motion safety net.
  //    Animation files also honor this — belt + suspenders.
  // -----------------------------------------------------------------
  css.media(MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
    css('*, *::before, *::after').styles(raw: {
      'animation-duration': '0.01ms !important',
      'animation-iteration-count': '1 !important',
      'transition-duration': '0.01ms !important',
      'scroll-behavior': 'auto !important',
    }),
  ]),
];
