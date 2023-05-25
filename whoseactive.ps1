# Import required modules
Install-Module -Name ImportExcel
Install-Module -Name ExchangeOnlineManagement

# Specify the path to the Excel spreadsheet
$excelPath = "C:\Path\To\Your\Spreadsheet.xlsx"

# Load the Excel data
$data = Import-Excel -Path $excelPath

# Connect to Exchange Online
Connect-ExchangeOnline

# Loop through each row until a blank cell is encountered in column B (email address)
foreach ($row in $data) {
    $email = $row.Email

    # Stop the loop if the email address is blank
    if ([string]::IsNullOrWhiteSpace($email)) {
        break
    }

    # Check if the email address is active in Exchange Online
    $user = Get-EXOMailbox -Identity $email -ErrorAction SilentlyContinue

    # If the email address is disabled, highlight the row in yellow
    if (!$user) {
        $row | Add-Member -NotePropertyName "Style" -NotePropertyValue @{Background = "Yellow"}
    }
}

# Save the modified data to a new Excel file
$outputPath = "C:\Path\To\Your\ModifiedSpreadsheet.xlsx"
$data | Export-Excel -Path $outputPath

Write-Host "Verification completed. Modified spreadsheet saved to: $outputPath"
