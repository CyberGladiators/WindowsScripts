# Define the security policy settings
$settings = @{
    "PasswordHistorySize" = 8
    "MaximumPasswordAge" = 14
    "MinimumPasswordAge" = 8
    "MinimumPasswordLength" = 8
    "PasswordComplexity" = 1  # 1 to enable, 0 to disable
    "ClearTextPassword" = 0  # 0 to disable, 1 to enable
}

# Configure the security policy settings
$settings.GetEnumerator() | ForEach-Object {
    $name = $_.Key
    $value = $_.Value
    Write-Host "Setting $name to $value"
    secedit /configure /db secedit.sdb /cfg null.inf /areas SECURITYPOLICY /enforcepolicy /log "$env:temp\secedit.log" /quiet
    $existingPolicy = (secedit /export /cfg null.inf /areas SECURITYPOLICY /log "$env:temp\secedit.log" /quiet | ConvertFrom-Csv).Settings
    $existingPolicy[$name] = $value
    $existingPolicy.GetEnumerator() | ForEach-Object {
        $name = $_.Key
        $value = $_.Value
        secedit /configure /db secedit.sdb /cfg null.inf /areas SECURITYPOLICY /enforcepolicy /log "$env:temp\secedit.log" /quiet
    }
}

Write-Host "Security policy settings updated."

# Delete the temporary secedit files
Remove-Item "$env:temp\secedit.log" -Force
Remove-Item "secedit.sdb" -Force
