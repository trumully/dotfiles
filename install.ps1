Set-StrictMode -Version Latest

# Install WinGet
$hasWinget = Get-Command winget -ErrorAction SilentlyContinue
if (-not $hasWinget) {
    Write-Host "Installing WinGet" 
    Invoke-WebRequest -Uri https://aka.ms/getwinget -Outfile winget.msixbundle
    Add-AppxPackage winget.msixbundle
    del winget.msixbundle
}

$hasPs7 = Get-Command pwsh -ErrorAction SilentlyContinue
if (-not $hasPs7) {
    Write-Host "Installing PowerShell 7"
    winget add -e --id Microsoft.PowerShell
}

$hasGit = Get-Command git -ErrorAction SilentlyContinue
if (-not $hasGit) {
    Write-Host "Installing Git"
    winget add -e --id Git.Git
}

$hasChezmoi = Get-Command chezmoi -ErrorAction SilentlyContinue
if (-not $hasChezmoi) {
    Write-Host "Installing chezmoi"
    winget add -e --id twpayne.chezmoi
}


chezmoi init https://github.com/trumully/dotfiles.git