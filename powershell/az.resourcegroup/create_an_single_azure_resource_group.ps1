<#
This script checks for Az module version 12.4.0.
If it's not installed, it installs the correct version
for the current user from the PowerShell Gallery.

$null = Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
$null = Install-Module -Name Az -RequiredVersion 12.4.0 -Scope CurrentUser -Force
#>

#Variables
$resource_group_name = "<your_resource-group-name>"
$location = "westeurope"
$subscription_id = "<your_subscription-id>"

#Set Subscription
try {
    $null = Select-AzSubscription -Subscription $subscription_id -Force
}
catch {
    Write-Error "[ERROR] Failed to Set subscription -> $($subscription_id) | Error Message - $($ERROR[0].Exception.Message.Trim())"
}

#Create an azure resource group
try {
    Write-Output "[INFO] Creating New Resource group -> $($resource_group_name)"
    $null = New-AzResourceGroup -Name $resource_group_name -Location  $location -Force
    Write-Output "           -> Created."
}
catch {
    Write-Error "           -> [ERROR] Failed to Create an azure resource group -> $($resource_group_name) | Error Message - $($ERROR[0].Exception.Message.Trim())"
}