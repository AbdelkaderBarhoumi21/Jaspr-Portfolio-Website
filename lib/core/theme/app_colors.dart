// The project's color palette — the only place hex codes are allowed to live.
//
// Like Flutter's `AppColors` class, every section/widget imports from here
// instead of typing literal hex codes. To re-theme the site, edit this file.

import 'package:jaspr/dom.dart';

abstract final class AppColors {
  // Surfaces
  static const Color bg          = Color('#080810'); // page background (ultra-dark, not pure black)
  static const Color bgAlt       = Color('#0F0F1A'); // alternating section background
  static const Color surface     = Color('#13131F'); // solid card surface

  // Glassmorphism
  static const Color glassBg     = Color('rgba(255, 255, 255, 0.05)');
  static const Color glassBorder = Color('rgba(255, 255, 255, 0.10)');

  // Accents
  static const Color primary     = Color('#6C63FF'); // violet
  static const Color secondary   = Color('#00D9FF'); // cyan
  static const Color primarySoft = Color('rgba(108, 99, 255, 0.18)'); // hover glow
  static const Color secondarySoft = Color('rgba(0, 217, 255, 0.18)');

  // Text
  static const Color textPrimary   = Color('#E8E8F0');
  static const Color textSecondary = Color('#8888AA');
  static const Color textMuted     = Color('#5A5A75');

  // Hairlines
  static const Color divider = Color('rgba(255, 255, 255, 0.08)');

  // Semantic
  static const Color shadow = Color('rgba(0, 0, 0, 0.40)');

  // Gradient stops (used as raw strings in `linear-gradient(...)`).
  // Keep these in sync with `primary` / `secondary`.
  static const String gradientStart = '#6C63FF';
  static const String gradientEnd   = '#00D9FF';
  static const String brandGradient =
      'linear-gradient(135deg, $gradientStart, $gradientEnd)';
}
