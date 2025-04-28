# dr_cleaner

`dr_cleaner` is a simple Dart CLI tool that helps you delete the `build` folders from your Flutter projects, even if they are nested. This tool is useful for cleaning up your disk space and making sure you don't have unnecessary build files lying around in your project directories.

## Features
- **Recursive Deletion**: It searches for and deletes all `build` directories, even within nested folders.
- **Progress Display**: Shows the progress while cleaning up the `build` directories.
- **Disk Space Saved**: Prints how much disk space was freed after the deletion.

## Requirements
- **Dart SDK**: Make sure you have the Dart SDK installed on your system.
- **Flutter**: Since the tool deals with Flutter projects, you need to have Flutter installed as well.

## Installation

1. Clone the repository to your local machine.

   ```bash
   git clone https://github.com/your-username/dr_cleaner.git
   ```

## Usage

To run the dr_cleaner CLI tool, use the following command in your terminal:

```bash
dart run bin/dr_cleaner.dart <path_to_your_flutter_projects> [--force]
```
    <path_to_your_flutter_projects>: The path to your Flutter projects directory where you want to search for build folders.

    --force: Use this flag to force the deletion without any confirmation prompts.

## Example

To clean the build folders from all Flutter projects located in C:/Users/yourname/FlutterProjects, run:

dart run bin/dr_cleaner.dart C:/Users/yourname/FlutterProjects --force

If you don't use the --force flag, the tool will ask for your confirmation before deleting any files.
How It Works

    The tool will recursively search for any build folder inside the specified path.

    Once it finds the build directories, it will delete them and show the progress.

    After deleting, it will show the amount of disk space that was freed.

## License

This project is open source and available under the MIT License.
Contributing

If you'd like to contribute to dr_cleaner, please fork the repository and submit a pull request. You can also report bugs or suggest improvements via issues on the GitHub repository.