// The project's color tokens.
//
// IMPORTANT — runtime values come from CSS variables, NOT hard-coded hex.
// Each `AppColors.x` returns `Color('var(--x)')` which resolves at render
// time. The actual hex values for both themes live in `:root` (dark) and
// `[data-theme="light"]` (light), declared in `global_styles.dart`.
//
// Why: this lets the theme toggle flip ONE attribute on <html> and the
// whole site recolors with a single CSS transition, without re-rendering
// any Dart components.
//
// Brand colors (primary violet + secondary cyan) and their gradient stops
// are intentionally NOT swapped between themes — they're brand identity.
// Only neutral surfaces and text colors change.

import 'package:jaspr/dom.dart';

abstract final class AppColors {
  // ----- Surfaces ----------------------------------------------------------
  static const Color bg          = Color('var(--bg)');
  static const Color bgAlt       = Color('var(--bg-alt)');
  static const Color surface     = Color('var(--surface)');

  // ----- Glassmorphism -----------------------------------------------------
  static const Color glassBg     = Color('var(--glass-bg)');
  static const Color glassBorder = Color('var(--glass-border)');

  // ----- Brand accents (same in both themes) -------------------------------
  static const Color primary       = Color('#6C63FF'); // violet
  static const Color secondary     = Color('#00D9FF'); // cyan
  static const Color primarySoft   = Color('var(--primary-soft)');
  static const Color secondarySoft = Color('var(--secondary-soft)');

  // ----- Text --------------------------------------------------------------
  static const Color textPrimary   = Color('var(--text-primary)');
  static const Color textSecondary = Color('var(--text-secondary)');
  static const Color textMuted     = Color('var(--text-muted)');

  // ----- Hairlines / dividers ----------------------------------------------
  static const Color divider = Color('var(--divider)');

  // ----- Semantic ----------------------------------------------------------
  static const Color shadow = Color('var(--shadow)');

  // ----- Gradient stops (raw strings used inside `linear-gradient(...)`) ---
  // Brand identity — never swapped between themes.
  static const String gradientStart = '#6C63FF';
  static const String gradientEnd   = '#00D9FF';
  static const String brandGradient =
      'linear-gradient(135deg, $gradientStart, $gradientEnd)';
}
