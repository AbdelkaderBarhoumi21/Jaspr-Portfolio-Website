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
  // 1. Font loading — Inter (body) + JetBrains Mono (code/skills).
  //    `css.import(...)` emits an `@import url(...)` rule.
  // -----------------------------------------------------------------
  css.import(
    'https://fonts.googleapis.com/css2'
    '?family=Inter:wght@400;500;600;700'
    '&family=JetBrains+Mono:wght@400;500;600'
    '&display=swap',
  ),

  // -----------------------------------------------------------------
  // 2. CSS custom properties on :root.
  //    Raw-CSS sites (gradients, glass, keyframes) reference these
  //    via `var(--primary)` so we don't repeat hex codes.
  // -----------------------------------------------------------------
  css(':root').styles(raw: {
    '--bg': '#080810',
    '--bg-alt': '#0F0F1A',
    '--surface': '#13131F',
    '--glass-bg': 'rgba(255, 255, 255, 0.05)',
    '--glass-border': 'rgba(255, 255, 255, 0.10)',
    '--primary': '#6C63FF',
    '--secondary': '#00D9FF',
    '--text-primary': '#E8E8F0',
    '--text-secondary': '#8888AA',
    '--text-muted': '#5A5A75',
    '--divider': 'rgba(255, 255, 255, 0.08)',
    '--brand-gradient': AppColors.brandGradient,
    '--ease-out': 'cubic-bezier(0.22, 1, 0.36, 1)',
    '--navbar-h': '${AppSpacing.navbarHeight}px',
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
      // Subtle dot-grid background pattern over the dark base color.
      'background-image':
          'radial-gradient(rgba(255, 255, 255, 0.04) 1px, transparent 1px)',
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
  css('@media (prefers-reduced-motion: reduce)', [
    css('*, *::before, *::after').styles(raw: {
      'animation-duration': '0.01ms !important',
      'animation-iteration-count': '1 !important',
      'transition-duration': '0.01ms !important',
      'scroll-behavior': 'auto !important',
    }),
  ]),
];
