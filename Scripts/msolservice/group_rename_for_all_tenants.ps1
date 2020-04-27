$Tenants = Get-MsolPartnerContract #Get list of tenant IDs

foreach($Tenant in $Tenants) #for each Tenant in the list of Tenants
{
    $GroupToRename = Get-MsolGroup -TenantId $Tenant.TenantId -SearchString "AD Azure Sync" #Get Security Group called AD Azure Sync
    Set-MsolGroup -TenantId $Tenant.TenantId -ObjectId $GroupToRename.ObjectId -DisplayName "Azure AD Sync"
    Write-Host $Tenant.Name
}