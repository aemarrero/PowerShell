# MSOLSERVICE
These Scripts were originally written to solve the issue of new users not being added to the Azure AD Sync groups after they were initially created through the Office 365 portal.
In order to run these, you will need to make sure you have the MsolServices module installed. 
Run: 'Install-Module -Name MSOnline' in your PowerShell teminal to accomplish this.

initial_ad_resync and ad_resync.ps1 bith have Connect-MsolService as their first lines so they should just prompt you to login to your Microsoft account and run.

# group_rename_for_all_tenants.ps1
This script is pretty self explanatory and not explicitly part of this process but was used to work around the fact that distribution lists had already been created using the name that ultimately would be used for the security group when all was said and done. So a temporary name was used and this script was run after all the original distribution lists were deleted through the portal because the MsolServices module can only interact with security groups not distribution lists. 

This is a fairly straight forward one to repurpose. In line 5, after the '-SerachString' parameter in the quotes put the Name of the Group that requires a name change. In line 6, after the '-DisplayName' parameter in the quotes put the new name desired. 

Friendly Reminder Again: MsolServices can only interact with Security Groups not Distribution Lists!
