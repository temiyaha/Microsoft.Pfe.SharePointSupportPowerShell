This script is not for SharePoint.

This is creating some AD users.

```PowerShell
#Import ActiveDirectory Module
Import-Module ActiveDirectory

#define password and Number of Users, UserName
$password = ConvertTo-SecureString -AsPlainText "P@ssw0rd1" -Force
$numberofUser = 100
$userName="test"

for($i=1; $i -le $numberofUser; $i++){
#Adjust the digit of number.
$str = "{0:D4}" -f $i

#define user name and upn.
$name = $userName + $str
$upn = $name +"@contoso.local"

#Create ADUser
New-ADUser -Name $name -Surname $userName -GivenName $str -DisplayName $name -UserPrincipalName $upn -AccountPassword $password -PasswordNeverExpires $true -path "OU=OU11,OU=User,DC=contoso,DC=local" -Enabled $True
} 
