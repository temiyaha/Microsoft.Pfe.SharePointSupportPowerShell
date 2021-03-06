# Generated by: Tetsuo Miyahara (temiyaha)
#
# Copyright © Microsoft Corporation.  All Rights Reserved.
# This code released under the terms of the 
# Microsoft Public License (MS-PL, http://opensource.org/licenses/ms-pl.html.)
# Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
# THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
# INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
# We grant You a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. 
# You agree: 
# (i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
# (ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; 
# and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or result from the use or distribution of the Sample Code 

## This sample works with SharePoint Server 2010/2013 only.
## Create Custom List ## 
$web = Get-SPWeb http://testsite.contoso.local/sites/test/
$listCollection = $web.Lists
$listCollection.Add("TestList","This is test List","100")
$list=$web.lists["TestList"]

## Add fields to the list ## 
# Add single line text field
$columnXml = "<Field Type='Text' DisplayName='ColumnA' Required='FALSE' MaxLength='255' StaticName='ColA' />"
$list.Fields.AddFieldAsXml($columnXml)

# Add multi-line text field
$columnXml = "<Field Type='Memo' DisplayName='ColumnB' Required='FALSE' MaxLength='255' StaticName='ColB' />"
$list.Fields.AddFieldAsXml($columnXml)

# Add User and Group field
$columnXml = "<Field Type='User' DisplayName='ColumnC' Required='False' List='UserInfo' ShowField='ImnName' UserSelectionMode='PeopleOnly' UserSelectionScope='0' StaticName='ColC'/>"
$list.Fields.AddFieldAsXml($columnXml)

# Add Choice field
$columnXml = "<Field Type='Choice' DisplayName='ColumnD' Required='False' Format='Dropdown' FillInChoice='FALSE' StaticName='ColD' >
            <Default>ChoiceX</Default>
            <CHOICES>
                <CHOICE>ChoiceX</CHOICE>
                <CHOICE>ChoiceY</CHOICE>
                <CHOICE>ChoiceZ</CHOICE>
            </CHOICES>
           </Field>"
$list.Fields.AddFieldAsXml($columnXml)

## Add sample data ## 
# Get a user for User and Group field
$user = Get-SPUser -web $web | where {$_.UserLogin -eq 'contoso\User001'}

# Add 5000 items to the list
for($i=0;$i -le 5000; $i++){
 $item=$list.AddItem()
 $item["Title"] = "Test Title $i"
 $item["ColumnA"] = "Test A $i"
 $item["ColumnB"] = "Test B $i"
 $item["ColumnC"] = $user
 $item["ColumnD"] = "ChoiceZ"
 $item.Update()
}

## Finally dispose the object
$web.Dispose()
