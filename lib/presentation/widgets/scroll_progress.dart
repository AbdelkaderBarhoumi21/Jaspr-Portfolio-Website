// Top-of-page scroll progress indicator.
//
// Renders a 2px-tall fixed bar at the very top of the viewport. The bar's
// width is driven by a `--progress` CSS custom property (0..1), updated by
// the JS in `animation_scripts.dart` on every scroll frame.
//
// The bar uses the brand violet→cyan gradient and sits above the navbar.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ScrollProgress extends StatelessComponent {
  const ScrollProgress({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      attributes: const {'data-scroll-progress': ''},
      classes: 'scroll-progress',
      [
        // Inner fill — width is `calc(var(--progress, 0) * 100%)`.
        div(classes: 'scroll-progress__fill', []),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // Track: invisible 2px-tall fixed bar at the very top.
    css('.scroll-progress').styles(
      position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero),
      zIndex: const ZIndex(101), // above the navbar (which is 100)
      width: 100.percent,
      height: 2.px,
      pointerEvents: PointerEvents.none,
      raw: {
        'background': 'transparent',
      },
    ),

    // Fill: gradient that scales horizontally with --progress.
    css('.scroll-progress__fill').styles(
      width: 100.percent,
      height: 100.percent,
      raw: {
        'background': 'var(--brand-gradient)',
        'transform-origin': 'left center',
        'transform': 'scaleX(var(--progress, 0))',
        'will-change': 'transform',
        'transition': 'transform 80ms linear',
        'box-shadow': '0 0 8px rgba(108, 99, 255, 0.45)',
      },
    ),

    // Reduced motion: don't animate the transform — it still works,
    // just snaps instead of interpolating.
    css.media(MediaQuery.raw('(prefers-reduced-motion: reduce)'), [
      css('.scroll-progress__fill').styles(raw: {
        'transition': 'none',
      }),
    ]),
  ];
}
