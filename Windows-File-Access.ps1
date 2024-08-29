
<#
.SYNOPSIS
   Brief description of the script's purpose.
   Find file when accessed last
.DESCRIPTION
   Detailed description of what the script does.
   Script to collect when a file was last used

.NOTES
   File Name      : Windows-File-Access.ps1
   Author         : Charles Hawkins
   Prerequisite   : Windows PowerShell
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
# Define the target folder path adjust folder path here
$targetFolder = "C:\LocalTech"

# Get today's date in the desired format (e.g., YYYY-MM-DD)
$date = Get-Date -Format "yyyy-MM-dd"

# Define the output CSV file path with today's date adjust folder path here
$outputCsv = "C:\Automation\file-access-report-$date.csv"

# Check if the target folder exists
if (-Not (Test-Path -Path $targetFolder -PathType Container)) {
    Write-Host "The specified folder does not exist: $targetFolder"
    exit
}

try {
    # Get files and their last access date
    $files = Get-ChildItem -Path $targetFolder -Recurse -File | Select-Object FullName, LastAccessTime

    # Sort files by LastAccessTime in descending order (newest to oldest)
    $sortedFiles = $files | Sort-Object -Property LastAccessTime -Descending

    # Check if there are any files found
    if ($sortedFiles.Count -eq 0) {
        Write-Host "No files found in the specified folder and subfolders."
        exit
    }

    # Display the results
    Write-Host "Files sorted by Last Access Date (newest to oldest):"
    $sortedFiles | ForEach-Object {
        Write-Host "$($_.LastAccessTime) - $($_.FullName)"
    }

    # Save the results to a CSV file
    $sortedFiles | Export-Csv -Path $outputCsv -NoTypeInformation -Force
    Write-Host "Results saved to $outputCsv"
} catch {
    Write-Host "An error occurred: $_"
}
