#Install-Module -Name MSOnline
try{Connect-MsolService}
catch{Write-Host "If MsolService is not already installed, install with 'Install-Module -Name MSOnline'"}
$Tenants = Get-MsolPartnerContract #Get list of tenant IDs

foreach($Tenant in $Tenants) #for each Tenant in the list of Tenants
{
    $ADSync = Get-MsolGroup -TenantId $Tenant.TenantId -SearchString "Azure AD Sync" #Get Security Group called AD Azure Sync
    $Users = Get-MsolUser -TenantId $Tenant.TenantId #Get list of Users
    $Lusers = foreach($User in $Users){ if($User.isLicensed -eq "True"){Get-MsolUser -TenantId $Tenant.TenantId -UserPrincipalName $User.UserPrincipalName}}#Get list of Licensed Users
    $NoAdd = Get-MsolGroupMember -GroupObjectId $ADSync.ObjectId -TenantId $Tenant.TenantId #List of Users already in the Azure AD Sync
    $NewUsers = $Lusers.UserPrincipalName | Where {$NoAdd.EmailAddress -notcontains $_}#List of Licensed Users not already in Azure AD Sync
    if($null -eq $NewUsers){Continue}
    Write-Host "----------------------------------------"
    Write-Host -BackgroundColor Yellow -ForegroundColor Black $Tenant.DefaultDomainName
    Write-Host "----------------------------------------"
    $NewUseObj = foreach($NewUser in $NewUsers) { Get-MsolUser -TenantId $Tenant.TenantId -SearchString $NewUser}#Use the strings to find the related Object and covert to it for proccessing
    $i = 0
    foreach($NewUse in $NewUseObj) { Add-MsolGroupMember -GroupMemberObjectId $NewUse.ObjectId.Guid -GroupObjectId $ADSync.ObjectId -TenantId $Tenant.TenantId; Write-Host "Added" $NewUse.DisplayName "to" $ADSync.DisplayName "in" $Tenant.DefaultDomainName; $i++}#Add the New Users
    Write-Host $i "New Users added to" $Tenant.DefaultDomainName
}