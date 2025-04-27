import 'dart:io';

void main(List<String> arguments) async {
  final args = _parseArguments(arguments);

  if (args['help'] == true) {
    _printHelp();
    exit(0);
  }

  final directory = args['directory'] ?? Directory.current;
  final bool dryRun = args['dryRun'] ?? false;
  final bool force = args['force'] ?? false;

  print('🔍 Searching for build folders inside: ${directory.path}');
  final buildDirs = await _findBuildFolders(directory);

  if (buildDirs.isEmpty) {
    print('✅ No build folders found.');
    return;
  }

  print('⚡ Found ${buildDirs.length} build folder(s).');

  if (!dryRun && !force) {
    stdout.write('❓ Are you sure you want to delete them? (y/n): ');
    final confirmation = stdin.readLineSync();
    if (confirmation?.toLowerCase() != 'y') {
      print('❌ Cancelled.');
      return;
    }
  }

  for (var dir in buildDirs) {
    if (dryRun) {
      print('📝 Would delete: ${dir.path}');
    } else {
      try {
        await dir.delete(recursive: true);
        print('🗑️ Deleted: ${dir.path}');
      } catch (e) {
        print('⚠️ Failed to delete ${dir.path}: $e');
      }
    }
  }

  if (dryRun) {
    print('✅ Dry run completed. No folders were deleted.');
  } else {
    print('✅ Cleanup completed.');
  }
}

Map<String, dynamic> _parseArguments(List<String> arguments) {
  final Map<String, dynamic> result = {
    'dryRun': false,
    'force': false,
    'help': false,
    'directory': null,
  };

  for (var arg in arguments) {
    if (arg == '--dry-run') {
      result['dryRun'] = true;
    } else if (arg == '--force') {
      result['force'] = true;
    } else if (arg == '--help' || arg == '-h') {
      result['help'] = true;
    } else {
      result['directory'] = Directory(arg);
    }
  }
  return result;
}

void _printHelp() {
  print('''
🛠️  Clean Build Folders CLI

Usage:
  dart run clean_builds.dart [directory] [options]

Options:
  --dry-run   Show what would be deleted, but don't delete anything.
  --force     Delete without asking for confirmation.
  --help, -h  Show this help message.

Examples:
  dart run clean_builds.dart ~/Projects
  dart run clean_builds.dart ~/Projects --dry-run
  dart run clean_builds.dart --force
''');
}

Future<List<Directory>> _findBuildFolders(Directory root) async {
  List<Directory> buildDirs = [];
  await for (var entity in root.list(recursive: true, followLinks: false)) {
    if (entity is Directory && entity.path.endsWith('${Platform.pathSeparator}build')) {
      buildDirs.add(entity);
    }
  }
  return buildDirs;
}
