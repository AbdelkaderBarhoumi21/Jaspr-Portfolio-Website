// A personal/portfolio project shown in the projects grid.
//
// `repoUrl` and `demoUrl` are nullable — not every project has a public link.

class Project {
  final String title;          // 'Real-time Chat App'
  final String description;    // 1–2 sentence summary
  final List<String> tags;     // ['Flutter', 'Rust', 'WebSockets', …]
  final String? repoUrl;       // GitHub or other source link
  final String? demoUrl;       // live demo, store listing, etc.

  const Project({
    required this.title,
    required this.description,
    required this.tags,
    this.repoUrl,
    this.demoUrl,
  });
}
