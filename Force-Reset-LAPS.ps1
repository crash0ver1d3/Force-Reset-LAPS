##############################################################################
#  Script: Get-LocalMembership-Domain.ps1
#    Date: 2020.09.18
# Version: 3.5
#  Author: Blake Regan @blake_r38
# Purpose: Identify accounts in local groups on domain joined windows workstations
#   Legal: Script provided "AS IS" without warranties or guarantees of any
#          kind.  USE AT YOUR OWN RISK.  Public domain, no rights reserved.
##############################################################################


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