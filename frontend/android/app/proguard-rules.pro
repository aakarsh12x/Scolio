# Flutter specific ProGuard rules
-keepattributes *Annotation*
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }

# Keep GetX library
-keep class com.getkeepsafe.relinker.** { *; }
-keep class get.** { *; }

# Keep any native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Dart VM entry point
-keep class io.flutter.app.FlutterApplication {
    <init>();
    void attachRootViewIfNeeded();
}

# Avoid R8 optimization for better compatibility
-dontwarn io.flutter.embedding.**
-dontwarn androidx.**

# Keep serialization libraries
-keepattributes Signature
-keepattributes *Annotation*

# Avoid obfuscation of Flutter classes
-keep class com.google.android.material.** { *; }
-keep class androidx.** { *; }

# Keep constructors of model classes
-keepclassmembers class * {
    <init>(...);
}

# Keep enum values for Dart and JSON serialization
-keepclassmembers enum * { 
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Ignore missing classes
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn javax.annotation.**
-dontwarn org.xmlpull.v1.**
-dontwarn com.android.installreferrer.api.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.firebase.**
-dontwarn org.joda.time.**
-dontwarn com.google.android.play.core.**
-dontwarn com.google.crypto.tink.**

# Keep R classes
-keep class **.R
-keep class **.R$* {
    <fields>;
}

# Basic Android Components
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.view.View

# Keep the BuildConfig
-keep class *.BuildConfig { *; }

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep customized components
-keep class com.example.school_management.** { *; } 