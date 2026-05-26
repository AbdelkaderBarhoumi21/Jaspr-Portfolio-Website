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
// Generated file — do not edit.
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  // Touch the style getters so the imports are never tree-shaken.
  // (Cheap — runs once at server startup.)
  // ignore: unused_local_variable
  final _ = [globalStyles, animationStyles];

  runApp(
    Document(
      title: 'Abdelkader Barhoumi — Mobile Software Engineer',
      lang: 'en',
      meta: const {
        'description':
            'Portfolio of Barhoumi Abdelkader — Mobile Software Engineer building '
            'high-performance Flutter & Android apps with clean architecture.',
        'author': 'Barhoumi Abdelkader',
        'theme-color': '#080810',
      },
      head: const [
        // Vanilla-JS bundle: IntersectionObserver reveals, typewriter,
        // navbar scroll behavior, ScrollSpy, 3D tilt, custom cursor.
        // `defer` so it doesn't block parsing — the script itself also
        // waits for DOMContentLoaded as a belt + suspenders.
        script(defer: true, content: animationScripts),
      ],
      body: const App(),
    ),
  );
}
