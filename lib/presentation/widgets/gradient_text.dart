// A span with the brand violet→cyan gradient applied to its text via the
// `.gradient-text` utility class (defined in animation_styles.dart).
//
// Use inline inside an `h1`/`h2` to gradient only one word:
//   h1([text("I'm "), GradientText(text: 'Abdelkader')])

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class GradientText extends StatelessComponent {
  const GradientText({required this.text, this.classes, super.key});

  final String text;
  /// Extra classes to combine with `gradient-text` (e.g. animation hooks).
  final String? classes;

  @override
  Component build(BuildContext context) {
    final cls = classes == null ? 'gradient-text' : 'gradient-text $classes';
    return span(classes: cls, [Component.text(text)]);
  }
}
