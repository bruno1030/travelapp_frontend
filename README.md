# travelapp_frontend

A new Flutter project.

## ##############################

Command to run the application:

flutter run

## ##############################

Comand to run directly in Google Chrome:

flutter run -d chrome

## ##############################

Comands to run directly in iPhone emulator:

On macOs search, search for Simulator

Open it

Go to VSCode

flutter devices

flutter run -d < ID of the iphone device >

## ##############################

How to run directly in Android emulator:

Open Android Studio

"Tools” > “Device Manager”.

“Create Device”.

Choose an device option (Pixel 7 for example)

Download system image (usually its the latest Android version).
If it's already downloaded, no need to download again, only in case its necessary to download the image of another device.

Start the emulator via Android Studio

After the emulator is open:

- go to VS code
- open the terminal
- run "flutter devices"

It must show:

Chrome (web)
iPhone 15 Simulator
Pixel_6_API_34 (android)

Then run:

flutter run -d < id_of_android_device >

Example: 
flutter run -d emulator-5554

## ##############################

Hot Reload in local environment:

Hot Reload (r ou Ctrl/Cmd + r): for small changes on widgets and

Hot Restart (Shift + r): For more deep changes, like modifications on global variables or on state management

## ##############################

How to add new translated messages (for internationalization):

- maintain the folder lib/generated, but remove all the files inside it:
... app_localizations_en.dart
... app_localizations_ja.dart
... app_localizations_pt.dart
... app_localizations_zh.dart
... app_localizations.dart


- add the new messages to all languages files:
... app_en.arb
... app_ja.arb
... app_pt.arb
... app_zh.arb

- run "flutter gen-l10n"

- ensure that the files were generated again in lib/generated folder:
... app_localizations_en.dart
... app_localizations_ja.dart
... app_localizations_pt.dart
... app_localizations_zh.dart
... app_localizations.dart

- apply the internalization on the required field using the same kind of implementation that is done for other fields, using AppLocations.of, for exemple what us done for the "about us" field:

String aboutUs = AppLocalizations.of(context)?.about_us ?? 'About us..';
PopupMenuItem<String>(
          value: 'about',
          child: Text(aboutUs),
        ),

In the exemplo above, the value after ?? is the fallback.

## ##############################

Command to execute after adding new dependencies to pubspec.yaml:

flutter pub get

## ##############################

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
