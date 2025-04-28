import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) async {
  // Create an ArgParser to handle command-line arguments
  final parser = ArgParser()
    ..addOption(
        'template',
        abbr: 't',
        allowed: ['mvc', 'mvc_getx', 'clean'],
        mandatory: true,
        help: 'The template to use for the project (mvc, mvc_getx, clean)'
    );

  // Parse the arguments
  final argResults = parser.parse(arguments);

  // The first argument (rest) should be the project name
  if (argResults.rest.isEmpty) {
    print('❌ Error: Missing required argument "project_name".');
    print('Usage: flutter_starter create <project_name> --template <mvc|mvc_getx|clean>');
    exit(1);
  }

  final projectName = argResults.rest[0];  // The first positional argument
  final template = argResults['template'] as String;

  print('🎯 Creating Flutter project: $projectName with $template template');

  // Create the Flutter project using `flutter create`
  final result = await Process.run(
      'C:/Users/manos/Downloads/flutter/bin/flutter', // Absolute Flutter path
      ['create', projectName]
  );

  if (result.exitCode != 0) {
    print('❌ Failed to create Flutter project: ${result.stderr}');
    exit(1);
  }

  print('✅ Flutter project created.');

  // Now add architecture folders based on template
  final projectDir = Directory(projectName);

  switch (template) {
    case 'mvc':
      await setupMVC(projectDir);
      break;
    case 'mvc_getx':
      await setupMVCGetX(projectDir);
      break;
    case 'clean':
      await setupCleanArchitecture(projectDir);
      break;
    default:
      print('❌ Invalid template choice.');
      print('Usage: flutter_starter create <project_name> --template <mvc|mvc_getx|clean>');
      exit(1);
  }

  print('🎉 Project "$projectName" is ready!');
}

Future<void> setupMVC(Directory projectDir) async {
  print('📦 Setting up MVC structure...');
  final libDir = Directory('${projectDir.path}/lib');
  await _createFolder(libDir, ['models', 'views', 'controllers']);
}

Future<void> setupMVCGetX(Directory projectDir) async {
  print('📦 Setting up MVC + GetX structure...');
  final libDir = Directory('${projectDir.path}/lib');
  await _createFolder(libDir, ['models', 'views', 'controllers', 'bindings']);
}

Future<void> setupCleanArchitecture(Directory projectDir) async {
  print('📦 Setting up Clean Architecture structure...');
  final libDir = Directory('${projectDir.path}/lib');
  await _createFolder(libDir, ['core', 'features', 'data', 'domain', 'presentation']);
}

Future<void> _createFolder(Directory base, List<String> folders) async {
  for (final folder in folders) {
    final dir = Directory('${base.path}/$folder');
    await dir.create(recursive: true);
    print('  📁 Created ${dir.path}');
  }
}
