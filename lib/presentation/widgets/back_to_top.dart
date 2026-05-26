// Floating back-to-top button.
//
// Hidden by default (`opacity: 0; pointer-events: none`). The JS in
// `animation_scripts.dart` toggles the `.is-visible` class on this element
// once the user has scrolled past ~600px (i.e. cleared the hero), giving
// it a smooth fade + slide-up entrance.
//
// Clicking it just sets `window.location.hash = ''` via the href `#home`
// fallback, which scrolls to the top thanks to global `scroll-behavior:
// smooth` in `global_styles.dart`.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';

class BackToTop extends StatelessComponent {
  const BackToTop({super.key});

  @override
  Component build(BuildContext context) {
    return a(
      href: AppAnchors.hash(AppAnchors.home),
      attributes: const {
        'data-back-to-top': '',
        'aria-label': 'Back to top',
      },
      classes: 'back-to-top glow-hover',
      [
        // Inline SVG arrow-up — uses currentColor so it inherits .back-to-top.
        Component.element(
          tag: 'svg',
          attributes: const {
            'xmlns': 'http://www.w3.org/2000/svg',
            'viewBox': '0 0 24 24',
            'fill': 'none',
            'stroke': 'currentColor',
            'stroke-width': '2.2',
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            'aria-hidden': 'true',
          },
          children: [
            Component.element(
              tag: 'path',
              attributes: const {'d': 'M12 19V5'},
              children: [],
            ),
            Component.element(
              tag: 'path',
              attributes: const {'d': 'M5 12l7-7 7 7'},
              children: [],
            ),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.back-to-top').styles(
      display: Display.inlineFlex,
      position: Position.fixed(bottom: 1.5.rem, right: 1.5.rem),
      zIndex: const ZIndex(95),
      width: 44.px,
      height: 44.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.textPrimary,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
      raw: {
        'background': 'var(--brand-gradient)',
        'border-radius': '${AppSpacing.radiusFull}px',
        'box-shadow': '0 12px 28px -10px rgba(108, 99, 255, 0.55)',
        'opacity': '0',
        'transform': 'translateY(12px) scale(0.9)',
        'pointer-events': 'none',
        'transition':
            'opacity 260ms var(--ease-out), '
            'transform 260ms var(--ease-out)',
      },
    ),
    // JS adds .is-visible once scrolled past the hero (~600px).
    css('.back-to-top.is-visible').styles(raw: {
      'opacity': '1',
      'transform': 'translateY(0) scale(1)',
      'pointer-events': 'auto',
    }),
    // SVG inside the button — explicit sizing so the line-icon centers.
    css('.back-to-top svg').styles(
      display: Display.block,
      width: 18.px,
      height: 18.px,
    ),

    // Tablet+: move it a touch further from the edge so it doesn't
    // crowd content next to the viewport corner.
    css('@media (min-width: ${AppSpacing.bpMd.toInt()}px)', [
      css('.back-to-top').styles(
        position: Position.fixed(bottom: 2.rem, right: 2.rem),
        width: 48.px,
        height: 48.px,
      ),
      css('.back-to-top svg').styles(width: 20.px, height: 20.px),
    ]),

    // Reduced motion: no transform, just opacity.
    css('@media (prefers-reduced-motion: reduce)', [
      css('.back-to-top').styles(raw: {'transform': 'none'}),
      css('.back-to-top.is-visible').styles(raw: {'transform': 'none'}),
    ]),
  ];
}
