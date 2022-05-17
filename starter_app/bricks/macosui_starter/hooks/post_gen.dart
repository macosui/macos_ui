import 'package:mason/mason.dart';
import 'dart:io';

void run(HookContext context) async {
  final pubGet = context.logger.progress('Running flutter pub get');
  
  final pubGetResult = await Process.run(
    'flutter',
    [
      'pub',
      'get',
    ],
    runInShell: true,
  );
  pubGet();
  if (pubGetResult.exitCode != 0) {
    context.logger.err('flutter pub get failed');
    exit(pubGetResult.exitCode);
  }

  final flutterFormat = context.logger.progress('Running flutter format');
  final flutterFormatResult = await Process.run(
    'flutter',
    [
      'format',
      '.',
    ],
    runInShell: true,
  );
  flutterFormat();
  if (flutterFormatResult.exitCode != 0) {
    context.logger.err('flutter format failed');
    exit(flutterFormatResult.exitCode);
  }

  exit(flutterFormatResult.exitCode);
}
