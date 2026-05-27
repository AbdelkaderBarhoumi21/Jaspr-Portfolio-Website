/// The entrypoint for the **server** environment.
///
/// The [main] method only runs on the server during pre-rendering (static
/// mode). For browser-side code see `main.client.dart`.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
// Importing these files (even just for the side effect of their `@css`
// annotations) ensures the Jaspr builder includes those rules in the
// generated stylesheet.
import 'core/animations/animation_scripts.dart';
import 'core/animations/animation_styles.dart';
import 'core/theme/global_styles.dart';
import 'data/profile_data.dart';
// Generated file — do not edit.
import 'main.server.options.dart';

// ---------------------------------------------------------------------------
// SEO constants — kept here (next to the Document) rather than in
// ProfileData so the section files stay focused on UI content.
// ---------------------------------------------------------------------------
const _siteTitle = 'Abdelkader Barhoumi — Mobile Software Engineer';
const _siteDescription =
    'Portfolio of Barhoumi Abdelkader — Mobile Software Engineer building '
    'high-performance Flutter & Android apps with clean architecture, '
    'BLE/IoT integrations, and full-stack Rust/Node backends.';
// Public URL of the deployed site (used in canonical / OG / Twitter tags).
// Override at build time via `--dart-define-server=SITE_URL=https://...`.
// MUST end with a trailing slash.
const _siteUrl = String.fromEnvironment(
  'SITE_URL',
  defaultValue: 'https://abdelkaderbarhoumi21.github.io/portfolio/',
);
const _ogImage = 'images/og-card.png'; // 1200×630 recommended; drop in web/images/

// ---------------------------------------------------------------------------
// Base href.
//
// When this site is hosted at the root of a domain (e.g.
// https://example.com/), base should be '/'. When hosted under a subpath
// such as GitHub Pages project pages
// (https://user.github.io/portfolio/), base must be '/portfolio/'.
//
// The value is supplied at build time via:
//   jaspr build --dart-define-server=BASE_HREF=/portfolio/
// and falls back to '/' for local `jaspr serve`.
// ---------------------------------------------------------------------------
const _baseHref = String.fromEnvironment('BASE_HREF', defaultValue: '/');

// ---------------------------------------------------------------------------
// Favicon — inline-SVG data URL.
//
// Embedded directly in the HTML head so it never 404s, never caches stale,
// never depends on the build output copying a binary asset over. Renders
// crisp at any size (tabs, bookmarks, taskbar).
//
// Composition: transparent background, AB monogram paths (mirrors
// web/images/logo.svg) filled with the brand violet→cyan gradient so
// the mark reads on light AND dark browser tab chrome without a pill.
// viewBox matches the source SVG's 4000×4000 coordinate system so the
// paths sit unmodified.
// ---------------------------------------------------------------------------
const _faviconDataUri =
    'data:image/svg+xml;utf8,'
    '<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 4000 4000%22>'
    '<defs>'
    '<linearGradient id=%22g%22 x1=%220%22 y1=%220%22 x2=%221%22 y2=%221%22>'
    '<stop offset=%220%22 stop-color=%22%236C63FF%22/>'
    '<stop offset=%221%22 stop-color=%22%2300D9FF%22/>'
    '</linearGradient>'
    '</defs>'
    '<g fill=%22url(%23g)%22 fill-rule=%22evenodd%22 clip-rule=%22evenodd%22>'
    '<path d=%22M2653.652,2828.257h249.704c231.174,0,420.312-189.139,420.312-420.311c0-94.366-31.516-181.726-84.543-252.078c-26.72-35.45-58.903-66.58-95.268-92.111c-43.229,45.323-95.27,82.158-153.281,107.761c10.292,3.826,20.272,8.306,29.889,13.391c80.082,42.351,134.97,126.595,134.97,223.037c0,138.644-113.445,252.078-252.08,252.078h-89.86h-256.973L2653.652,2828.257z%22/>'
    '<path d=%22M1388.119,1931.875l194.658-337.155l147.078-254.745l-97.13-168.232l-480.176,831.688c60.874-37.902,130.358-62.097,203.679-69.781C1367.007,1932.52,1377.54,1932.061,1388.119,1931.875%22/>'
    '<path d=%22M1877.257,1931.748l-341.661-591.771l97.13-168.234l438.791,760.005H1877.257z M2394.861,2828.257l-267.338-463.04l-88.601-153.459h194.258l355.938,616.5H2394.861z%22/>'
    '<path d=%22M1384.934,2155.868h1414.597c231.174,0,420.311-189.139,420.311-420.311c0-94.366-31.516-181.726-84.542-252.078c-35.99-47.748-81.889-87.66-134.567-116.609c-49.912-27.427-105.911-45.013-165.335-50.096c-11.827-1.011-23.789-1.527-35.866-1.527H1780.112l97.13,168.232c372.183,0,550.107,0,922.29,0c42.201,0,82.067,10.51,117.109,29.041c80.082,42.351,134.97,126.595,134.97,223.038c0,138.644-113.448,252.078-252.079,252.078H1410.88c-17.175,0-31.42-0.224-48.828,1.598c-129.593,13.581-251.357,86.686-321.113,207.508l-364.605,631.515H870.59l316.041-547.399C1229.489,2206.624,1305.087,2162.419,1384.934,2155.868%22/>'
    '</g>'
    '</svg>';

