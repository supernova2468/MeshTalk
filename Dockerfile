FROM ubuntu:20.04

# base os utils
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    curl \
    git \
    file \
    unzip \
    xz-utils \
    zip \
    wget \
    ca-certificates \
    openjdk-8-jdk

# flutter
ENV PATH="/flutter/bin:/android/cmdline-tools/latest/bin:/android/platform-tools:${PATH}"
ENV ANDROID_SDK_ROOT="/android"
ENV ANDROID_HOME="/android"
ENV ANDROID_SDK_TOOLS_VERSION="6858069"
RUN mkdir /tmp/fluttersetup \
    && wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.4-stable.tar.xz -P /tmp/fluttersetup \
    && tar xf /tmp/fluttersetup/flutter_linux_1.22.4-stable.tar.xz -C / \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip -P /tmp/fluttersetup \
    && mkdir -p /android/cmdline-tools/latest \
    && unzip /tmp/fluttersetup/commandlinetools-linux-6858069_latest.zip -d /tmp/fluttersetup \
    && mv /tmp/fluttersetup/cmdline-tools/* /android/cmdline-tools/latest \
    && rm -rf /tmp/fluttersetup \
    && yes | sdkmanager --licenses \
    && sdkmanager platform-tools \
    && sdkmanager emulator \
    && sdkmanager "build-tools;30.0.2" \
    && sdkmanager "patcher;v4" \
    && sdkmanager "platforms;android-30" \
    && sdkmanager "sources;android-30" \ 
    && sdkmanager "platforms;android-29" \
    && sdkmanager "sources;android-29" \ 
    && sdkmanager "build-tools;29.0.3" \    
    && flutter doctor \
    && flutter precache 