<#
This script checks for Az module version 12.4.0.
If it's not installed, it installs the correct version
for the current user from the PowerShell Gallery.

$null = Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
$null = Install-Module -Name Az -RequiredVersion 12.4.0 -Scope CurrentUser -Force
#>

#Variables
$subscription_id = "<your_subscription-id>"
<#
Get a Resource Group infomation from CSV File
#>
[System.Object]$new_resource_groups = (Get-Content ".\data\resourceGroups.csv" -Force | ConvertFrom-Csv)

#Set Subscription
try {
    $null = Select-AzSubscription -Subscription $subscription_id -Force
}
catch {
    Write-Error "[ERROR] Failed to Set subscription -> $($subscription_id) | Error Message - $($ERROR[0].Exception.Message.Trim())"
}


#Update a multiple azure resource group
$counter = 0
[System.Object]$new_Tags = @{Department = "IT" }
:for foreach ($resource_group in $new_resource_groups) {
    try {
        $counter++
        Write-Output "$('-'*60)"
        Write-Output "[INFO] Updating New Resource group -> $($resource_group.Name) | $($counter) of $(($new_resource_groups | Measure-Object).Count)"
        $null = Set-AzResourceGroup -Name $resource_group.Name -Location  $resource_group.location -Tag $new_Tags -Force
        Write-Output "           -> Updated."
    }
    catch {
        Write-Error "           -> [ERROR] Failed to Update an azure resource group -> $($resource_group.Name) | Error Message - $($ERROR[0].Exception.Message.Trim())"
    }
}

#remove a multiple azure resource group
$counter = 0
:for foreach ($resource_group in $new_resource_groups) {
    try {
        $counter++
        Write-Output "$('-'*60)"
        Write-Output "[INFO] Removing New Resource group -> $($resource_group.Name) | $($counter) of $(($new_resource_groups | Measure-Object).Count)"
        $null = Remove-AzResourceGroup -Name $resource_group.Name -Location  $resource_group.location -Force
        Write-Output "           -> Removed."
    }
    catch {
        Write-Error "           -> [ERROR] Failed to Remove an azure resource group -> $($resource_group.Name) | Error Message - $($ERROR[0].Exception.Message.Trim())"
    }
}