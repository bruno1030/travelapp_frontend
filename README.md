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

flutter devices

flutter run -d < ID of the device >

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

Examples: 
flutter run -d emulator-5554 (for pixel 7)
or
flutter run -d emulator-5556 (for pixel 4)

## ##############################

Hot Reload in local environment:

Hot Reload (r ou Ctrl/Cmd + r): for small changes on widgets and

Hot Restart (Shift + r): For more deep changes, like modifications on global variables or on state management

## ##############################

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
