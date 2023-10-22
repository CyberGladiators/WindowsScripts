# Prompt for user choice
$choice = Read-Host "Enter '0' for setup or '1' for printing users"

if ($choice -eq "0") {
    # Ctrl-Alt-Delete
    reg ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v DisableCAD /t REG_DWORD /d 0 /f
    
    # Firewall settings
    netsh advfirewall set allprofiles state on
    Write-Host "Firewall enabled"
    Write-Host "Setting basic firewall rules..."
    netsh advfirewall firewall set rule name="Remote Assistance (DCOM-In)" new enable=no 
    netsh advfirewall firewall set rule name="Remote Assistance (PNRP-In)" new enable=no 
    netsh advfirewall firewall set rule name="Remote Assistance (RA Server TCP-In)" new enable=no 
    netsh advfirewall firewall set rule name="Remote Assistance (SSDP TCP-In)" new enable=no 
    netsh advfirewall firewall set rule name="Remote Assistance (SSDP UDP-In)" new enable=no 
    netsh advfirewall firewall set rule name="Remote Assistance (TCP-In)" new enable=no 
    netsh advfirewall firewall set rule name="Telnet Server" new enable=no 
    netsh advfirewall firewall set rule name="netcat" new enable=no
    Write-Host "Set basic firewall rules."
    # Disable Remote Assistance
    $registryPath = "HKLM:\System\CurrentControlSet\Control\Remote Assistance"
    $registryName = "fAllowToGetHelp"
    $registryValue = 0

    # Set registry value
    
    Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue

    Write-Host "Remote Assistance connections disabled."

    # Stop the FTP service
    Stop-Service -Name "ftpsvc" -Force

    # Set the FTP service startup type to Disabled
    Set-Service -Name "ftpsvc" -StartupType Disabled

    Write-Host "FTP service disabled."

    # Set the URL for the latest Firefox installer
    $firefoxInstallerUrl = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"

    # Set the path where you want to save the installer
    $installerPath = "C:\Final_Scripts\FirefoxInstaller.exe"

    # Check if Firefox is already installed
    if (Test-Path "C:\Program Files\Mozilla Firefox\firefox.exe") {
        Write-Host "Firefox is already installed."
    } 
    else {
        # Download the latest Firefox installer
        Invoke-WebRequest -Uri $firefoxInstallerUrl -OutFile $installerPath

        # Wait for the download to complete
        Start-Sleep -Seconds 5

        # Install Firefox
        Start-Process -Wait -FilePath $installerPath

        # Clean up - Remove the installer
        Remove-Item -Path $installerPath

        Write-Host "Firefox has been installed."
    }

    # Execute additional scripts
    .\bat.bat
    .\secure.bat
    .\ez.ps1
    .\Dns.ps1

    # Check the exit code of the scripts
    if ($?) {
        Write-Host "Setup scripts executed successfully."
    } else {
        Write-Host "Error executing setup scripts."
    }
}

if ($choice -eq "1") {
    .\printusers.ps1
}
