// Wraps a top-level scroll section with a stable `id` (for anchor links +
// ScrollSpy), consistent vertical padding, and a max-width inner column.
//
// Sections never set their own padding/width — they always come through
// here. That keeps spacing consistent across the site.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';

class SectionContainer extends StatelessComponent {
  const SectionContainer({
    required this.id,
    required this.children,
    this.altBg = false,
    super.key,
  });

  /// Section anchor id (no leading `#`).
  final String id;

  /// Use the alternate background color (`--bg-alt`) for visual rhythm.
  final bool altBg;

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return section(
      id: id,
      classes: altBg ? 'section section--alt' : 'section',
      [
        div(classes: 'section__inner', children),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.section').styles(
      position: Position.relative(),
      padding: Padding.symmetric(
        horizontal: AppSpacing.gutter.rem,
        vertical: AppSpacing.section.rem,
      ),
      raw: {'overflow': 'hidden'},
    ),
    css('.section--alt').styles(
      backgroundColor: AppColors.bgAlt,
    ),
    css('.section__inner').styles(
      width: 100.percent,
      maxWidth: AppSpacing.containerXl.px,
      margin: Margin.symmetric(horizontal: Unit.auto),
      position: Position.relative(),
      raw: {'z-index': '1'},
    ),
    css.media(MediaQuery.raw('(min-width: ${AppSpacing.bpMd.toInt()}px)'), [
      css('.section').styles(
        padding: Padding.symmetric(
          horizontal: AppSpacing.gutterDesktop.rem,
          vertical: AppSpacing.section.rem,
        ),
      ),
    ]),
  ];
}