// ---------------------------------------------------------------------------
// Pre-hydration theme script.
//
// Runs synchronously (NOT deferred) before any pixels are painted, so a
// returning light-mode user never sees the dark default flash. Order:
//   1. Read the persisted preference from `localStorage.theme`.
//   2. Fall back to the OS preference (`prefers-color-scheme: light`).
//   3. Default to dark.
// Then set `data-theme` on `<html>`, which the global :root / [data-theme]
// CSS blocks pick up before first paint.
//
// Wrapped in try/catch because some browsers throw on localStorage in
// private mode — we just no-op and let the default styles win.
// ---------------------------------------------------------------------------
const _themeBootstrapScript = '''
(function(){
  try {
    var stored = localStorage.getItem('theme');
    var mql = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)');
    var theme = stored || (mql && mql.matches ? 'light' : 'dark');
    document.documentElement.setAttribute('data-theme', theme);
  } catch (_) {}
})();
''';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  // Touch the style getters so the imports are never tree-shaken.
  // (Cheap — runs once at server startup.)
  // ignore: unused_local_variable
  final _ = [globalStyles, animationStyles];

  runApp(
    Document(
      title: _siteTitle,
      lang: 'en',
      base: _baseHref,
      // `Document(meta: ...)` emits standard <meta name="..."> tags.
      // Open Graph and Twitter tags use `property=` / non-`name` attributes,
      // so they're rendered via explicit `meta(...)` components in `head:`.
      meta: const {
        'description': _siteDescription,
        'author': ProfileData.name,
        'keywords':
            'Flutter, Dart, Android, Kotlin, Jetpack Compose, BLoC, '
            'Riverpod, mobile engineer, portfolio, ${ProfileData.location}',
        'theme-color': '#080810',
        'color-scheme': 'dark',
        'robots': 'index, follow',
      },
      head: const [
        // -----------------------------------------------------------------
        // Favicons — inline SVG data URL.
        //
        // Embedded directly in <head>, so the browser doesn't have to
        // make a separate request for an asset that could 404, cache
        // stale, or take time to load. SVG also scales sharp at every
        // tab/bookmark/PWA size. Apple Touch Icon points at the same
        // data URL — iOS handles it correctly since Safari 13.
        // -----------------------------------------------------------------
        link(
          rel: 'icon',
          href: _faviconDataUri,
          type: 'image/svg+xml',
        ),
        link(
          rel: 'apple-touch-icon',
          href: _faviconDataUri,
        ),

        // -----------------------------------------------------------------
        // Fonts — Inter (body) + JetBrains Mono (code).
        //
        // Loaded via <link rel="stylesheet"> directly in <head> so the
        // browser discovers the font CSS during HTML parse, in parallel
        // with our own stylesheet. Significantly faster LCP than the
        // `@import url(...)` it replaces.
        //
        // The two preconnects warm up the TLS handshake to Google's CDN
        // before the stylesheet href is fetched — saves ~80–200ms on
        // first paint depending on the user's connection.
        // -----------------------------------------------------------------
        link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
        link(
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''},
        ),
        link(
          rel: 'stylesheet',
          href:
              'https://fonts.googleapis.com/css2'
              '?family=Inter:wght@400;500;600;700'
              '&family=JetBrains+Mono:wght@400;500;600'
              '&display=swap',
        ),

        // -----------------------------------------------------------------
        // Canonical URL
        // -----------------------------------------------------------------
        link(rel: 'canonical', href: _siteUrl),

        // -----------------------------------------------------------------
        // Open Graph (Facebook / LinkedIn / generic link previews)
        // -----------------------------------------------------------------
        meta(attributes: {'property': 'og:type', 'content': 'website'}),
        meta(attributes: {'property': 'og:site_name', 'content': _siteTitle}),
        meta(attributes: {'property': 'og:title', 'content': _siteTitle}),
        meta(attributes: {'property': 'og:description', 'content': _siteDescription}),
        meta(attributes: {'property': 'og:url', 'content': _siteUrl}),
        meta(attributes: {'property': 'og:image', 'content': '$_siteUrl$_ogImage'}),
        meta(attributes: {'property': 'og:image:width', 'content': '1200'}),
        meta(attributes: {'property': 'og:image:height', 'content': '630'}),
        meta(attributes: {'property': 'og:locale', 'content': 'en_US'}),

        // -----------------------------------------------------------------
        // Twitter / X card
        // -----------------------------------------------------------------
        meta(name: 'twitter:card', content: 'summary_large_image'),
        meta(name: 'twitter:title', content: _siteTitle),
        meta(name: 'twitter:description', content: _siteDescription),
        meta(name: 'twitter:image', content: '$_siteUrl$_ogImage'),

        // -----------------------------------------------------------------
        // Theme bootstrap — MUST run before paint to avoid FOUC.
        // No `defer`/`async` so the browser blocks first paint until this
        // tiny IIFE has set data-theme on <html>.
        // -----------------------------------------------------------------
        script(content: _themeBootstrapScript),

        // -----------------------------------------------------------------
        // Animation scripts — IntersectionObserver, typewriter, ScrollSpy,
        // 3D tilt, custom cursor. `defer` so it doesn't block parsing.
        // -----------------------------------------------------------------
        script(defer: true, content: animationScripts),
      ],
      body: const App(),
    ),
  );
}
