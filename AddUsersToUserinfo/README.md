It takes time if you add user to web site. (Only add to UserInfo table)
By using PowerShell, you can automate the task.

```PowerShell
Add-PSSnapin Microsoft.SharePoint.Powershell

$web = Get-SPWeb Add-PSSnapin Microsoft.SharePoint.Powershell

for($i=1; $i -le 9999; $i++){
 $str = "{0:D4}" -f $i
 $name = "contoso\test" + $str
 $web.EnsureUser("$name")
 $role = $web.RoleDefinitions["Contribute"]
 $assignment.RoleDefinitionBindings.Add($role
 $web.RoleAssignments.Add($assignment)
}
```
