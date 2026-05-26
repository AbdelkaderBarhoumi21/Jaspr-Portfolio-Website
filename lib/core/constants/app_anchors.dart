// Section anchor IDs + their human-readable labels.
//
// Used in three places:
//   1. <section id="..."> in each scroll section.
//   2. <a href="#..."> links in the Navbar.
//   3. The JS ScrollSpy maps href -> section element via these same strings.
//
// Keep `items` in scroll order — the navbar renders the list as-is.

abstract final class AppAnchors {
  static const String home       = 'home';
  static const String about      = 'about';
  static const String experience = 'experience';
  static const String projects   = 'projects';
  static const String skills     = 'skills';
  static const String contact    = 'contact';

  /// `#hero` style helper.
  static String hash(String id) => '#$id';

  /// Ordered list rendered by the navbar. Tuple-style records keep label
  /// and id together without needing a one-off class.
  static const List<({String id, String label})> items = [
    (id: home,       label: 'Home'),
    (id: about,      label: 'About'),
    (id: experience, label: 'Experience'),
    (id: projects,   label: 'Projects'),
    (id: skills,     label: 'Skills'),
    (id: contact,    label: 'Contact'),
  ];
}
