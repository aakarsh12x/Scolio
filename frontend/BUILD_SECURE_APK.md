# Building a Secure School Management APK

This document outlines the process for building a secure, encrypted APK that prevents code theft and protects sensitive data.

## Prerequisites

- Flutter SDK installed
- Android Studio with SDK tools
- Java Development Kit (JDK) 8 or higher
- Signing key for the release build

## Security Features Implemented

This build includes the following security measures:

1. **Code Obfuscation**: Using ProGuard with a custom dictionary to make the code unreadable
2. **Resource Shrinking**: Removing unused resources
3. **APK Encryption**: Implementing strong encryption for APK contents
4. **Anti-Tampering**: Preventing modification of the application
5. **Safe Area Support**: Proper handling of notches and modern device displays
6. **Secure Data Storage**: Using AndroidX Security library for encrypted data
7. **Native Code Protection**: Protecting native libraries from extraction

## Setting Up Signing Keys

1. Create a key store for signing your APK:

```bash
keytool -genkey -v -keystore school_management.keystore -alias school_management -keyalg RSA -keysize 2048 -validity 10000
```

2. Create a `key.properties` file in the `android/` directory:

```
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=school_management
storeFile=<path-to-keystore-file>
```

## Building the Secure APK

Run the following command to build a secure release APK:

```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

For App Bundle (preferred for Play Store):

```bash
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info
```

## Verification Steps

After building, verify the security of your APK:

1. Check that the APK is properly signed:

```bash
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

2. Test on a device to ensure all features work correctly

3. Attempt to decompile the APK using tools like JADX or APKTool to verify obfuscation

## Additional Security Considerations

- Regularly update dependencies to address security vulnerabilities
- Implement proper authentication and authorization in the app
- Use secure network communications (HTTPS) for all API calls
- Implement certificate pinning for network requests
- Don't store sensitive data in SharedPreferences without encryption
- Implement proper session management

## Troubleshooting

If you encounter issues with the secure build:

1. Check ProGuard rules if certain features don't work
2. Ensure the signing configuration is correct
3. Verify that all required security libraries are imported

## Note on Encryption

While these measures provide strong protection, no security is absolute. Regularly review and update your security measures to address new threats. 