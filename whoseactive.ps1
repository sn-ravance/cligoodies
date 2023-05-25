# Import the required module
Import-Module ImportExcel

# Specify the path to the Excel spreadsheet
$excelPath = "C:\Path\To\Your\Spreadsheet.xlsx"

# Load the Excel data
$data = Import-Excel -Path $excelPath

# Initialize Outlook COM object
$outlook = New-Object -ComObject Outlook.Application

# Loop through each row until a blank cell is encountered in column B (email address)
foreach ($row in $data) {
    $email = $row.Email

    # Stop the loop if the email address is blank
    if ([string]::IsNullOrWhiteSpace($email)) {
        break
    }

    # Check if the email address is disabled in Outlook
    $addressEntry = $outlook.Session.CreateRecipient($email)
    $exchangeUser = $addressEntry.AddressEntry.GetExchangeUser()
    $isDisabled = $exchangeUser.AccountDisabled

    # If the email address is disabled, highlight the row in yellow
    if ($isDisabled) {
        $row | Add-Member -NotePropertyName "Style" -NotePropertyValue @{Background = "Yellow"}
    }
}

# Save the modified data to a new Excel file
$outputPath = "C:\Path\To\Your\ModifiedSpreadsheet.xlsx"
$data | Export-Excel -Path $outputPath

# Clean up the Outlook COM object
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($outlook) | Out-Null
Remove-Variable -Name outlook

Write-Host "Verification completed. Modified spreadsheet saved to: $outputPath"
