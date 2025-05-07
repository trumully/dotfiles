$ErrorActionPreference = "Stop"

$PSVersion = $PSVersionTable.PSVersion
Write-Output "PSVersion=${PSVersion}, PSModulePath=${env:PSModulePath}"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

Write-Output "Install/update Microsoft.PowerShell.PSResourceGet"
Install-Module -Name "Microsoft.PowerShell.PSResourceGet" -Scope CurrentUser -Repository PSGallery -Force

if (Get-Command Get-PSRepository -ErrorAction SilentlyContinue) {
    if (-not ((Get-PSRepository -Name "PSGallery" -ErrorAction SilentlyContinue).InstallationPolicy -eq "Trusted")) {
        Write-Output "Trust PSGallery for PowerShellGet"
        Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    }
}

# Trust PSGallery for PSResourceGet
if (-not ((Get-PSResourceRepository -Name "PSGallery" -ErrorAction SilentlyContinue).Trusted)) {
    Write-Output "Trust PSGallery for PSResourceGet"
    Set-PSResourceRepository -Name "PSGallery" -Trusted
}


$requiredResources = @{
    "PSReadLine" = @{
        Version = '[2.3.6,)'
        Repository = 'PSGallery'
    }
    "ProfileAsync" = @{
        Version = '[0.4.2,)'
        Repository = 'PSGallery'
    }
}

foreach ($item in $requiredResources.GetEnumerator()) {
    $name = $item.Key
    $version = $item.Value.Version
    $params = $item.Value

    # Check if the package is already installed with the required version
    $r = Get-InstalledPSResource -Name $name -Version $version -Scope CurrentUser -ErrorAction SilentlyContinue
    if (-not $r) {
        Write-Output "Installing $name version $version..."
        Install-PSResource -Name $name -Scope CurrentUser @params -Reinstall
    } else {
        $currentVersion = $r.Version
        Write-Output "$name version=$version currentVersion=$currentVersion - is already installed. Skipping..."
    }
}