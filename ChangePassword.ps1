# Specify the path to the "users.txt" file
$userListFile = "C:\Scripts\users.txt"

# Specify the new password
$newPassword = "CyberGlads@1"

# Read the list of usernames from the "users.txt" file
$usernames = Get-Content -Path $userListFile

# Loop through each username and change the password
foreach ($username in $usernames) {
    # Trim whitespace and validate username
    $username = $username.Trim()
    if ($username -ne "") {
        try {
            # Set the new password for the user
            Set-LocalUser -Name $username -Password (ConvertTo-SecureString -AsPlainText $newPassword -Force)
            Write-Host "Password changed successfully for user: $username"
        }
        catch {
            Write-Host "Failed to change password for user: $username"
            Write-Host $_.Exception.Message
        }
    }
}

Write-Host "Password changes complete."
