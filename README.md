# How to Run _Scribbles_!

## Prerequisites
In order to run our application you must have the following installed on your computer:
1. Flutter SDK
2. XCode
3. CocoaPods
4. Visual Studio Code

## Running
### Step 1 — Cloning the project.
Clone our project on your computer.
### Step 2 — Opening the Xcode Simulator.
Open the Xcode Simulator _Xcode > Open Developer Tool > Simulator_. You may need to install a "Platform" if you haven't ran the Xcode Simulator previously. You can do this by going to _Xcode > Settings > Platforms_ and installing the latest version of iOS.
### Step 3 — Opening Visual Studio Code.
Open Visual Studio Code and load the directory where our project is located.
### Step 4 — Installing the necessary dependencies.
Using the terminal within Visual Studio Code, and by accessing the directory where our project is located, run _flutter pub get_. This will automatically download all necessary dependencies to run our project on your machine.
### Step 5 — Running the application.
Using the terminal within Visual Studio Code, and by accessing the directory where our project is located, run _flutter run_. This will display our project on the Xcode Simulator you opened previously. If this doesn't work you can also try to run the application manually by selecting _Run > Run Without Degugging_ within Visual Studio Code.
### Notes
- If you run into any issues, try clearing the project's cache by running _flutter clean_ on the Terminal and repeating Steps 4 and 5.
- If you need further clarification on how to run our project you can read this [article](https://docs.flutter.dev/get-started/install/macos/mobile-ios) which helped us when starting out.
