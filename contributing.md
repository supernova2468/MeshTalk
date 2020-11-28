# MeshTalk

## Setup

Easiest way to build and run this is to use visual studio code and a dev container from  the Remote - Containers extension.

1. Install VSCode
2. Install Docker Desktop
3. Install Remote - Containers Extension
4. Clone the repo
---
**NOTE**
This is a very resource and file intensive container. If you are using the WSL2 backend for docker it is recommended to clone it onto the wsl2 filesystem.
---
5. Open the cloned repo in VSCode
6. Run one of the "open in container" commands in VSCode

Then to connect to an AVD

1. Install Android Studio locally (doesn't seem to be a way to get just the AVD manager)
2. Use AVD Manager to make sure a virtual android is running.
3. When running in the dev container run the below command to connect it to the avd

```bash
adb connect host.docker.internal
```