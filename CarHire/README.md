# Q-FOUR_AurizonAR
AR Car Hire iPad app for Aurizon.

## Requirements
* For iOS 13+ (built with SwiftUI).
* Built in XCode 11.6 (functional in XCode 12).

## How to Install
1. unzip AurizonApplication.
2. open terminal and run *sudo gem install cocoapods*.
3. run cd *{filepath}/AurizonApplication*.
4. run *pod install*.
5. open AurizonApplication.xcworkspace.
6. you can now successfully build the app! (after setting up apple developer provisioning profile).

## Implementation Notes
Below is a list of features implemented and their respective location in the source code.

### Registration Scan
* Feature scans vehicle number plates and retrieves information from integrated database in real-time.
* Registration scan feature allows users to interact dynamically with the data. Cars already hired will be scannable but not hireable by separate accounts.
* *Registration scan code can be found /Views/ARView.swift*.

### Registration Search
* Feature provides users with ability to search for vehicle registration manually for purposes of hiring or return.
* *Registration search source code can be found /Views/HireView.swift*

### Availability List
* Feature allows users to see list of available cars and hire or return them dynamically depending on current user's hire status.
* *Availability list source code can be found in /Views/HireListView.Swift*.
* *Individual availability list rows which are called by availability list found in /Views/ListRow.swift*

### Profile/Settings
* Functionality to allow users to modify application accessibility settings.
  * Users can change text to large-size mode if required.
  * Users may change theme from "dark mode" to "light mode".
* Profile page shows users list of all currently hired vehicles.
* *Profile page source code can be found /Views/ProfileSettingsView.swift*

### Tutorial
* Feature includes app-wide interactive tutorial showcasing and explaining the key features of the applicataion.
* *Tutorial source code can be found in /Views/TutorialView.swift*
* *Tutorial overlay popups are found in their respective view (ie. vehicle scanning popups can be found in /Views/ARView.swift*
* *Animations and additional navigation features in tutorial can be found in /Utilities/CustomerWidgets.swift*

## Future releases 
* Implement search bar functionality in availability list. Beginning of this has been implemented but has been commented out as not fully-functional.
* Permissions for different user roles may be a useful future iteration.
* Find-my-car feature allowing users to find their reserved vehicle using telemetry data may be a useful future iteration.
* Phone number on hire overlay can open directly into phone/text application to allow easy contact between Aurizon staff.
* Profile should include return button for currently hired vehicles so that they may be returned directly from within profile screen.

## Data
* Data is stored on [Firebase Console](https://firebase.google.com/). Firebase requires a Gmail login. Credentials will be activated by Q-Four Team.
