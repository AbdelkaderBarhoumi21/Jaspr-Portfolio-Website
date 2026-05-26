// Spacing scale, radii, and layout constants.
//
// Express values as raw `double` rems/px so consumers can append `.rem` /
// `.px` extensions from `package:jaspr/dom.dart` themselves. This keeps the
// scale numeric (easy to do math on) and the unit explicit at the call site.

abstract final class AppSpacing {
  // ----- Spacing scale (rem) -----
  static const double xs   = 0.25;
  static const double sm   = 0.5;
  static const double md   = 1.0;
  static const double lg   = 1.5;
  static const double xl   = 2.5;
  static const double xxl  = 4.0;
  static const double section = 6.0;   // vertical padding of a top-level section
  static const double gutter  = 1.5;   // horizontal page gutter (mobile)
  static const double gutterDesktop = 2.5;

  // ----- Container widths (px) -----
  static const double containerSm  = 640;
  static const double containerMd  = 768;
  static const double containerLg  = 1024;
  static const double containerXl  = 1180; // page max-width

  // ----- Radii (px) -----
  static const double radiusSm = 8;   // chips, badges
  static const double radiusMd = 14;  // buttons, inputs
  static const double radiusLg = 20;  // cards
  static const double radiusXl = 28;
  static const double radiusFull = 999;

  // ----- Component sizes -----
  static const double navbarHeight = 72;  // px — used for scroll offset
  static const double cardPad = 1.5;      // rem — default GlassCard padding

  // ----- Breakpoints (px) — mobile-first -----
  static const double bpSm = 480;
  static const double bpMd = 768;
  static const double bpLg = 1024;
  static const double bpXl = 1280;
}
