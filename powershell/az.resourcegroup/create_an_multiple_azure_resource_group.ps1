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
You can also import a large list of resource groups from a CSV file.
Example:
[System.Object]$new_resource_groups = Get-Content "<your_csv_path>" -Force | ConvertFrom-Csv
#>
[System.Object]$new_resource_groups = @(
    [PSCustomObject]@{Name = "<your_resource-group-name>"; location = "westeurope" },
    [PSCustomObject]@{Name = "<your_resource-group-name>"; location = "northeurope" },
    [PSCustomObject]@{Name = "<your_resource-group-name>"; location = "eastus" }
)

#Set Subscription
try {
    $null = Select-AzSubscription -Subscription $subscription_id -Force
}
catch {
    Write-Error "[ERROR] Failed to Set subscription -> $($subscription_id) | Error Message - $($ERROR[0].Exception.Message.Trim())"
}

#Create a multiple azure resource group
$counter = 0
:for foreach ($resource_group in $new_resource_groups) {
    try {
        $counter++
        Write-Output "$('-'*60)"
        Write-Output "[INFO] Creating New Resource group -> $($resource_group.Name) | $($counter) of $(($new_resource_groups | Measure-Object).Count)"
        $null = New-AzResourceGroup -Name $resource_group.Name -Location  $resource_group.location -Force
        Write-Output "           -> Created."
    }
    catch {
        Write-Error "           -> [ERROR] Failed to Create an azure resource group -> $($resource_group.Name) | Error Message - $($ERROR[0].Exception.Message.Trim())"
    }
}