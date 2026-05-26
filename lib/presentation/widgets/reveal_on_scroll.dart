// A thin wrapper that drops a `reveal-*` class on a div around its child.
// The IntersectionObserver in animation_scripts.dart flips `.is-visible`
// when the element scrolls into view.
//
// For staggered children, pass `staggerIndex`. The wrapper sets
// `style="--i: N"` which the CSS multiplies into a transition-delay.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

enum RevealDirection { up, left, right, scale }

class RevealOnScroll extends StatelessComponent {
  const RevealOnScroll({
    required this.children,
    this.direction = RevealDirection.up,
    this.staggerIndex,
    this.extraClasses,
    super.key,
  });

  final List<Component> children;
  final RevealDirection direction;
  /// 0-based stagger index — sets `--i: N` for `transition-delay`.
  final int? staggerIndex;
  /// Extra classes to combine.
  final String? extraClasses;

  String get _revealClass {
    switch (direction) {
      case RevealDirection.up:    return 'reveal-up';
      case RevealDirection.left:  return 'reveal-left';
      case RevealDirection.right: return 'reveal-right';
      case RevealDirection.scale: return 'reveal-scale';
    }
  }

  @override
  Component build(BuildContext context) {
    final classes = StringBuffer(_revealClass);
    if (extraClasses != null && extraClasses!.isNotEmpty) {
      classes.write(' ');
      classes.write(extraClasses);
    }
    return div(
      classes: classes.toString(),
      attributes: staggerIndex != null
          ? {'style': '--i: ${staggerIndex!}'}
          : null,
      children,
    );
  }
}
