# MeshTalk

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Building and Running Locally

### Setup
Easiest way to build and run this is to use visual studio code and a dev container from  the Remote - Containers extension.

1. Install VSCode
2. Install Docker Desktop
3. Install Remote - Containers Extension
4. Clone the repo
5. Open the cloned repo in VSCode
6. Run one of the "open in container" commands in VSCode

This sets up a container and installs all the dependencies.

Then to connect to an AVD

1. Install Android Studio locally (doesn't seem to be a way to get just the AVD manager)
2. Use AVD Manager to make sure a virtual android is running.
3. When running in the dev container run the below command to connect it to the avd

```bash
adb connect host.docker.internal
```

### Flutter Development
Finally you can kick of the flutter development command

```bash
flutter run
```

From here you should look at the flutter documentation.

### Notes
* This is a very resource and file intensive container. If you are using windows with the WSL2 backend for docker it is recommended to clone it onto the wsl2 filesystem.