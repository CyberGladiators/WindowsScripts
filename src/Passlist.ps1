# Import required modules
Import-Module Microsoft.PowerShell.LocalAccounts

# Initialize an empty array to hold results
$results = @()

# Get all local user accounts
$users = Get-LocalUser

# Loop through each user account to gather details
foreach ($user in $users) {
    $result = New-Object PSObject -Property @{
        "Username"             = $user.Name
        "AccountEnabled"       = $user.Enabled
        "PasswordChangeable"   = $user.PasswordChangeableDate
        "PasswordExpires"      = $user.PasswordExpires
        "LastPasswordSet"      = $user.LastPasswordSet
        "PasswordLength"       = "Unknown"  # Windows does not expose this information for security reasons
        "PasswordRequired"     = $null
    }

    # Check if the user account has password required
    try {
        $account = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity([System.DirectoryServices.AccountManagement.ContextType]::Machine, $user.Name)
        if ($account.PasswordNeverExpires) {
            $result.PasswordRequired = $false
        } else {
            $result.PasswordRequired = $true
        }
    } catch {
        $result.PasswordRequired = "Error"
    }

    # Add this result to the results array
    $results += $result
}

# Display the results in a table
$results | Select-Object Username, AccountEnabled, PasswordRequired, PasswordChangeable, PasswordExpires, LastPasswordSet, PasswordLength | Format-Table -AutoSize
