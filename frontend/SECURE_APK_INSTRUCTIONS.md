# Building the Secure School Management APK

This guide provides step-by-step instructions for building a secure APK with the péče logo that prevents code theft and protects the application from reverse engineering.

## Prerequisites

- Flutter SDK installed and in your PATH
- Java Development Kit (JDK) 8 or higher
- Android SDK with build tools
- A physical Android device or emulator for testing

## Step 1: Prepare the Signing Key

1. Open a command prompt/terminal
2. Navigate to the project root directory
3. Run the following command to generate a keystore:

```bash
keytool -genkey -v -keystore school_management.keystore -alias school_management -keyalg RSA -keysize 2048 -validity 10000
```

4. When prompted, enter a secure password and your organization details
5. Move the generated `school_management.keystore` file to the `android` directory of the project
6. Edit the `android/key.properties` file to include your keystore information:

```
storePassword=yourStorePassword
keyPassword=yourKeyPassword
keyAlias=school_management
storeFile=../school_management.keystore
```

## Step 2: Build the Secure APK

### Using the Build Script (Recommended)

1. Simply run the `build_secure_apk.bat` file located in the project root
2. Wait for the build process to complete
3. The secured APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

### Manual Build

If you prefer to build manually, run the following commands:

```bash
flutter clean
flutter pub get
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

## Step 3: Verify the APK

To verify that your APK is properly signed and secure:

1. Install the APK on a test device
2. Check that the péče logo appears correctly
3. Verify all functionality works as expected
4. Optionally, attempt to decompile the APK using tools like JADX or APKTool to verify obfuscation

## Security Features Implemented

This APK includes the following security measures:

1. **Code Obfuscation**: Using ProGuard with aggressive rules
2. **Resource Shrinking**: Removing unused resources
3. **Class Repackaging**: Making the code structure difficult to understand
4. **Anti-Tampering**: Preventing modification of the application
5. **Secure Signing**: Using a strong RSA key for verification
6. **Native Code Protection**: Shielding native libraries from extraction

## Troubleshooting

If you encounter issues:

1. Ensure Flutter is properly installed and in your PATH
2. Verify that the keystore file is in the correct location
3. Check that the key.properties file contains the correct information
4. Make sure you're using a compatible version of the JDK
5. If the build fails with ProGuard errors, check the `proguard-rules.pro` file

## Additional Notes

- Keep your keystore file and passwords secure - losing them means you can't update your app
- The custom péče logo is implemented as a vector drawable for optimal scaling on all devices
- This APK requires Android 5.0 (API level 21) or higher due to security features

For more detailed information about Flutter's security features, refer to the official documentation: https://flutter.dev/docs/deployment/android 