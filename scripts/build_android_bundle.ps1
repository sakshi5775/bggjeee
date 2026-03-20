# Optimized Android Build Script (PowerShell)
# Builds an App Bundle (AAB) for Play Store Submission
# Auto-bumps version in pubspec.yaml and minAppVersion in app_constant.dart before building.

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Android Optimized Build Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Auto-bump version (version name + build number + minAppVersion)
Write-Host "Bumping version (pubspec + app_constant)..." -ForegroundColor Yellow
& (Join-Path $ScriptDir "bump_version.ps1")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Push-Location $RepoRoot | Out-Null

# Clean
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean
cd android
./gradlew clean
cd ..

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build App Bundle (uses your preferred split-debug-info path)
Write-Host "Building Android App Bundle..." -ForegroundColor Yellow
flutter build appbundle --release --obfuscate --split-debug-info=build/symbols --tree-shake-icons

Write-Host "=========================================" -ForegroundColor Green
Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "Output: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
Write-Host "=========================================" -ForegroundColor Green
Write-Host "NOTE: Upload this .aab file to Play Store." -ForegroundColor Cyan
Write-Host "Do NOT use the .apk file for submission." -ForegroundColor Cyan

Pop-Location | Out-Null
