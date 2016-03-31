##BreakInheritance

It takes time if you stop inheriting permissions to many items manually. By using PowerShell, you can automate the task.

```PowerShell
# Get a web
$web = Get-SPWeb http://portal.contoso.local/sites/test

# Get a list
$list = $web.Lists["TestList"]

foreach($item in $list.Items){
 if($item.HasUniqueRoleAssignments -eq $false)
 {
   # Stop inheriting permissions.
   # $false means to break role inheritance, $true to break role inheritance and to copy the role assignments
   $item.BreakRoleInheritance($false)
 }
}

$dispose web
$web.dipose()
```
