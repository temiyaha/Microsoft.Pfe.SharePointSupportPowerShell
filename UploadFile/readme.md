$FilePath="C:\test\web.txt"
$web = Get-SPWeb http://portal.contoso.local/sites/pstest/
$list = $web.lists["共有ドキュメント"]
$folder = $list.RootFolder

$FileName = $FilePath.Substring($FilePath.LastIndexOf("\")+1)

$File= Get-ChildItem $FilePath            
#[Microsoft.SharePoint.SPFile]$spFile = $Web.GetFile("/" + $folder.Url + "/" + $File.Name) 

$fileStream = ([System.IO.FileInfo] (Get-Item $File.FullName)).OpenRead()            
[Microsoft.SharePoint.SPFile]$spFile = $folder.Files.Add($folder.Url + "/" + $File.Name, [System.IO.Stream]$fileStream, $true)            
$fileStream.Close()            
$spFile.Item["Title"] = "PowerShell Upload"            
$spFile.Item.Update()            
