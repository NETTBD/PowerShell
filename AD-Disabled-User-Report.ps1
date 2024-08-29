<#
.SYNOPSIS
   Brief description of the script's purpose.
   Export Disabled Users.
.DESCRIPTION
   Detailed description of what the script does.
   List Disabled Domain Users - Users that have disabled accounts, and saves output to a csv file.

.NOTES
   File Name      : AD-Disabled-User-Report.ps1
   Author         : Charles Hawkins
   Prerequisite   : Windows PowerShell, ADUC tools
   Company        : ????
   License        : CC0  

   Version History
   ---------------
   1.0 - Initial release

.EXAMPLE
   .
   How to use the script with parameters.

#>
#
$LogDate = Get-Date -f yyyyMMddhhmm
# Define the output file path
$outputFilePath = "c:\Automation\DisabledUsers_$LogDate.csv"

try {
    # Ensure the output directory exists
    $outputDirectory = Split-Path -Path $outputFilePath -Parent
    if (-not (Test-Path -Path $outputDirectory)) {
        Write-Host "The directory $outputDirectory does not exist. Creating it now..."
        New-Item -Path $outputDirectory -ItemType Directory -Force
        Write-Host "Directory created successfully."
    } else {
        Write-Host "The directory $outputDirectory already exists."
    }

    # Get Disabled users and export to CSV
    Get-ADUser -Filter {Enabled -eq $false} -Properties Name, SamAccountName, Enabled | Export-Csv -Path $outputFilePath -NoTypeInformation

    # Report success
    if (Test-Path -Path $outputFilePath) {
        Write-Host "Success: The list of Disabled users has been exported to $outputFilePath"
    } else {
        Write-Host "Error: Failed to export the list of Disabled users."
    }
} catch {
    # Capture and report errors
    Write-Host "Error: $($_.Exception.Message)"
}
