function Get-Forest {
    $strRemoteForest = Read-Host -Prompt 'Enter Remote Forest (Enter nothing to default to corp.cloud.axoncs.com)'
    If ($strRemoteForest -eq '') {
        $strRemoteForest = 'corp.cloud.axoncs.com'
    }
    return  $strRemoteForest
    }
function Get-User {
    $strRemoteUser = Read-Host -Prompt 'Enter Remote User (Enter nothing to default to administrator)'
        If ($strRemoteUser -eq '') {
            $strRemoteUser = 'administrator'
        }
        return $strRemoteUser
    }
function Get-Password {
    $strRemotePassword = Read-Host -AsSecureString  -ErrorAction SilentlyContinue -Prompt 'Enter Passsword'
        If ($strRemotePassword -eq '') {
            Write-Host "Enter Something"
            Get-Password
        }   
        return $strRemotePassword
    }
function Get-Direction {
    $choice = Read-Host -Prompt 'Select 1 for Inbound, 2 for Outbound, or 3 for Bidirectional'
    switch($choice)
    {
        1 { $strTrustDirection = 'Inbound'}
        2 { $strTrustDirection = 'Outbound'}
        3 { $strTrustDirection = 'Bidirectional'}
    }
    return $strTrustDirection
    
}
function Set-Forest-Trust {
    param (
       [parameter(Mandatory=$true)]
       [String]$strRemoteForest,
       [parameter(Mandatory=$true)]
       [String]$strRemoteUser,
       [parameter(Mandatory=$true)]
       [String]$strRemotePassword,
       [parameter(Mandatory=$true)]
       [ValidateSet("Inbound", "Outbound", "Bidirectional")]
       [String]$strTrustDirection
    )
    Write-Host "Creating trust with following info..."
    Write-Host "Remote Forest :" $strRemoteForest
    Write-Host "Remote User:" $strRemoteUser
    Write-Host "Trust Direction:" $strTrustDirection"`n"
    Write-Host "Creating Trust....."
    $localforest = [System.DirectoryServices.ActiveDirectory.Forest]::getCurrentForest() 
    $remoteContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext('Forest', $strRemoteForest, $strRemoteUser, $strRemotePassword)
    $remoteForest = [System.DirectoryServices.ActiveDirectory.Forest]::getForest($remoteContext)
    $localForest.CreateTrustRelationship($remoteForest, $strTrustDirection)
    Write-Host "`Trust Created."
}

$strRemoteForest = Get-Forest
$strRemoteUser = Get-User
$strRemotePassword = Get-Password
$strTrustDirection = Get-Direction
Write-Host "`n"
Write-Host 'The remote forest is' $strRemoteForest
Write-Host 'The remote username is' $strRemoteUser
Write-Host 'The Trust Direction is' $strTrustDirection
Write-Host "`n"
Pause
Set-Forest-Trust -strRemoteForest $strRemoteForest.ToString() -strRemoteUser $strRemoteUser.ToString() -strRemotePassword $strRemotePassword.ToString() -strTrustDirection $strTrustDirection.ToString()

