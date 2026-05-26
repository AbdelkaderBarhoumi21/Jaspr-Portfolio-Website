// Brand CTA button — rendered as an `<a>` so it can carry anchor links,
// mailto:, external URLs, or downloads.
//
//   NeonButton(label: 'View My Work',      href: '#projects')                // primary
//   NeonButton(label: 'Download CV',       href: '/cv.pdf', variant: secondary, download: true)
//   NeonButton(label: 'Get in touch',      href: 'mailto:...', variant: secondary)

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';

enum NeonButtonVariant { primary, secondary }

class NeonButton extends StatelessComponent {
  const NeonButton({
    required this.label,
    required this.href,
    this.variant = NeonButtonVariant.primary,
    this.target,
    this.download = false,
    this.trailingIcon,
    super.key,
  });

  final String label;
  final String href;
  final NeonButtonVariant variant;
  /// Set to `Target.blank` for external links.
  final Target? target;
  /// When true, browser treats the link as a download (CV button).
  final bool download;
  /// Optional small icon shown after the label (e.g. an arrow).
  final Component? trailingIcon;

  @override
  Component build(BuildContext context) {
    final classes = StringBuffer('neon-btn glow-hover');
    classes.write(variant == NeonButtonVariant.primary
        ? ' neon-btn--primary glow-pulse'
        : ' neon-btn--secondary');

    return a(
      href: href,
      target: target,
      classes: classes.toString(),
      attributes: download ? const {'download': ''} : null,
      [
        span([Component.text(label)]),
        if (trailingIcon != null) trailingIcon!,
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.neon-btn').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      gap: Gap(column: AppSpacing.sm.rem),
      padding: Padding.symmetric(
        horizontal: 1.5.rem,
        vertical: 0.85.rem,
      ),
      fontFamily: const FontFamily.list([
        AppTypography.fontBody,
        FontFamilies.sansSerif,
      ]),
      fontSize: AppTypography.bodySize,
      fontWeight: AppTypography.semibold,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
      cursor: Cursor.pointer,
      raw: {
        'border-radius': '${AppSpacing.radiusMd}px',
        'user-select': 'none',
      },
    ),

    // Primary — gradient fill, white text.
    css('.neon-btn--primary').styles(
      color: AppColors.textPrimary,
      raw: {
        'background': 'var(--brand-gradient)',
        'border': '1px solid transparent',
        'box-shadow': '0 8px 24px -8px rgba(108, 99, 255, 0.55)',
      },
    ),

    // Secondary — transparent + violet border.
    css('.neon-btn--secondary').styles(
      color: AppColors.textPrimary,
      raw: {
        'background': 'transparent',
        'border': '1px solid var(--primary)',
      },
    ),

    css('.neon-btn--secondary:hover').styles(raw: {
      'background': 'rgba(108, 99, 255, 0.10)',
    }),
  ];
}
