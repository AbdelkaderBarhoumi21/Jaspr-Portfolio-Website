// Page footer — copyright, social icons row, and a small "built with"
// credit. Uses ProfileData for identity so there are no hardcoded strings.
//
// NOTE: Jaspr's HTML helper for <footer> is the lowercase identifier
// `footer`, which is distinct from this uppercase `Footer` class — so the
// unprefixed `dom.dart` import is fine.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/theme/app_theme.dart';
import '../../data/profile_data.dart';
import '../widgets/social_icon.dart';

class Footer extends StatelessComponent {
  const Footer({super.key});

  // Server pre-renders the year — fine, it's static anyway and the page
  // is rebuilt by `jaspr build` whenever you deploy.
  static int get _year => DateTime.now().year;

  @override
  Component build(BuildContext context) {
    return footer(classes: 'footer', [
      div(classes: 'footer__inner', [
        div(classes: 'footer__row', [
          span(classes: 'footer__copy', [
            Component.text('© $_year · ${ProfileData.name}'),
          ]),
          div(classes: 'footer__socials', [
            for (final s in ProfileData.socials) SocialIcon(link: s),
          ]),
        ]),
        span(classes: 'footer__built mono', [
          Component.text('Built with '),
          a(
            href: 'https://jaspr.site',
            target: Target.blank,
            attributes: const {'rel': 'noopener noreferrer'},
            classes: 'footer__link',
            [Component.text('Jaspr')],
          ),
          Component.text(' · Dart'),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.footer').styles(
      padding: Padding.symmetric(
        horizontal: AppSpacing.gutter.rem,
        vertical: AppSpacing.xl.rem,
      ),
      raw: {'border-top': '1px solid var(--divider)'},
    ),
    css('.footer__inner').styles(
      display: Display.flex,
      width: 100.percent,
      maxWidth: AppSpacing.containerXl.px,
      margin: Margin.symmetric(horizontal: Unit.auto),
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
    ),
    css('.footer__row').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      justifyContent: JustifyContent.spaceBetween,
      alignItems: AlignItems.center,
      gap: const Gap(row: Unit.rem(0.75), column: Unit.rem(1.0)),
    ),
    css('.footer__copy').styles(
      color: AppColors.textSecondary,
      fontSize: AppTypography.smallSize,
    ),
    css('.footer__socials').styles(
      display: Display.flex,
      gap: Gap(column: AppSpacing.sm.rem),
    ),
    css('.footer__built').styles(
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
    ),
    css('.footer__link').styles(
      color: AppColors.secondary,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
    ),
  ];
}
