# Sync minAppVersion in app_constant.dart from current pubspec.yaml version (without bumping).
# Use when you've already updated pubspec version and only need to sync minAppVersion.
# Run from repo root or scripts folder.

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
if (-not $scriptDir) { $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
$repoRoot = Resolve-Path (Join-Path $scriptDir "..")
$pubspecPath = Join-Path $repoRoot "pubspec.yaml"
$appConstantPath = Join-Path $repoRoot "lib\utils\app_constant.dart"

if (-not (Test-Path $pubspecPath)) {
    Write-Host "ERROR: pubspec.yaml not found at $pubspecPath" -ForegroundColor Red
    exit 1
}

$content = Get-Content $pubspecPath -Raw
if ($content -notmatch "(?m)^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$") {
    Write-Host "ERROR: Could not find version line (expected format: version: 1.0.1+59)" -ForegroundColor Red
    exit 1
}

$versionName = "$($Matches[1]).$($Matches[2]).$($Matches[3])"
Write-Host "Version name from pubspec: $versionName" -ForegroundColor Cyan

if (Test-Path $appConstantPath) {
    $dartContent = Get-Content $appConstantPath -Raw
    $dartContent = $dartContent -replace "(minAppVersion\s*=\s*)'[\d.]+'", "`$1'$versionName'"
    Set-Content -Path $appConstantPath -Value $dartContent.TrimEnd() -NoNewline
    Write-Host "minAppVersion set to '$versionName' in app_constant.dart" -ForegroundColor Green
} else {
    Write-Host "WARN: app_constant.dart not found at $appConstantPath" -ForegroundColor Yellow
}

Write-Host "Sync done." -ForegroundColor Green
