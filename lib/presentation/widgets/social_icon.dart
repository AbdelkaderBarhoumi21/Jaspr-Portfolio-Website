// Renders a SocialLink as an anchor with the inline SVG icon embedded
// directly into the DOM via `raw(...)`. The SVG uses `fill="currentColor"`
// so it picks up the link's `color` for hover transitions.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/models/social_link.dart';

class SocialIcon extends StatelessComponent {
  const SocialIcon({required this.link, super.key});

  final SocialLink link;

  @override
  Component build(BuildContext context) {
    // External links open in a new tab; mailto:/tel: stay in same context.
    final isExternal = link.url.startsWith('http');
    return a(
      href: link.url,
      target: isExternal ? Target.blank : null,
      attributes: {
        if (isExternal) 'rel': 'noopener noreferrer',
        'aria-label': link.label,
      },
      classes: 'social-icon glow-hover magnetic',
      [
        // The inline SVG sits inside an icon wrapper that grid-centers
        // it. Grid `place-items: center` is the most reliable way to
        // perfectly center inline-SVG regardless of any intrinsic
        // baseline/width attributes the SVG may carry.
        span(classes: 'social-icon__icon', [RawText(link.iconSvg)]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.social-icon').styles(
      display: Display.inlineFlex,
      width: 44.px,
      height: 44.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.textSecondary,
      raw: {
        'background': 'var(--glass-bg)',
        'border': '1px solid var(--glass-border)',
        'border-radius': '${AppSpacing.radiusFull}px',
        'transition': 'color 200ms var(--ease-out), background 200ms var(--ease-out)',
      },
    ),
    css('.social-icon:hover').styles(
      color: AppColors.textPrimary,
      raw: {
        'background': 'rgba(108, 99, 255, 0.18)',
      },
    ),
    // Inner wrapper that perfectly centers the SVG.
    css('.social-icon__icon').styles(
      display: Display.inlineFlex,
      width: 20.px,
      height: 20.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      raw: {'line-height': '0'},
    ),
    // Force the SVG to occupy the full wrapper, with no baseline gap.
    css('.social-icon svg').styles(
      display: Display.block,
      width: 100.percent,
      height: 100.percent,
    ),
  ];
}
