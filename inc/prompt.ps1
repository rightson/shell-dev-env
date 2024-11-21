function prompt {
    $username = $env:USERNAME
    $hostname = $env:COMPUTERNAME
    $time = Get-Date -Format "HH:mm:ss"
    $date = Get-Date -Format "yyyy-MM-dd"
    $shell = "PowerShell"

    # Get the current location
    $currentLocation = Get-Location

    # Get the drive root
    $driveRoot = $currentLocation.Drive.Root

    # Create a relative path
    $relativePath = $currentLocation.Path.Substring($driveRoot.Length)
    if ($relativePath -eq "") {
        $relativePath = "\"
    }

    # Set the window title
    $host.UI.RawUI.WindowTitle = "PowerShell - $username@$hostname : $currentLocation"

    # Build the prompt string with colors
    $promptString = ""
    $promptString += Write-Host "$username" -ForegroundColor Red -NoNewline
    $promptString += Write-Host "@" -ForegroundColor Blue -NoNewline
    $promptString += Write-Host "$hostname" -ForegroundColor Green -NoNewline
    #$promptString += Write-Host ":$relativePath" -ForegroundColor Yellow -NoNewline
    $promptString += Write-Host ":$currentLocation" -ForegroundColor Yellow -NoNewline
    $promptString += Write-Host " [$date $time]" -ForegroundColor Magenta -NoNewline
    # $promptString += Write-Host " ($shell)" -ForegroundColor Blue -NoNewline
    $promptString += Write-Host "`n$" -NoNewline

    return " "
}
