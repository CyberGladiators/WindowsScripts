# Set the registry key path for the Group Policy settings
$regKeyPath = "HKLM:\SOFTWARE\Policies\Microsoft"

# Set the values for the specified settings
$settings = @{
    "Control Panel\RegionalLanguage" = @{
        "UILanguage" = "en-US"
        "Override" = 0
    }
    "User Accounts" = @{
        "LogonPicture" = 1
    }
}

# Apply the settings
foreach ($settingPath in $settings.Keys) {
    foreach ($setting in $settings[$settingPath].Keys) {
        $fullPath = Join-Path -Path $regKeyPath -ChildPath $settingPath
        $valueName = $setting
        $valueData = $settings[$settingPath][$setting]
        
        # Create registry key if it doesn't exist
        if (-not (Test-Path $fullPath)) {
            New-Item -Path $fullPath -Force
        }

        # Set registry value
        Set-ItemProperty -Path $fullPath -Name $valueName -Value $valueData
    }
}

Write-Host "Group Policy settings applied successfully."
