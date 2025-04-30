# fpc

`fpc` is a simple Dart CLI tool that helps you delete the `build` folders from your Flutter projects, even if they are nested. This tool is useful for cleaning up your disk space and making sure you don't have unnecessary build files lying around in your project directories.

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
   git clone https://github.com/your-username/fpc.git
   ```

## Usage

To run the fpc CLI tool, use the following command in your terminal:

```bash
dart run bin/fpc.dart <path_to_your_flutter_projects> [--force]

<path_to_your_flutter_projects>: The path to your Flutter projects directory where you want to search for build folders.

--force: Use this flag to force the deletion without any confirmation prompts.
```



## Example

To clean the build folders from all Flutter projects located in C:/Users/yourname/FlutterProjects, run:

``` bash 
dart run bin/fpc.dart C:/Users/yourname/FlutterProjects --force
```

If you don't use the --force flag, the tool will ask for your confirmation before deleting any files.
How It Works

 The tool will recursively search for any build folder inside the specified path.

 Once it finds the build directories, it will delete them and show the progress.

 After deleting, it will show the amount of disk space that was freed.

## Activate the Package Globally 

If your project is located at C:\Users\yourname\StudioProjects\fpc, open your terminal and run:

``` bash 
dart pub global activate --source path C:\yourname\StudioProjects\fpc
```


This command activates the package globally from the specified local path.


**To run fpc from any location in your terminal, ensure that Dart's pub cache bin directory is in your system's PATH.**

**✅ Step 1: Add Dart's Pub Cache to Your System PATH**


For Windows, the pub cache bin directory is typically located at:

``` %LOCALAPPDATA%\Pub\Cache\bin ```

**To add this directory to your PATH:**

Press Win + R, type sysdm.cpl, and press Enter.

 In the System Properties window, go to the Advanced tab and click on Environment Variables.

 Under System variables, find and select the Path variable, then click Edit.

 Click New and add the path:

 %LOCALAPPDATA%\Pub\Cache\bin

 Click OK on all open dialogs to apply the changes.

After updating the PATH, you might need to restart your terminal or computer for the changes to take effect._


**✅ Step 2: Verify the Installation**

To confirm that fpc is installed and accessible globally, open a new terminal window and run:

``` bash
  fpc --help 
  ```

  **Or**

  ``` bash
     where fpc
```

**If it shows something like:**

``` C:\Users\YourUserName\AppData\Local\Pub\Cache\bin\fpc.bat ```

**Then you're good to go!**



## License

This project is open source and available under the MIT License.
Contributing

If you'd like to contribute to fpc, please fork the repository and submit a pull request. You can also report bugs or suggest improvements via issues on the GitHub repository.