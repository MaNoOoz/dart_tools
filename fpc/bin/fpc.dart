import 'dart:io';
import 'package:args/args.dart';
import 'package:yaml/yaml.dart';

Future<String?> getPackageVersion() async {
  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    final content = await pubspecFile.readAsString();
    final doc = loadYaml(content);
    return doc['version'];
  }
  return null;
}

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('force', abbr: 'f', negatable: false, help: 'Force delete without asking.')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage help.')
    ..addFlag('version', abbr: 'v', negatable: false, help: 'Show the current version.');

  final argResults = parser.parse(arguments);

  if (argResults['version'] as bool) {
    print('📦 FPC version 0.0.1');
    return;
  }

  if (argResults['help'] as bool) {
    print('''
📦 FPC - Flutter Project Cleaner

Usage:
  fpc "<your/path>" [--force]

Options:
  -f, --force     Force delete build/ folders without confirmation
  -h, --help      Show this help message
  -v, --version   Show the current version
  
Example:
  fpc "C:/Projects" --force
''');
    return;
  }
  if (argResults['version'] as bool) {
    final version = await getPackageVersion() ?? 'unknown';
    print('📦 FPC version $version');
    return;
  }

  if (argResults.rest.isEmpty) {
    print('❗ Usage: fpc "your/path" --force');
    print('Use "fpc --help" for more information.');
    exit(1);
  }

  final inputPath = argResults.rest[0];
  final forceDelete = argResults['force'] as bool;

  final normalizedPath = normalizePath(inputPath);
  final rootDir = Directory(normalizedPath);

  if (!await rootDir.exists()) {
    print('❗ Directory does not exist: $normalizedPath');
    exit(1);
  }

  print('🔎 Searching Flutter projects inside: $normalizedPath');
  print('--------------------------------------------------------');

  int totalFreedBytes = 0;
  final projects = await findFlutterProjects(rootDir);

  if (projects.isEmpty) {
    print('❗ No Flutter projects found.');
    exit(0);
  }

  for (final project in projects) {
    print('📁 Project: ${project.path}');
    final flutterVersion = await getFlutterVersion(project.path);
    if (flutterVersion != null) {
      print('🛠 Flutter version: ${color(flutterVersion, AnsiColor.blue)}');
    } else {
      print('⚠️ Could not detect Flutter version.');
    }

    final buildDir = Directory('${project.path}/build');

    if (await buildDir.exists()) {
      final sizeBefore = await getFolderSize(buildDir);

      if (!forceDelete) {
        stdout.write('❓ Delete build/ folder? (y/n): ');
        final response = stdin.readLineSync();
        if (response?.toLowerCase() != 'y') {
          print('⏩ Skipped.');
          continue;
        }
      }

      try {
        await buildDir.delete(recursive: true);
        totalFreedBytes += sizeBefore;
        print('✅ ${color("Deleted build/ folder", AnsiColor.green)}. Freed ${(sizeBefore / (1024 * 1024)).toStringAsFixed(2)} MB.');
      } catch (e) {
        print('❗ ${color("Failed to delete build/ folder", AnsiColor.red)}: $e');
      }
    } else {
      print('ℹ️ No build/ folder found.');
    }

    print('--------------------------------------------------------');
  }


  print('\n🎉 Done! ${color("Total space freed: ${(totalFreedBytes / (1024 * 1024)).toStringAsFixed(2)} MB", AnsiColor.green)}');
}

/// Normalize slashes and remove extra quotes
String normalizePath(String path) {
  path = path.replaceAll('"', '').replaceAll("'", '');
  return path.replaceAll('\\', '/');
}

/// Find Flutter projects by looking for pubspec.yaml
Future<List<Directory>> findFlutterProjects(Directory root) async {
  final projects = <Directory>[];

  await for (var entity in root.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('pubspec.yaml')) {
      projects.add(entity.parent);
    }
  }
  return projects;
}

/// Read the Flutter SDK version from .metadata
Future<String?> getFlutterVersion(String projectPath) async {
  final metadataFile = File('$projectPath/.metadata');
  if (await metadataFile.exists()) {
    final content = await metadataFile.readAsString();
    final match = RegExp(r'version:\s*(.+)').firstMatch(content);
    if (match != null) {
      return match.group(1);
    }
  }
  return null;
}

/// Calculate the total size of a folder
Future<int> getFolderSize(Directory dir) async {
  int size = 0;
  if (await dir.exists()) {
    await for (var entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        size += await entity.length();
      }
    }
  }
  return size;
}

/// Add colors
enum AnsiColor { red, green, yellow, blue }

String color(String text, AnsiColor color) {
  final colorCodes = {
    AnsiColor.red: '\x1B[31m',
    AnsiColor.green: '\x1B[32m',
    AnsiColor.yellow: '\x1B[33m',
    AnsiColor.blue: '\x1B[34m',
  };
  return '${colorCodes[color]}$text\x1B[0m';
}
