import 'package:mason/mason.dart';
import 'dart:io';

void run(HookContext context) async {
  final done = context.logger.progress('Running flutter pub get');
  final result = await Process.run(
    'flutter',
    [
      'pub',
      'get',
    ],
    runInShell: true,
  );
  done();
  exit(result.exitCode);
}
