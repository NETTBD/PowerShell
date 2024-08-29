<#
.SYNOPSIS
   Brief description of the script's purpose.
   Check Domain Health using DCDiag
.DESCRIPTION
   Detailed description of what the script does.
   Capture DCDiag results, and saves output to a txt file.

.NOTES
   File Name      : AD-DCDiag-Report.ps1
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
# Define the output file with a timestamp
$outputFile = "DCDiag_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# Function to write output to the report
function Write-OutputToReport {
    param (
        [string]$output
    )
    Add-Content -Path $outputFile -Value $output
}

# Start the report
Write-OutputToReport "DCDiag Report - $(Get-Date)"
Write-OutputToReport "---------------------------------------------"

# Run dcdiag /v and capture the output
Write-OutputToReport "`nRunning dcdiag /v..."
try {
    $dcdiagOutput = & dcdiag /v 2>&1
    $formattedOutput = $dcdiagOutput -join "`n"
    
    # Split the output into sections based on common headers
    $sections = $formattedOutput -split "(\r?\n){2,}"  # Split by double newlines

    foreach ($section in $sections) {
        Write-OutputToReport "`nSection Start:"
        Write-OutputToReport $section
        Write-OutputToReport "`n---------------------------------------------"
    }
} catch {
    Write-OutputToReport "`nFailed to run dcdiag /v. $_"
}

# Finalize the report
Write-OutputToReport "`nReport generated on $(Get-Date)"

# Inform the user
Write-Host "DCDiag report has been generated at $outputFile"
