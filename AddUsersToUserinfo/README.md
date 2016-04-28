It takes time if you add user to web site. (Only add to UserInfo table)
By using PowerShell, you can automate the task.

```PowerShell
Add-PSSnapin Microsoft.SharePoint.Powershell

# Get SharePoint Site
$web = Get-SPWeb http://Portal.contoso.local/sites/test
$numberofUsers

for($i=1; $i -le 10; $i++){
# define User Name
 $str = "{0:D4}" -f $i
 $name = "contoso\test" + $str
 
#Add User to the web
 $account=$web.EnsureUser("$name")

 $assignment = New-Object Microsoft.SharePoint.SPRoleAssignment($account)

# "Contribute" Role Define
 $role = $web.RoleDefinitions["Contribute"]

 $assignment.RoleDefinitionBindings.Add($role)
# Add 
 $web.RoleAssignments.Add($assignment)
}
```
