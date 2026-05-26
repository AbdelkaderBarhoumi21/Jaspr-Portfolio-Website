// Typography tokens — fonts, sizes, weights, line-heights.
//
// Font files are loaded via Google Fonts in `core/theme/global_styles.dart`.
// This file only declares the names + scale.

import 'package:jaspr/dom.dart';

abstract final class AppTypography {
  // ----- Font families -----
  // Use these with the typed `fontFamily:` API on StyleRule.
  static const FontFamily fontBody = FontFamily('Inter');
  static const FontFamily fontMono = FontFamily('JetBrains Mono');

  // Convenience stacks (for places we need the raw CSS string).
  static const String bodyStack = "'Inter', system-ui, -apple-system, Segoe UI, sans-serif";
  static const String monoStack = "'JetBrains Mono', ui-monospace, SFMono-Regular, Menlo, monospace";

  // ----- Font sizes (CSS values via Unit helpers) -----
  // Headings use `clamp()` for fluid scaling — emitted as raw strings where
  // the typed API does not support clamp().
  static const String h1Clamp = 'clamp(2.5rem, 6vw, 5rem)';
  static const String h2Clamp = 'clamp(2rem, 4vw, 3rem)';
  static const String h3Clamp = 'clamp(1.25rem, 2vw, 1.5rem)';

  // Typed sizes (px/rem) for non-clamp use.
  static const Unit bodySize    = Unit.rem(1.0);
  static const Unit smallSize   = Unit.rem(0.875);
  static const Unit eyebrowSize = Unit.rem(0.75);

  // ----- Weights -----
  static const FontWeight regular  = FontWeight.w400;
  static const FontWeight medium   = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold     = FontWeight.w700;

  // ----- Line heights -----
  static const double lineHeightTight = 1.15;
  static const double lineHeightBody  = 1.6;

  // ----- Letter spacing (em) -----
  static const Unit letterSpacingHeading = Unit.em(-0.02);
  static const Unit letterSpacingEyebrow = Unit.em(0.18);
}
