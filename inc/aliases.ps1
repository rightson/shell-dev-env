# Alias to create a Python virtual environment
function Create-PythonVenv {
    param(
        [string]$VenvName = "venv"
    )
    python -m venv $VenvName
    Write-Host "Virtual environment '$VenvName' created successfully."
}
Set-Alias -Name venv.create -Value Create-PythonVenv

# Alias to activate a Python virtual environment
function Activate-PythonVenv {
    param(
        [string]$VenvName = "venv"
    )
    $activatePath = Join-Path $VenvName "Scripts\Activate.ps1"
    if (Test-Path $activatePath) {
        & $activatePath
        Write-Host "Virtual environment '$VenvName' activated."
    } else {
        Write-Host "Virtual environment '$VenvName' not found. Please create it first using venv.create."
    }
}
Set-Alias -Name venv.activate -Value Activate-PythonVenv
