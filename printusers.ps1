# Read the content of theUsers.txt and admins.txt files
$UsersFile = "C:\Final_Scripts\theUsers.txt"
$AdminsFile = "C:\Final_Scripts\admin.txt"

$Users = Get-Content $UsersFile
$Admins = Get-Content $AdminsFile

# Get current users and admins on the computer
$currentUsers = Get-LocalUser | Select-Object -ExpandProperty Name
$currentAdmins = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name

# Check users
foreach ($user in $currentUsers) {
    if ($Users -contains $user) {
        Write-Host "$user is good"
    } elseif ($Admins -contains $user) {
        Write-Host "$user is an admin but should be a user"
    } else {
        Write-Host "Remove $user"
    }
}

# Check admins
foreach ($admin in $currentAdmins) {
    if ($Admins -contains $admin) {
        Write-Host "$admin is good"
    } elseif ($Users -contains $admin) {
        Write-Host "$admin is a user but should be an admin"
    }
}
