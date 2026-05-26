// A named bucket of related skills (e.g. "Mobile", "Backend").
//
// Rendered as a labeled section in the Skills area; each entry in `skills`
// becomes a `SkillBadge`.

class SkillGroup {
  final String title;          // 'Mobile' / 'Backend' / 'Database' / 'DevOps'
  final List<String> skills;   // ['Flutter', 'Dart', 'BLoC/Cubit', …]

  const SkillGroup({
    required this.title,
    required this.skills,
  });
}
