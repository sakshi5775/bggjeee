# Script to find unused assets
$assetsList = Get-Content "assets_list.txt"
$unusedAssets = @()
$usedAssets = @()

foreach ($asset in $assetsList) {
    if ([string]::IsNullOrWhiteSpace($asset)) { continue }
    
    # Extract just the filename
    $fileName = Split-Path $asset -Leaf
    $fileNameWithoutExt = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    
    # Search for the asset in Dart files
    $found = $false
    
    # Search for full path
    $result1 = Select-String -Path "lib\**\*.dart" -Pattern ([regex]::Escape($asset.Replace('\', '/'))) -ErrorAction SilentlyContinue
    if ($result1) { $found = $true }
    
    # Search for just filename
    $result2 = Select-String -Path "lib\**\*.dart" -Pattern ([regex]::Escape($fileName)) -ErrorAction SilentlyContinue
    if ($result2) { $found = $true }
    
    # Search for filename without extension
    $result3 = Select-String -Path "lib\**\*.dart" -Pattern ([regex]::Escape($fileNameWithoutExt)) -ErrorAction SilentlyContinue
    if ($result3) { $found = $true }
    
    # Check pubspec.yaml
    $result4 = Select-String -Path "pubspec.yaml" -Pattern ([regex]::Escape($asset.Replace('\', '/'))) -ErrorAction SilentlyContinue
    if ($result4) { $found = $true }
    
    if ($found) {
        $usedAssets += $asset
        Write-Host "USED: $asset" -ForegroundColor Green
    } else {
        $unusedAssets += $asset
        Write-Host "UNUSED: $asset" -ForegroundColor Red
    }
}

# Write unused assets to file
$unusedAssets | Out-File -FilePath "unused_assets.txt" -Encoding utf8
Write-Host "`nTotal assets: $($assetsList.Count)"
Write-Host "Used assets: $($usedAssets.Count)"
Write-Host "Unused assets: $($unusedAssets.Count)"
Write-Host "`nUnused assets list saved to unused_assets.txt"
