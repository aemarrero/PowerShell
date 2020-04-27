Connect-Msolservice

$Tenants = Get-MsolPartnerContract #Get list of tenant IDs

foreach($Tenant in $Tenants) #for each Tenant in the list of Tenants
{
    $ADSync = New-MsolGroup -TenantId $Tenant.TenantId -DisplayName "AD Azure Sync" #Make new Security Group called AD Azure Sync
    $Users = Get-MsolUser -TenantId $Tenant.TenantId #Get list of Users
    $i = 0#iterator
    foreach($User in $Users) #For each User in list of Users
    {
        if($User.isLicensed -eq "True") #if User is Licensed
        {
            Add-MsolGroupMember -GroupMemberObjectId $User.ObjectId.Guid -GroupObjectId $ADSync.ObjectId -TenantId $Tenant.TenantId#Add User to Group
            $i++ #Iterate if Group Member added
        }
    }
    Write-Host $ADSync.ObjectId.Guid "" $Tenant.DefaultDomainName "" $i #Print GroupId, DomainName, and number of Users added to Group
}