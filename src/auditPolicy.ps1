$auditCategories = @(
    'Logon/Logoff',
    'Object Access',
    'Privilege Use',
    'Detailed Tracking',
    'Policy Change',
    'Account Management',
    'DS Access',
    'Account Logon'
)

foreach ($category in $auditCategories) {
    auditpol /set /category:$category /success:enable /failure:enable
}
