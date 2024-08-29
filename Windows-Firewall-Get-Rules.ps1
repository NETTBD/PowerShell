<#
.SYNOPSIS
   Brief description of the script's purpose.
   Get all Firewall Rules by Rule Name
.DESCRIPTION
   Detailed description of what the script does.
   Script to capture all current firewall rules with error checking and save output to a text file

.NOTES
   File Name      : Windows-Firewall-Get-Rules.ps1
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
# Define the log file path
$logFilePath = "C:\Logs\firewall_rules.txt"

# Ensure the log file directory exists
$logDirectory = [System.IO.Path]::GetDirectoryName($logFilePath)

if (-not (Test-Path $logDirectory)) {
    try {
        New-Item -Path $logDirectory -ItemType Directory -Force
        Write-Host "Log directory '$logDirectory' created."
    } catch {
        Write-Host "Failed to create log directory: $($_.Exception.Message)"
        exit 1
    }
}

# Function to log messages to the log file
function Write-Log {
    param (
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFilePath -Value "$timestamp - $Message"
}

try {
    # Retrieve all firewall rules
    $firewallRules = Get-NetFirewallRule -ErrorAction Stop

    # Check if any rules were found
    if ($firewallRules) {
        # Prepare the header for the output
        $output = @("Name, Action")
        
        # Loop through each rule and collect the name and action
        foreach ($rule in $firewallRules) {
            $output += "$($rule.DisplayName), $($rule.Action)"
        }
        
        # Save the output to the log file
        $output | Out-File -FilePath $logFilePath -Encoding UTF8
        $successMessage = "Firewall rules have been successfully captured and saved to '$logFilePath'."
        Write-Host $successMessage
        Write-Log -Message $successMessage
    } else {
        $infoMessage = "No firewall rules found."
        Write-Host $infoMessage
        Write-Log -Message $infoMessage
    }
} catch {
    # Handle errors
    $errorMessage = "An error occurred: $($_.Exception.Message)"
    Write-Host $errorMessage
    Write-Log -Message $errorMessage
    exit 1
}
