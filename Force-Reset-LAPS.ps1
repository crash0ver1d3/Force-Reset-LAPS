##############################################################################
#  Script: Force-Reset-LAPS.ps1
#    Date: 2020.09.18
# Version: 3.5
#  Author: Blake Regan @blake_r38
# Purpose: Force reset LAPS password to sync LAPS clients, or change values in a hurry.
#   Legal: Script provided "AS IS" without warranties or guarantees of any
#          kind.  USE AT YOUR OWN RISK.  Public domain, no rights reserved.
##############################################################################
<#This script requires the permission "Set-AdmPwdResetPasswordPermission" for LAPS values
refer to LAPS_delegation_annotated.PNG in repo for refernce#>


Import-Module ActiveDirectory

$root = [ADSI]"LDAP://RootDSE"
$DOMAIN = $root.defaultNamingContext

#Place whatever OU the LAPS clients are in that need password reset
$ADServers=@()
$ADServers=Get-AdComputer -Filter * -SearchBase "OU=Servers,$DOMAIN" -Properties Name,samaccountname | select-object -Property Name

foreach ($ADServer in $ADServers)
{
    write-host $ADServer.Name
    Set-ADComputer –Identity $ADServer.name –Replace @{"ms-Mcs-AdmPwdExpirationTime"=0}
}