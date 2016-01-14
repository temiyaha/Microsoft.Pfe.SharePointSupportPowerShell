# Microsoft.Pfe.CreateFields.PowerShell
SharePoint ではアイテムの件数が多いリストでは、閾値やビューの設定に依存し、意図した操作が行えないときがあります。
そのような動作を検証する際に手動でテストデータの作成すると時間がかかるため、簡単にテストデータを作成するスクリプトをご紹介します。

このスクリプトでは下記の操作を PowerShell スクリプトで実施します。

- Step1.カスタムリストの作成
- Step2.列の追加
- Step3.アイテムの追加

###Step1. カスタムリストの作成
リストの作成ではサイトの SPListCollection の Add メソッドを用いて、リストを追加します。
Add メソッドの引数は幾つかのパターンがありますが、一番シンプルな方法としては、

Add("<リストの名前>","<リストの説明>","<リストテンプレートのID>") 

になります。

Title : SPListCollection.Add method
https://msdn.microsoft.com/en-us/library/office/microsoft.sharepoint.splistcollection.add.aspx

なお各リストテンプレートの ID は下記のページで確認することができます。

https://msdn.microsoft.com/en-us/library/office/microsoft.sharepoint.splisttemplatetype.aspx

```PowerShell
$web = Get-SPWeb http://testsite.contoso.local/sites/test/
$listCollection = $web.Lists
$listCollection.Add("TestList","This is test List","100")
```

###Step2. 列の追加
Step1 で作成したリストに列を追加していきます。
列の追加は List の SPFieldCollection に AddFieldAsXml メソッドを用います。

Title : SPFieldCollection.AddFieldAsXml method
https://msdn.microsoft.com/en-us/library/office/microsoft.sharepoint.spfieldcollection.addfieldasxml.aspx

一番シンプルな方法としては、引数に xml を渡します。

AddFieldAsXml("<XMLの定義>")

この XMLの定義が列の種類により、指定の仕方が異なります。
そのため作成したい列に応じて、定義を指定します。

Title : Field Element (List)
https://msdn.microsoft.com/en-us/library/office/ms437580.aspx

Title : FieldType enumeration
https://msdn.microsoft.com/en-us/library/office/microsoft.sharepoint.client.fieldtype.aspx

例えば一行テキストの場合には、下記のような XML を指定します。

##### 1行テキストの追加
```XML
<Field Type='Text' DisplayName='表示名' Required='FALSE' MaxLength='255' StaticName='固定列名' />
```
一行テキストは Type が Text になります。

DisplayName は列の表示名になります。

Required は入力を必須にするかどうかを Boolean で指定します。

MaxLength は最大文字数になります。

StaticName は固定列名となります。

```PowerShell
$list=$web.lists["TestList"]
$columnXml = "<Field Type='Text' DisplayName='ColumnA' Required='FALSE' MaxLength='255' StaticName='ColA' />"
$list.Fields.AddFieldAsXml($columnXml)
```

##### 複数行テキストの追加
```XML
<Field Type='Memo' DisplayName='表示名' Required='FALSE' MaxLength='255' StaticName='固定列名' />
```
複数行テキストは Type が Memo になります。

DisplayName は列の表示名になります。

Required は入力を必須にするかどうかを Boolean で指定します。

MaxLength は最大文字数になります。

StaticName は固定列名となります。
```PowerShell
$list=$web.lists["TestList"]
$columnXml = "<Field Type='Memo' DisplayName='ColumnB' Required='FALSE' MaxLength='255' StaticName='ColB' />"
$list.Fields.AddFieldAsXml($columnXml)
```

##### ユーザーまたはグループの追加
```XML
"<Field Type='User' DisplayName='表示名' Required='False' List='UserInfo' ShowField='ImnName' UserSelectionMode='PeopleOnly' UserSelectionScope='0' StaticName='ColC'/>"
```
複数行テキストは Type が User になります。

DisplayName は列の表示名になります。

Required は入力を必須にするかどうかを Boolean で指定します。

List は選択元の設定となり、ユーザー情報リスト(UserInfo) から取得するか、指定した SharePoint グループから取得するかを指定します。

ShowField は表示フィールドとなり、ImnName は "名前(プレゼンス付き)" となります。

UserSelectionMode は "ユーザーのみ" か "ユーザーとグループ" かを指定します。

UserSelectionScope は List で選択したグループの ID を指定します。UserInfo は 0 になります。

StaticName は固定列名となります。

