# Define the path to the PowerShell profile
$profilePath = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"

# Define the lines we want to add
$linesToAdd = @(
    '. $Env:USERPROFILE\.env\inc\git-aliases.ps1',
    '. $Env:USERPROFILE\.env\inc\prompt.ps1'
)

function Add-LineIfNotExists {
    param (
        [string]$FilePath,
        [string]$Line
    )

    if (-not (Test-Path $FilePath)) {
        New-Item -Path $FilePath -ItemType File -Force | Out-Null
        Write-Host "Created new profile file: $FilePath"
    }

    $content = Get-Content $FilePath -ErrorAction SilentlyContinue

    if ($content -notcontains $Line) {
        Add-Content -Path $FilePath -Value $Line
        Write-Host "Added line to profile: $Line"
    }
    else {
        Write-Host "Line already exists in profile: $Line"
    }
}

function Patch-Profile {
    Write-Host "Patching PowerShell profile..."
    foreach ($line in $linesToAdd) {
        Add-LineIfNotExists -FilePath $profilePath -Line $line
    }
    Write-Host "Profile patching complete."
}

function Print-Usage {
    Write-Host "Usage: .\ManagePowerShellProfile.ps1 [patch]"
    Write-Host "  patch: Patch the PowerShell profile"
    Write-Host "  If no argument is provided, patch will be executed by default."
}

# Main script execution
if ($args.Count -eq 0) {
    Patch-Profile
}
else {
    switch ($args[0].ToLower()) {
        "patch" {
            Patch-Profile
        }
        "-h" {
            Print-Usage
        }
        "--help" {
            Print-Usage
        }
        "--usage" {
            Print-Usage
        }
        default {
            Write-Host "Invalid argument. Use -h or --help for usage information."
        }
    }
}
