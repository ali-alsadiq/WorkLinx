# WorkLix

Welcome to WorkLix, an iOS app that simplifies workspace management.

## Features

* **User Authentication:** Sign in with email/password or Google.
* **Workspace Management:** Create, organize workspaces; invite others.
* **Invitations:** Accept/reject workspace invites.
* **Admin Capabilities:** Manage shifts, positions, pay rates, workspace.
* **Availability Setup:** Set weekly availability.
* **Time-off & Reimbursement:** Request, upload images.
* **Admin Approval:** Review, approve/reject requests.
* **Firebase Integration:** Authentication, Firestore, Storage.
* **Google Address Validation API:** Ensure valid addresses.

## Getting Started

1. **Clone the Repository:**
```
git clone https://github.com/ali-alsadiq/WorkLinx.git
```

3. **Install Required Pods:**

```
cd WorkLix
```

```
pod install
```


4. **Configure Firebase and Google Cloud:**
   - **Create a New [Firebase](https://console.firebase.google.com/) Project and Enable Services:**
     - **Authentication:** Email/Password, Google sign-in.
     - **Firestore**
     - **Storage** 
   - **Add Your iOS App to Firebase:**
     - Use your Xcode project's bundle identifier in Firebase settings (found in project file under "General" tab).
     - Download `GoogleService-Info.plist`, add to Xcode.
     - In `GoogleService-Info.plist`, copy `REVERSED_CLIENT_ID`.
     - In Xcode, Project settings -> Info -> URL Types, paste `REVERSED_CLIENT_ID` into URL Schemes.
   - **Access Google Cloud Console:**
     - [Google Cloud Console](https://console.cloud.google.com/).
     - Log in, go to your Firebase project.
     - API & Services -> Library, enable Address Validation API.

5. **Build and Run the App:**
   Open the project in Xcode, build, and run the app on a simulator or device.

## Requirements

- iOS 16.4+
- Xcode 14.0+
- Swift 5.0+

## Meet the Team

- Ali Alsadiq - [@ali-alsadiq](https://github.com/ali-alsadiq)
- Alex Wang - [@wza2479110](https://github.com/wza2479110)

## Contributing

Contributions to WorkLix are welcome! Report bugs or suggest improvements through issues or pull requests.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

Efficient Workspace Management with WorkLix! 📊📅
