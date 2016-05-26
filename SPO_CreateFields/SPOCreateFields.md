```PowerShell
#Load Client Module
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client")

#Param
$siteUrl = "https://<YourSPOName>.sharepoint.com/sites/<SiteCollection>/"
$username = "<Account mail address>"
$secpass = Read-Host -Prompt "Please enter your password" -AsSecureString
$listName = "<ListName>"

#Bind to Site
$context = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) 
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $secpass)

#Create a custom list
$listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$listCreationInformation.Title = $listName
$listCreationInformation.TemplateType = 101
$list = $context.Web.Lists.Add($listCreationInformation)
$context.Load($list)
$context.ExecuteQuery()

#Create fields

```
