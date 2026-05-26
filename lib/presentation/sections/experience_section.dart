// Experience timeline.
//
// Composition:
//   - SectionTitle "Experience" with mono eyebrow "02 / experience"
//   - A `.timeline` column iterating `experiences` from data/.
//     Each entry is a TimelineItem(experience: e, fromLeft: i.isEven) so
//     adjacent cards reveal from opposite sides on scroll.
//   - Uses the alternate background color so the section pops against
//     the bio paragraphs above.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../../core/constants/app_anchors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/experience_data.dart';
import '../widgets/section_container.dart';
import '../widgets/section_title.dart';
import '../widgets/timeline_item.dart';

class ExperienceSection extends StatelessComponent {
  const ExperienceSection({super.key});

  @override
  Component build(BuildContext context) {
    return SectionContainer(
      id: AppAnchors.experience,
      altBg: true,
      children: [
        const SectionTitle(
          eyebrow: '02 / experience',
          title: 'Where I’ve worked',
        ),

        div(classes: 'timeline', [
          for (final (i, exp) in experiences.indexed)
            TimelineItem(
              experience: exp,
              // Alternate reveal direction per index. The dot/rail
              // sit in a fixed column so only the card content slides
              // in — kept readable, never jarring.
              fromLeft: i.isEven,
            ),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.timeline').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap(row: AppSpacing.xl.rem),
    ),
  ];
}
