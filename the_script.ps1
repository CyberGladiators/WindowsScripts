# Read service configurations from the "the_services.txt" file
$serviceConfigurations = Get-Content -Path "the_services.txt"

# Loop through each service configuration
foreach ($config in $serviceConfigurations) {
    # Split the configuration into parts (assuming format is "ServiceName:StartupType")
    $serviceName, $startupType = $config -split ':'

    # Trim whitespace from the service name and startup type
    $serviceName = $serviceName.Trim()
    $startupType = $startupType.Trim()

    # Check if the service name and startup type are not empty
    if ($serviceName -ne "" -and $startupType -ne "") {
        # Try to stop the service if the startup type is "Disabled"
        if ($startupType -eq "Disabled") {
            try {
                Stop-Service -Name $serviceName -Force
                Write-Host "Stopped service $serviceName"
            }
            catch {
                Write-Host "Failed to stop service $serviceName"
                Write-Host $_.Exception.Message
            }
        }

        # Try to set the startup type of the service
        try {
            Set-Service -Name $serviceName -StartupType $startupType
            Write-Host "Changed startup type of service $serviceName to $startupType"
        }
        catch {
            Write-Host "Failed to change startup type of service $serviceName"
            Write-Host $_.Exception.Message
        }
    }
    else {
        Write-Host "Invalid service configuration: $config"
    }
}