```PowerShell
$list=$web.lists["TestList"]
$columnXml = "<Field Type='User' DisplayName='ColumnC' Required='False' List='UserInfo' ShowField='ImnName' UserSelectionMode='PeopleOnly' UserSelectionScope='0' StaticName='ColC'/>"
$list.Fields.AddFieldAsXml($columnXml)
```

##### 選択肢の追加
```XML
"<Field Type='Choice' DisplayName='ColumnD' Required='False' Format='Dropdown' FillInChoice='FALSE' StaticName='ColD' >
            <Default>ChoiceX</Default>
            <CHOICES>
                <CHOICE>ChoiceX</CHOICE>
                <CHOICE>ChoiceY</CHOICE>
                <CHOICE>ChoiceZ</CHOICE>
            </CHOICES>
           </Field>"
```
選択肢は Type が Choice になります。

DisplayName は列の表示名になります。

Required は入力を必須にするかどうかを Boolean で指定します。

Format は "ドロップダウン" か "ラジオ ボタン" か "チェックボックス" かを指定します。

FillInChoice は選択肢を追加できるようにするかを Boolean で指定します。

StaticName は固定列名となります。

最後に選択肢に表示させる項目を記載します。

```PowerShell
$list=$web.lists["TestList"]
$columnXml = "<Field Type='Choice' DisplayName='ColumnD' Required='False' Format='Dropdown' FillInChoice='FALSE' StaticName='ColD' >
            <Default>ChoiceX</Default>
            <CHOICES>
                <CHOICE>ChoiceX</CHOICE>
                <CHOICE>ChoiceY</CHOICE>
                <CHOICE>ChoiceZ</CHOICE>
            </CHOICES>
           </Field>"
$list.Fields.AddFieldAsXml($columnXml)
```

### Step3.アイテムの追加
次は作成したリストにアイテムを追加します。
リストの AddItem メソッドを利用して、アイテムの追加を行います。
なお、ユーザー列は事前に値に入力するユーザーオブジェクトを取得する必要があります。

```PowerShell
#サイトからユーザーオブジェクトを取得
$user = Get-SPUser -web $web | where {$_.UserLogin -eq 'contoso\User001'}
$item=$list.AddItem()
$item["Title"] = "Test Title 1"
$item["ColumnA"] = "Test A 1"
$item["ColumnB"] = "Test B 1"
$item["ColumnC"] = $user
$item["ColumnD"] = "ChoiceZ"
$item.Update()
```

### 最後に下記のシナリオで一連の操作をスクリプトで実行してみたいと思います。
カスタムリストの作成
列の追加
5000 件のアイテムの追加

```PowerShell
#カスタムリストの作成
$web = Get-SPWeb http://testsite.contoso.local/sites/test/
$listCollection = $web.Lists
$listCollection.Add("TestList","This is test List","100")
$list=$web.lists["TestList"]
#1行テキストの作成
$columnXml = "<Field Type='Text' DisplayName='ColumnA' Required='FALSE' MaxLength='255' StaticName='ColA' />"
$list.Fields.AddFieldAsXml($columnXml)
#複数行テキストの作成
$columnXml = "<Field Type='Memo' DisplayName='ColumnB' Required='FALSE' MaxLength='255' StaticName='ColB' />"
$list.Fields.AddFieldAsXml($columnXml)
#ユーザーまたはグループ列の作成
$columnXml = "<Field Type='User' DisplayName='ColumnC' Required='False' List='UserInfo' ShowField='ImnName' UserSelectionMode='PeopleOnly' UserSelectionScope='0' StaticName='ColC'/>"
$list.Fields.AddFieldAsXml($columnXml)
#選択肢列の作成
$columnXml = "<Field Type='Choice' DisplayName='ColumnD' Required='False' Format='Dropdown' FillInChoice='FALSE' StaticName='ColD' >
            <Default>ChoiceX</Default>
            <CHOICES>
                <CHOICE>ChoiceX</CHOICE>
                <CHOICE>ChoiceY</CHOICE>
                <CHOICE>ChoiceZ</CHOICE>
            </CHOICES>
           </Field>"
$list.Fields.AddFieldAsXml($columnXml)
#アイテムを 5000 件追加
$user = Get-SPUser -web $web | where {$_.UserLogin -eq 'contoso\User001'}
for($i=0;$i -le 5000; $i++){
 $item=$list.AddItem()
 $item["Title"] = "Test Title $i"
 $item["ColumnA"] = "Test A $i"
 $item["ColumnB"] = "Test B $i"
 $item["ColumnC"] = $user
 $item["ColumnD"] = "ChoiceZ"
 $item.Update()
}
$web.Dispose()
```



