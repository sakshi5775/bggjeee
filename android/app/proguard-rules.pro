############################
# Flutter Core
############################
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

############################
# Kotlin / Coroutines
############################
-keep class kotlin.** { *; }
-dontwarn kotlin.**

############################
# Google ML Kit
############################
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

############################
# Firebase
############################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

############################
# OneSignal
############################
-keep class com.onesignal.** { *; }
-dontwarn com.onesignal.**

############################
# Camera / Media / Audio
############################
-keep class androidx.camera.** { *; }
-dontwarn androidx.camera.**

-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

############################
# Agora RTC
############################
-keep class io.agora.** { *; }
-dontwarn io.agora.**

############################
# Razorpay
############################
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

############################
# Syncfusion Charts / PDF
############################
-keep class com.syncfusion.** { *; }
-dontwarn com.syncfusion.**

############################
# HTTP / Networking
############################
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

############################
# Socket IO
############################
-keep class io.socket.** { *; }
-dontwarn io.socket.**

############################
# Permissions
############################
-keep class com.github.kornilova_l.permission_handler.** { *; }

############################
# Flutter Downloader
############################
-keep class vn.hunghd.flutterdownloader.** { *; }

############################
# Geolocator
############################
-keep class com.baseflow.geolocator.** { *; }

############################
# Sensors
############################
-keep class dev.fluttercommunity.plus.sensors.** { *; }

############################
# Text To Speech / Speech To Text
############################
-keep class com.google.android.tts.** { *; }
-dontwarn com.google.android.tts.**

############################
# Window Manager (your existing rules)
############################
-dontwarn androidx.window.extensions.WindowExtensions
-dontwarn androidx.window.extensions.WindowExtensionsProvider
-dontwarn androidx.window.extensions.area.ExtensionWindowAreaPresentation
-dontwarn androidx.window.extensions.layout.DisplayFeature
-dontwarn androidx.window.extensions.layout.FoldingFeature
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent
-dontwarn androidx.window.extensions.layout.WindowLayoutInfo
-dontwarn androidx.window.sidecar.SidecarDeviceState
-dontwarn androidx.window.sidecar.SidecarDisplayFeature
-dontwarn androidx.window.sidecar.SidecarInterface$SidecarCallback
-dontwarn androidx.window.sidecar.SidecarInterface
-dontwarn androidx.window.sidecar.SidecarProvider
-dontwarn androidx.window.sidecar.SidecarWindowLayoutInfo

############################
# Prevent stripping of Flutter plugins registrant
############################
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

############################
# App package (VERY IMPORTANT)
############################
-keep class com.astrobharatai.astrouser.** { *; }

############################
# General Safe
############################
-dontwarn org.conscrypt.**
-dontwarn org.apache.commons.logging.**
