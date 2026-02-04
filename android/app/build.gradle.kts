import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {

    namespace = "com.astrobharatai.astrouser"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.astrobharatai.astrouser"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Enable resource shrinking and code shrinking
        resourceConfigurations += listOf("en", "hi") // Only include languages you need
    }

    signingConfigs {
        if (keystorePropertiesFile.exists() && keystoreProperties.containsKey("keyAlias")) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            if (keystorePropertiesFile.exists() && keystoreProperties.containsKey("keyAlias")) {
                signingConfig = signingConfigs.getByName("release")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Enable code shrinking and optimization
            isDebuggable = false
        }
    }

    // Bundle configuration to optimize app bundle size
    // Note: splits.abi is removed because it conflicts with bundle builds
    // When building bundles, use bundle.abi.enableSplit instead
    bundle {
        language {
            // Enable language splitting to reduce base module size
            // Languages will be downloaded on-demand by Play Store
            enableSplit = true
        }
        density {
            // Enable density splitting for app bundles (Play Store handles this automatically)
            enableSplit = true
        }
        abi {
            // Enable ABI splitting for app bundles to reduce size per architecture
            enableSplit = true
        }
    }

    // Additional resource optimization
    packaging {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/ASL2.0",
                "META-INF/*.kotlin_module",
                "META-INF/versions/**",
                "**/attach_hotspot_windows.dll",
                "META-INF/licenses/**",
                "META-INF/AL2.0",
                "META-INF/LGPL2.1"
            )
            // Compress resources to reduce size
            pickFirsts += setOf(
                "**/libc++_shared.so",
                "**/libfbjni.so"
            )
        }
    }
}

flutter {
    source = "../.."
}
