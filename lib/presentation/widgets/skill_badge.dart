// Monospace chip used in the Skills section and on Experience/Project cards
// for tech tags.
//
// Auto-looks up a brand/Lucide icon for the label via `iconFor()`. If no
// icon is registered, the badge silently renders without one (no fallback
// glyph — empty space looks cleaner than a generic # for one-off entries).
//
// `showIcon: false` disables the lookup entirely (useful for non-tech
// chips like the language list on the About bento).

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/tech_icons.dart';
import '../../core/theme/app_theme.dart';

class SkillBadge extends StatelessComponent {
  const SkillBadge({
    required this.label,
    this.showIcon = true,
    super.key,
  });

  final String label;

  /// When false, no icon is rendered even if one exists for `label`.
  final bool showIcon;

  @override
  Component build(BuildContext context) {
    final iconSvg = showIcon ? iconFor(label) : null;
    return span(classes: 'skill-badge glow-hover mono', [
      if (iconSvg != null) span(classes: 'skill-badge__icon', [RawText(iconSvg)]),
      span(classes: 'skill-badge__label', [Component.text(label)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.skill-badge').styles(
      display: Display.inlineFlex,
      padding: Padding.symmetric(
        horizontal: 0.65.rem,
        vertical: 0.32.rem,
      ),
      alignItems: AlignItems.center,
      gap: Gap(column: 0.4.rem),
      color: AppColors.textPrimary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
      fontWeight: AppTypography.medium,
      raw: {
        'background': 'var(--glass-bg)',
        'border': '1px solid var(--glass-border)',
        'border-radius': '${AppSpacing.radiusSm}px',
        // Stay on one line by default — but never let a single chip be
        // wider than its parent (otherwise long tags like "Firebase
        // (FCM, Storage, Cloud Functions)" overflow project cards).
        'white-space': 'nowrap',
        'max-width': '100%',
      },
    ),
    // The label can break onto a second line if the badge itself is
    // clamped to the container width.
    css('.skill-badge__label').styles(raw: {
      'overflow': 'hidden',
      'text-overflow': 'ellipsis',
    }),
    // Icon slot — tinted cyan so the brand mark pops a touch against
    // the chip text, but stays subtle.
    css('.skill-badge__icon').styles(
      display: Display.inlineFlex,
      width: 14.px,
      height: 14.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.secondary,
      raw: {'flex': '0 0 14px'},
    ),
    css('.skill-badge__icon svg').styles(
      display: Display.block,
      width: 100.percent,
      height: 100.percent,
    ),
    // On hover, brighten the icon to primary so it tracks the badge lift.
    css('.skill-badge:hover .skill-badge__icon').styles(
      color: AppColors.primary,
    ),
  ];
}
