// A single job entry rendered in the experience timeline.
//
// `period` is a human-readable string ("Apr 2026 – Present") rather than two
// DateTimes because the data comes from the CV verbatim and never needs to
// be sorted/compared programmatically.

class Experience {
  final String company;          // 'Oxton Digital'
  final String role;             // 'Mobile Software Engineer — Flutter & Android'
  final String location;         // 'Tunis, Tunisia' or 'Algiers, Algeria (Remote)'
  final String period;           // 'Apr 2026 – Present'
  final List<String> bullets;    // achievement bullets
  final List<String> tech;       // tech badges to render under the card

  const Experience({
    required this.company,
    required this.role,
    required this.location,
    required this.period,
    required this.bullets,
    required this.tech,
  });
}
