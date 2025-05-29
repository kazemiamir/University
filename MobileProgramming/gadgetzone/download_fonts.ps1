$baseUrl = "https://github.com/rastikerdar/vazirmatn/raw/master/fonts/ttf"
$fonts = @(
    "Vazirmatn-Regular.ttf",
    "Vazirmatn-Bold.ttf",
    "Vazirmatn-Light.ttf",
    "Vazirmatn-Medium.ttf"
)

$outputPath = "assets/fonts"

foreach ($font in $fonts) {
    $url = "$baseUrl/$font"
    $output = "$outputPath/$font"
    
    Write-Host "Downloading $font..."
    
    try {
        Invoke-WebRequest -Uri $url -OutFile $output
        Write-Host "Successfully downloaded $font"
    }
    catch {
        Write-Host "Failed to download $font: $_"
    }
}

# Rename files to match pubspec.yaml configuration
Get-ChildItem $outputPath -Filter "Vazirmatn-*.ttf" | ForEach-Object {
    $newName = $_.Name -replace "Vazirmatn-", "Vazir-"
    Rename-Item $_.FullName -NewName $newName
    Write-Host "Renamed $($_.Name) to $newName"
} 