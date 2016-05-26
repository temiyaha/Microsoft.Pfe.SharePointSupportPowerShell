It takes time if you add user to web site. 
By using PowerShell, you can automate the task.

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
 New-ADUser -Name $name -Surname $userName -GivenName $str -DisplayName $name -UserPrincipalName $upn -AccountPassword $password -PasswordNeverExpires $true -path "OU=testUsers,OU=User,DC=contoso,DC=local" -Enabled $True
} 

#Import SharePoint Module
Add-PSSnapin Microsoft.SharePoint.Powershell

# Get SharePoint Site
$web = Get-SPWeb http://Portal.contoso.local/sites/test

for($i=1; $i -le $numberofUser; $i++){
 $str = "{0:D4}" -f $i
 $name = "contoso\test" + $str
 
 #Add User to the web
 $account=$web.EnsureUser("$name")
 $assignment = New-Object Microsoft.SharePoint.SPRoleAssignment($account)

 #"Contribute" Role Define
 $role = $web.RoleDefinitions["Contribute"]
 $assignment.RoleDefinitionBindings.Add($role)
 #Add 
 $web.RoleAssignments.Add($assignment)
}
```
