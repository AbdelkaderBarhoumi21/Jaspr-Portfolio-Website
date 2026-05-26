// Contact section.
//
// Composition:
//   - SectionTitle "Let's build something great together"
//     (eyebrow "05 / contact")
//   - Short framing line
//   - Three glass channel tiles: Email / LinkedIn / GitHub
//     Each tile is a clickable <a> styled as a glass card, with an
//     inline SVG icon (pulled from the SocialLink it represents) and a
//     short label/value pair.
//   - Primary CTA button under the tiles linking to mailto:
//
// No contact form / backend — the brief explicitly asks for a mailto-only
// flow and this is a static SSG site.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/profile_data.dart';
import '../../domain/models/social_link.dart';
import '../widgets/neon_button.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';

class ContactSection extends StatelessComponent {
  const ContactSection({super.key});

  // Map the three channels back to their inline-SVG icons in ProfileData.
  // Resolved by `label` so it survives reordering the socials list.
  static SocialLink _findIcon(String label) =>
      ProfileData.socials.firstWhere((social) => social.label == label);

  @override
  Component build(BuildContext context) {
    final email    = _findIcon('Email');
    final linkedin = _findIcon('LinkedIn');
    final github   = _findIcon('GitHub');

    return SectionContainer(
      id: AppAnchors.contact,
      children: [
        const SectionTitle(
          eyebrow: '05 / contact',
          title: "Let’s build something great together",
        ),

        RevealOnScroll(
          direction: RevealDirection.up,
          children: [
            p(classes: 'contact__intro', [
              Component.text(
                "I’m open to mobile engineering roles, freelance builds, and "
                "interesting collaborations. The fastest way to reach me is by "
                "email — I usually reply within a day.",
              ),
            ]),
          ],
        ),

        div(classes: 'contact__grid stagger', [
          _ChannelTile(
            link: email,
            value: ProfileData.email,
            staggerIndex: 0,
          ),
          _ChannelTile(
            link: linkedin,
            value: 'in/barhoumi23176',
            staggerIndex: 1,
          ),
          _ChannelTile(
            link: github,
            value: '@AbdelkaderBarhoumi21',
            staggerIndex: 2,
          ),
        ]),

        RevealOnScroll(
          direction: RevealDirection.up,
          extraClasses: 'contact__cta-wrap',
          children: [
            const NeonButton(
              label: 'Say hi via email',
              href: ProfileData.mailto,
            ),
          ],
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // ----- Intro line -----
    css('.contact__intro').styles(
      maxWidth: 640.px,
      margin: Margin.only(bottom: AppSpacing.xl.rem),
      color: AppColors.textSecondary,
      fontSize: 1.1.rem,
      lineHeight: const Unit.expression('${AppTypography.lineHeightBody}'),
    ),

    // ----- Tile grid -----
    css('.contact__grid').styles(
      display: Display.grid,
      margin: Margin.only(bottom: AppSpacing.xl.rem),
      gap: Gap(row: AppSpacing.md.rem, column: AppSpacing.md.rem),
      raw: {'grid-template-columns': '1fr'},
    ),
    css('@media (min-width: ${AppSpacing.bpMd.toInt()}px)', [
      css('.contact__grid').styles(raw: {
        'grid-template-columns': 'repeat(3, minmax(0, 1fr))',
      }),
    ]),

    // ----- Tile (the clickable card) -----
    css('.channel-tile').styles(
      display: Display.flex,
      padding: Padding.all(AppSpacing.lg.rem),
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.sm.rem),
      color: AppColors.textPrimary,
      textDecoration: const TextDecoration(line: TextDecorationLine.none),
      raw: {
        'border-radius': '${AppSpacing.radiusLg}px',
        'transition':
            'transform 220ms var(--ease-out), '
            'box-shadow 220ms var(--ease-out), '
            'border-color 220ms var(--ease-out)',
      },
    ),
    css('.channel-tile:hover').styles(raw: {
      'transform': 'translateY(-3px)',
      'box-shadow': '0 14px 32px -10px rgba(108, 99, 255, 0.45)',
      'border-color': 'rgba(108, 99, 255, 0.40)',
    }),

    // Icon sits in a small gradient halo at the top-left of the tile.
    css('.channel-tile__icon').styles(
      display: Display.inlineFlex,
      width: 44.px,
      height: 44.px,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: AppColors.secondary,
      raw: {
        'background': 'rgba(0, 217, 255, 0.10)',
        'border': '1px solid rgba(0, 217, 255, 0.22)',
        'border-radius': '${AppSpacing.radiusMd}px',
      },
    ),
    css('.channel-tile__icon svg').styles(width: 20.px, height: 20.px),

    css('.channel-tile__label').styles(
      color: AppColors.textMuted,
      fontFamily: const FontFamily.list([
        AppTypography.fontMono,
        FontFamilies.monospace,
      ]),
      fontSize: AppTypography.eyebrowSize,
      textTransform: TextTransform.upperCase,
      letterSpacing: AppTypography.letterSpacingEyebrow,
    ),
    css('.channel-tile__value').styles(
      color: AppColors.textPrimary,
      fontSize: 1.05.rem,
      fontWeight: AppTypography.semibold,
      raw: {'word-break': 'break-word'},
    ),

    // ----- CTA wrapper -----
    css('.contact__cta-wrap').styles(
      display: Display.flex,
      justifyContent: JustifyContent.center,
    ),
  ];
}

// Private composition — one clickable contact channel tile.
class _ChannelTile extends StatelessComponent {
  const _ChannelTile({
    required this.link,
    required this.value,
    required this.staggerIndex,
  });

  /// The SocialLink whose `iconSvg`, `label`, and `url` drive the tile.
  final SocialLink link;

  /// Human-readable handle/address shown below the label
  /// (e.g. the full email, "in/barhoumi23176", "@AbdelkaderBarhoumi21").
  final String value;

  final int staggerIndex;

  @override
  Component build(BuildContext context) {
    final isExternal = link.url.startsWith('http');
    return RevealOnScroll(
      direction: RevealDirection.up,
      staggerIndex: staggerIndex,
      children: [
        a(
          href: link.url,
          target: isExternal ? Target.blank : null,
          attributes: isExternal
              ? const {'rel': 'noopener noreferrer'}
              : null,
          classes: 'channel-tile glass',
          [
            span(classes: 'channel-tile__icon', [RawText(link.iconSvg)]),
            span(classes: 'channel-tile__label', [
              Component.text(link.label),
            ]),
            span(classes: 'channel-tile__value', [Component.text(value)]),
          ],
        ),
      ],
    );
  }
}
