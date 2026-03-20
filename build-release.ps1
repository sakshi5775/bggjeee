# One command to build Android release AAB for Play Store.
# - Auto-bumps version (pubspec + minAppVersion)
# - Cleans, gets deps, builds appbundle with obfuscate + split-debug-info + tree-shake-icons
# Run from repo root: .\build-release.ps1

$ErrorActionPreference = "Stop"
$scriptPath = Join-Path $PSScriptRoot "scripts\build_android_bundle.ps1"
if (-not (Test-Path $scriptPath)) {
    Write-Host "ERROR: scripts\build_android_bundle.ps1 not found. Run from repo root." -ForegroundColor Red
    exit 1
}
& $scriptPath
exit $LASTEXITCODE
