// Title block used at the top of every section: small uppercase eyebrow
// chip + a gradient h2. Wrapped in `.reveal-up` so it slides in on scroll.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';
import 'gradient_text.dart';

class SectionTitle extends StatelessComponent {
  const SectionTitle({
    required this.title,
    this.eyebrow,
    super.key,
  });

  /// Heading text (rendered with the violet→cyan gradient).
  final String title;
  /// Optional small uppercase label above the heading ("03 / Projects").
  final String? eyebrow;

  @override
  Component build(BuildContext context) {
    return div(classes: 'section-title reveal-up', [
      if (eyebrow != null)
        span(classes: 'section-title__eyebrow', [Component.text(eyebrow!)]),
      h2([GradientText(text: title)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.section-title').styles(
      margin: Margin.only(bottom: AppSpacing.xl.rem),
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.sm.rem),
    ),
    css('.section-title__eyebrow').styles(
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      textTransform: TextTransform.upperCase,
      letterSpacing: AppTypography.letterSpacingEyebrow,
    ),
  ];
}
