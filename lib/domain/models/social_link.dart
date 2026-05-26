// A link to an external profile (GitHub, LinkedIn, email, phone, …).
//
// `iconSvg` holds the raw inline SVG markup so we can drop it straight into
// the DOM via the `raw(...)` HTML helper, avoiding extra HTTP requests and
// keeping the icon styleable via `currentColor`.

class SocialLink {
  final String label;     // e.g. 'GitHub' — used for aria-label
  final String url;       // e.g. 'https://github.com/AbdelkaderBarhoumi21'
  final String iconSvg;   // inline SVG markup; must use `fill="currentColor"`

  const SocialLink({
    required this.label,
    required this.url,
    required this.iconSvg,
  });
}
