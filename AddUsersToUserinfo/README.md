It takes time if you add user to web site. (Only add to UserInfo table)
By using PowerShell, you can automate the task.

```PowerShell
# Get Web Site
$web = Get-SPWeb http://portal.contoso.local/sites/test

#Add Users(contoso\test0001 - contoso\test9999) to UserInfo List
for($i=1; $i -le 9999; $i++){
 $str = "{0:D4}" -f $i
 $name = "contoso\test" + $str
 $web.EnsureUser("$name")
}

$web.dispose()
```
