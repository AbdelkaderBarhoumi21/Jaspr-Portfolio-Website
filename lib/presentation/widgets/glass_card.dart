// Glassmorphism surface — translucent bg + 1px hairline + backdrop blur.
//
// The base look (`.glass`) is declared in animation_styles.dart so it can
// be mixed with any other class (.tilt, .reveal-up, etc.). This widget
// just adds the consistent padding/radius and exposes a `tilt` toggle.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';

class GlassCard extends StatelessComponent {
  const GlassCard({
    required this.children,
    this.tilt = false,
    this.extraClasses,
    this.padding,
    super.key,
  });

  final List<Component> children;
  /// Enable the JS-driven 3D tilt on mouse hover.
  final bool tilt;
  /// Extra classes to combine (e.g. `'reveal-up'`).
  final String? extraClasses;
  /// Override the default `1.5rem` padding.
  final double? padding;

  @override
  Component build(BuildContext context) {
    final cls = StringBuffer('glass-card glass');
    if (tilt) cls.write(' tilt');
    if (extraClasses != null && extraClasses!.isNotEmpty) {
      cls.write(' ');
      cls.write(extraClasses);
    }
    return div(
      classes: cls.toString(),
      styles: padding != null
          ? Styles(padding: Padding.all(padding!.rem))
          : null,
      children,
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.glass-card').styles(
      padding: Padding.all(AppSpacing.cardPad.rem),
      raw: {
        'border-radius': '${AppSpacing.radiusLg}px',
      },
    ),
  ];
}
