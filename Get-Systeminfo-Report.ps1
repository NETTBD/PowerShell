<#
.SYNOPSIS
   Brief description of the script's purpose.
   GET Systeminfo from computer
.DESCRIPTION
   Detailed description of what the script does.
   Capture output from systeminfo, and saves output to a html file.

.NOTES
   File Name      : Get-Systeminfo-Report.ps1
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


# Define output file with timestamp
$outputFile = "SystemInfo_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"

# Run systeminfo command and capture output
$systemInfo = systeminfo

# Initialize HTML content
$htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Information Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
    </style>
</head>
<body>
    <h1>System Information Report</h1>
    <table>
        <thead>
            <tr>
                <th>Property</th>
                <th>Value</th>
            </tr>
        </thead>
        <tbody>
"@

# Process systeminfo output
foreach ($line in $systemInfo) {
    if ($line -match "^(?<key>.*?):\s+(?<value>.*)$") {
        $key = $matches['key'].Trim()
        $value = $matches['value'].Trim()
        $htmlContent += "<tr><td>$key</td><td>$value</td></tr>`r`n"
    }
}

# Finalize HTML content
$htmlContent += @"
        </tbody>
    </table>
</body>
</html>
"@

# Save HTML content to file
$htmlContent | Out-File -FilePath $outputFile -Encoding utf8

# Inform the user
Write-Host "System information report has been generated at $outputFile"
