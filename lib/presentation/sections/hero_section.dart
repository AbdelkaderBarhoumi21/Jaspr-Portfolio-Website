// Above-the-fold hero.
//
// Composition (top → bottom):
//   - hero-mesh background pseudo-element (drifting violet/cyan gradient)
//   - greeting ("Hi, I'm")
//   - <h1> gradient name with the `.name-enter` blur-in animation
//   - typewriter span cycling ProfileData.heroRoles
//   - tagline paragraph
//   - two CTA buttons (View My Work + Download CV)
//   - social icons row
//   - scroll bob arrow pointing to #about
//
// The section sits in `SectionContainer` so it inherits the standard
// horizontal gutters and max-width column.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/profile_data.dart';
import '../widgets/gradient_text.dart';
import '../widgets/neon_button.dart';
import '../widgets/section_container.dart';
import '../widgets/social_icon.dart';

class HeroSection extends StatelessComponent {
  const HeroSection({super.key});

  @override
  Component build(BuildContext context) {
    return SectionContainer(
      id: AppAnchors.home,
      children: [
        // Drifting gradient mesh, sits behind the content.
        div(classes: 'hero-mesh', []),

        div(classes: 'hero', [
          // Greeting eyebrow.
          span(classes: 'hero__greeting mono reveal-up', [
            Component.text(ProfileData.greeting),
          ]),

          // Name — blur-in entrance, gradient text.
          h1(classes: 'hero__name name-enter', [
            GradientText(text: ProfileData.name),
          ]),

          // Typewriter — cycles through heroRoles.
          // The JS reads `data-words` and animates this span.
          div(classes: 'hero__role-line reveal-up', [
            span(classes: 'hero__role-label mono', [
              Component.text('// I build as a '),
            ]),
            span(
              classes: 'typewriter hero__role',
              attributes: {
                'data-words': ProfileData.heroRoles.join('|'),
              },
              [Component.text(ProfileData.heroRoles.first)],
            ),
          ]),

          // Tagline.
          p(classes: 'hero__tagline reveal-up', [
            Component.text(ProfileData.tagline),
          ]),

          // CTAs.
          div(classes: 'hero__ctas reveal-up', [
            const NeonButton(
              label: 'View My Work',
              href: '#${AppAnchors.projects}',
            ),
            NeonButton(
              label: 'Download CV',
              href: ProfileData.cvPath,
              variant: NeonButtonVariant.secondary,
              download: true,
            ),
          ]),

          // Socials.
          div(classes: 'hero__socials reveal-up', [
            for (final s in ProfileData.socials) SocialIcon(link: s),
          ]),
        ]),

        // Scroll cue at the bottom of the viewport — bobs down to hint
        // that there's more content below.
        a(
          href: '#${AppAnchors.about}',
          classes: 'hero__scroll bob',
          attributes: const {'aria-label': 'Scroll to about'},
          [
            span(classes: 'mono', [Component.text('scroll')]),
            span(classes: 'hero__scroll-arrow', [Component.text('↓')]),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // ----- Make the section tall enough to feel like a hero -----
    css('#${AppAnchors.home}').styles(
      minHeight: 100.vh,
      display: Display.flex,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
    ),
    css('#${AppAnchors.home} .section__inner').styles(
      position: Position.relative(),
      raw: {'z-index': '1'},
    ),

    // ----- Layout -----
    css('.hero').styles(
      display: Display.flex,
      maxWidth: 760.px,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.md.rem),
    ),

    // ----- Greeting eyebrow -----
    css('.hero__greeting').styles(
      color: AppColors.secondary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.smallSize,
      letterSpacing: AppTypography.letterSpacingEyebrow,
    ),

    // ----- Name -----
    css('.hero__name').styles(
      margin: Margin.only(top: AppSpacing.xs.rem, bottom: AppSpacing.xs.rem),
    ),

    // ----- Role line (typewriter) -----
    css('.hero__role-line').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      alignItems: AlignItems.baseline,
      gap: Gap(column: 0.5.rem),
    ),
    css('.hero__role-label').styles(
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: 1.05.rem,
    ),
    css('.hero__role').styles(
      color: AppColors.textPrimary,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: 1.05.rem,
      fontWeight: AppTypography.semibold,
    ),

    // ----- Tagline -----
    css('.hero__tagline').styles(
      maxWidth: 580.px,
      margin: Margin.only(top: AppSpacing.sm.rem),
      color: AppColors.textSecondary,
      fontSize: 1.1.rem,
    ),

    // ----- CTAs -----
    css('.hero__ctas').styles(
      display: Display.flex,
      flexWrap: FlexWrap.wrap,
      margin: Margin.only(top: AppSpacing.md.rem),
      gap: const Gap(row: Unit.rem(0.75), column: Unit.rem(0.75)),
    ),

    // ----- Socials -----
    css('.hero__socials').styles(
      display: Display.flex,
      margin: Margin.only(top: AppSpacing.sm.rem),
      gap: Gap(column: AppSpacing.sm.rem),
    ),

    // ----- Scroll cue -----
    css('.hero__scroll').styles(
      display: Display.inlineFlex,
      position: Position.absolute(left: Unit.zero, right: Unit.zero, bottom: 1.5.rem),
      flexDirection: FlexDirection.column,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      gap: Gap(row: 0.35.rem),
      margin: Margin.symmetric(horizontal: Unit.auto),
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
    ),
    css('.hero__scroll:hover').styles(color: AppColors.textPrimary),
    css('.hero__scroll-arrow').styles(
      fontSize: 1.25.rem,
      raw: {'line-height': '1'},
    ),

    // ----- Stagger reveal: each direct .reveal-up child gets a delay -----
    // The base `.stagger > *` rule (in animation_styles.dart) reads --i;
    // here we just set --i on the reveal children inline-free by giving
    // each section item progressive delays via :nth-child.
    css('.hero > .reveal-up:nth-child(1)').styles(raw: {
      'transition-delay': '60ms',
    }),
    css('.hero > .reveal-up:nth-child(3)').styles(raw: {
      'transition-delay': '180ms',
    }),
    css('.hero > .reveal-up:nth-child(4)').styles(raw: {
      'transition-delay': '300ms',
    }),
    css('.hero > .reveal-up:nth-child(5)').styles(raw: {
      'transition-delay': '420ms',
    }),
    css('.hero > .reveal-up:nth-child(6)').styles(raw: {
      'transition-delay': '540ms',
    }),

    // ----- Tablet+ tweaks -----
    css('@media (min-width: ${AppSpacing.bpMd.toInt()}px)', [
      css('.hero__tagline').styles(fontSize: 1.2.rem),
      css('.hero__role').styles(fontSize: 1.2.rem),
      css('.hero__role-label').styles(fontSize: 1.2.rem),
    ]),
  ];
}
