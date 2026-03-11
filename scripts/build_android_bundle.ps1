# Optimized Android Build Script (PowerShell)
# Builds an App Bundle (AAB) for Play Store Submission
# Auto-bumps version name (patch) + version code and updates minAppVersion before build.

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Android Optimized Build Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Bump version (version name + code) and regenerate minAppVersion for upgrader
Write-Host "Bumping version and minAppVersion..." -ForegroundColor Yellow
dart run scripts/bump_version.dart

# Clean
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
cd android
./gradlew clean
cd ..

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build App Bundle
Write-Host "Building Android App Bundle..." -ForegroundColor Yellow
flutter build appbundle --release --obfuscate --split-debug-info=./debug_info --tree-shake-icons

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "Output: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Green
Write-Host "NOTE: Upload this .aab file to Play Store." -ForegroundColor Cyan
Write-Host "Do NOT use the .apk file for submission." -ForegroundColor Cyan
