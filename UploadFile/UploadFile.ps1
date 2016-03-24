# Specify folder path which contains files to upload.
$FolderPath="C:\test"

# Specify document library name
$documentLibaryName = "Documents"

# Get a document libary.
$web = Get-SPWeb http://portal.contoso.local/sites/pstest/
$list = $web.lists[$documentLibaryName]
$listRootFolder = $list.RootFolder

$files = Get-ChildItem $FolderPath           

foreach($file in $files){
  #Upload file
  $fileStream = ([System.IO.FileInfo] (Get-Item $file.FullName)).OpenRead()            
  [Microsoft.SharePoint.SPFile]$spFile = $listRootFolder.Files.Add($listRootFolder.Url + "/" + $file.Name,   [System.IO.Stream]$fileStream, $true)            
  $fileStream.Close()     
  $spFile.Item["Title"] =  $file.Name.Replace($file.Extension,"")
  $spFile.Item.Update()
}
