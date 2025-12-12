plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.targetku"
    
    // WAJIB 34 untuk fix error flutter_local_notifications
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Menggunakan Java 8 standar untuk kompatibilitas maksimal
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.targetku"
        
        // Min SDK 21 diperlukan oleh flutter_local_notifications
        minSdk = flutter.minSdkVersion 
        // Target SDK disamakan dengan Compile SDK
        targetSdk = 35
        
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Mencegah error jika method count melebihi batas
        multiDexEnabled = true 
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Library untuk support fitur Java terbaru di Android lama
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
