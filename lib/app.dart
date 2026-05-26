// Root component for the portfolio.
//
// This is a static, single-page site — there is no client-side routing.
// `AppLayout` provides the chrome (navbar + footer + cursor); we just hand
// it the ordered list of scroll sections to render in <main>.

import 'package:jaspr/jaspr.dart';

import 'presentation/layout/app_layout.dart';
import 'presentation/sections/about_section.dart';
import 'presentation/sections/contact_section.dart';
import 'presentation/sections/experience_section.dart';
import 'presentation/sections/hero_section.dart';
import 'presentation/sections/projects_section.dart';
import 'presentation/sections/skills_section.dart';

class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return const AppLayout(
      sections: [
        HeroSection(),
        AboutSection(),
        ExperienceSection(),
        ProjectsSection(),
        SkillsSection(),
        ContactSection(),
      ],
    );
  }
}
