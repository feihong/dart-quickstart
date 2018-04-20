# Feihong's Dart Quickstart

## Prerequisites

    brew tap dart-lang/dart
    brew install dart

Source: https://www.dartlang.org/tools/sdk#install

## Running a program

    dart server.dart

## Compile snapshot for production

    dart --snapshot=server.dart.snapshot server.dart

Source: https://github.com/dart-lang/sdk/wiki/Snapshots

## Deploy to production

Make sure you've [compiled the standalone executable for your production platform](https://github.com/feihong/dockerfiles/tree/master/centos-7-dart) and upload the generated `dart` file to your server (e.g. place it in ~/bin).

- Generate a snapshot
- Upload the snapshot to your server (e.g. ~/webapps/dart-quickstart)
- Run `dart myapp.dart.snapshot`

## Links

- [Language Tour](https://www.dartlang.org/guides/language/language-tour)
- [Awesome Dart](https://github.com/yissachar/awesome-dart)
