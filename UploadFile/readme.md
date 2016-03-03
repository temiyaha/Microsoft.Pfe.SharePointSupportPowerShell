Microsoft.Pfe.UploadFiles.PowerShell

SharePoint 環境で大量のファイルが保存されているドキュメント ライブラリの検証を行う際、大量のファイルを作成するには手間がかかります。
そこで PowerShell を用いて、大量のファイルをアップロードしたいと思います。

```PowerShell
$FilePath="C:\test"
$web = Get-SPWeb http://portal.contoso.local/sites/pstest/
$list = $web.lists["共有ドキュメント"]
$folder = $list.RootFolder
$FileName = $FilePath.Substring($FilePath.LastIndexOf("\")+1)
$File= Get-ChildItem $FilePath            

foreach($f in $File){
$fileStream = ([System.IO.FileInfo] (Get-Item $f.FullName)).OpenRead()            
[Microsoft.SharePoint.SPFile]$spFile = $folder.Files.Add($folder.Url + "/" + $f.Name, [System.IO.Stream]$fileStream, $true)            
$fileStream.Close()     
$spFile.Item["Title"] = "PowerShell Upload"            
$spFile.Item.Update()
}
```
