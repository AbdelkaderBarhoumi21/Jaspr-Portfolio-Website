/// The entrypoint for the **server** environment.
///
/// The [main] method only runs on the server during pre-rendering (static
/// mode). For browser-side code see `main.client.dart`.
library;

import 'package:jaspr/server.dart';

import 'app.dart';
// Importing `global_styles.dart` (even just for its side effect of having
// the `@css` annotation) ensures the Jaspr builder includes those rules
// in the generated stylesheet.
import 'core/theme/global_styles.dart';
// Generated file — do not edit.
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  // Touch the global styles getter so the import is never tree-shaken.
  // (Cheap — runs once at server startup.)
  // ignore: unused_local_variable
  final _ = globalStyles;

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
      body: const App(),
    ),
  );
}
