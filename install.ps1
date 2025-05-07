$hasWinget = Get-Command winget -ErrorAction SilentlyContinue
if (-not $hasWinget) {
    Write-Host "Installing WinGet" 
    Invoke-WebRequest -Uri https://aka.ms/getwinget -Outfile winget.msixbundle
    Add-AppxPackage winget.msixbundle
    del winget.msixbundle
}

$hasChezmoi = Get-Command chezmoi -ErrorAction SilentlyContinue
if (-not $hasChezmoi) {
    Write-Host "Installing chezmoi"
    winget add -e --id twpayne.chezmoi
}

chezmoi init trumully -a