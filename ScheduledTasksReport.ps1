<#

Purpose of this script is to get all scheduled tasks on a machine, then format and produce a workable report for missed tasks.
This allows the admins to appropriately investigate and correct missed or malfunctioning scheduled tasks.

#>

#-- Query the report runner for the server from which we will collect our scheduled task report
$server = Read-Host "Enter the full server name or FQDN of the server to query. IP Address is not acceptable."

#-- Get all enabled, scheduled tasks
$tasks = Get-ScheduledTask -CimSession $server -TaskName * -TaskPath "\" | Select TaskName,State | Where {$_.State -notlike "*Disabled*"} | Select TaskName
 
#-- Build the appropriate reporting array

 [System.Collections.ArrayList] $info = @()

#-- Using the 'tasks' array, collect the desired run information

$tasks | ForEach-Object{

    $task = $_.TaskName
    
    $val = [pscustomobject]@{
    'Task Name' = Get-ScheduledTaskInfo -CimSession $server -TaskName $task -TaskPath "\" | Select-Object -ExpandProperty TaskName 
    'Last Run Time' = Get-ScheduledTaskInfo -CimSession $server -TaskName $task -TaskPath "\" | Select-Object -ExpandProperty LastRunTime 
    'Last Task Result' = Get-ScheduledTaskInfo -CimSession $server -TaskName $task -TaskPath "\" | Select-Object -ExpandProperty LastTaskResult
    'Next Run Time' = Get-ScheduledTaskInfo -CimSession $server -TaskName $task -TaskPath "\" | Select-Object -ExpandProperty NextRuntime
    'Number of Missed Runs' = Get-ScheduledTaskInfo -CimSession $server -TaskName $task -TaskPath "\" | Select-Object -ExpandProperty NumberofMissedRuns
    'Server Host' = Get-ScheduledTaskInfo -CimSession $server -TaskName $task -TaskPath "\" | Select-Object -ExpandProperty PSComputerName
    }
    $info.Add($val) | Out-Null
    $val = $null
 }

#-- Display the report

 $info | Write-Output | ft
