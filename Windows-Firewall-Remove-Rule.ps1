<#
.SYNOPSIS
   Brief description of the script's purpose.
   Remove a Firewall Rule by Rule Name
.DESCRIPTION
   Detailed description of what the script does.
   Script to remove a specific firewall rule with error checking and logging

.NOTES
   File Name      : Windows-Firewall-Remove-Rule.ps1
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
# Define the display name of the firewall rule to be removed
$ruleDisplayName = "Block CIDR 141.0.0.0/8"

# Define the log file path
$logFilePath = "C:\Logs\firewall_script.log"

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
    # Check if the firewall rule exists
    $rule = Get-NetFirewallRule -DisplayName $ruleDisplayName -ErrorAction Stop

    if ($rule) {
        # Remove the firewall rule
        Remove-NetFirewallRule -DisplayName $ruleDisplayName -ErrorAction Stop
        $successMessage = "Firewall rule '$ruleDisplayName' has been successfully removed."
        Write-Host $successMessage
        Write-Log -Message $successMessage
    } else {
        $infoMessage = "Firewall rule '$ruleDisplayName' does not exist."
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
