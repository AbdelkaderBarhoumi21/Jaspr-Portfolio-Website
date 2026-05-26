// Monospace chip used in the Skills section and on Experience/Project cards
// for tech tags. Adds `.glow-hover` so it lifts + glows on hover.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';

class SkillBadge extends StatelessComponent {
  const SkillBadge({required this.label, super.key});

  final String label;

  @override
  Component build(BuildContext context) {
    return span(classes: 'skill-badge glow-hover mono', [Component.text(label)]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.skill-badge').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      padding: Padding.symmetric(
        horizontal: 0.75.rem,
        vertical: 0.35.rem,
      ),
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
        'white-space': 'nowrap',
      },
    ),
  ];
}
