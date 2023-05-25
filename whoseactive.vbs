Sub HighlightDisabledEmails()
    Dim olApp As Outlook.Application
    Dim olNamespace As Outlook.Namespace
    Dim olFolder As Outlook.Folder
    Dim olItems As Outlook.Items
    Dim olMail As Outlook.MailItem
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim emailRange As Range
    Dim cell As Range
    
    ' Set the worksheet where your data is located
    Set ws = ThisWorkbook.Worksheets("Sheet1") ' Replace "Sheet1" with your actual sheet name
    
    ' Find the last row in Column B
    lastRow = ws.Cells(ws.Rows.Count, "B").End(xlUp).Row
    
    ' Set the range for Column B
    Set emailRange = ws.Range("B2:B" & lastRow)
    
    ' Initialize Outlook objects
    Set olApp = New Outlook.Application
    Set olNamespace = olApp.GetNamespace("MAPI")
    Set olFolder = olNamespace.GetDefaultFolder(olFolderInbox)
    Set olItems = olFolder.Items
    
    ' Loop through each cell in the email range
    For Each cell In emailRange
        ' Check if the email is disabled in Outlook
        For Each olMail In olItems
            If olMail.Class = olMail And olMail.Subject = cell.Value Then
                ' Highlight the entire row in yellow
                cell.EntireRow.Interior.Color = RGB(255, 255, 0)
                Exit For
            End If
        Next olMail
    Next cell
    
    ' Clean up Outlook objects
    Set olItems = Nothing
    Set olFolder = Nothing
    Set olNamespace = Nothing
    Set olApp = Nothing
End Sub
