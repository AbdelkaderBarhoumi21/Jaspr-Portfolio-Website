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
  // 6. Reduced-motion safety net.
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
