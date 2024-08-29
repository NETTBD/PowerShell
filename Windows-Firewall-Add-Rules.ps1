<#
.SYNOPSIS
   Brief description of the script's purpose.
   Add Firewall Rules by Rule Name
.DESCRIPTION
   Detailed description of what the script does.
   Script to add firewall rules by reading from a text file with error checking and logging

.NOTES
   File Name      : Windows-Firewall-Add-Rules.ps1
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
# Define the path to the text file with the rules
$rulesFilePath = "C:\Path\To\Rules.txt"

# Define the log file path
$logFilePath = "C:\Logs\firewall_rules_addition.log"

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

# Check if the rules file exists
if (-not (Test-Path $rulesFilePath)) {
    $errorMessage = "Rules file '$rulesFilePath' does not exist."
    Write-Host $errorMessage
    Write-Log -Message $errorMessage
    exit 1
}

try {
    # Read the rules from the text file
    $rules = Get-Content -Path $rulesFilePath

    foreach ($rule in $rules) {
        $ruleParts = $rule -split ','
        
        if ($ruleParts.Length -ne 2) {
            $errorMessage = "Invalid rule format: '$rule'"
            Write-Host $errorMessage
            Write-Log -Message $errorMessage
            continue
        }

        $action = $ruleParts[0].Trim()
        $cidr = $ruleParts[1].Trim()
        $ruleName = "$action CIDR $cidr"

        try {
            # Add the firewall rule
            if ($action -eq 'Block') {
                New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Action Block -RemoteAddress $cidr -Profile Any -ErrorAction Stop
                $successMessage = "Firewall rule '$ruleName' has been successfully added."
                Write-Host $successMessage
                Write-Log -Message $successMessage
            } elseif ($action -eq 'Allow') {
                New-NetFirewallRule -DisplayName $ruleName -Direction Outbound -Action Allow -RemoteAddress $cidr -Profile Any -ErrorAction Stop
                $successMessage = "Firewall rule '$ruleName' has been successfully added."
                Write-Host $successMessage
                Write-Log -Message $successMessage
            } else {
                $errorMessage = "Unknown action '$action' for rule: '$rule'"
                Write-Host $errorMessage
                Write-Log -Message $errorMessage
            }
        } catch {
            $errorMessage = "Failed to add rule '$ruleName': $($_.Exception.Message)"
            Write-Host $errorMessage
            Write-Log -Message $errorMessage
        }
    }
} catch {
    # Handle errors
    $errorMessage = "An error occurred: $($_.Exception.Message)"
    Write-Host $errorMessage
    Write-Log -Message $errorMessage
    exit 1
}

