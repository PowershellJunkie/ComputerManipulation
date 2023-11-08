<#

Purpose of this script is to get all scheduled tasks on a machine, then format and produce a workable report for missed tasks.
This allows the admins to appropriately investigate and correct missed or malfunctioning scheduled tasks.

#>

#-- Query the report runner for the servers from which we will collect our scheduled task reports
$servers = @('<Your Server Names here>','<Each name in quotes>','<and separated by a comma>','<no brackets noob>')

ForEach($server in $servers){

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

 $output = $info | ConvertTo-Html -as Table -Fragment
 
 # Create HTML output for email
 $htmlbod = @"
<html> 
<head>
<style>
body {
    Color: #252525;
    font-family: Verdana,Arial;
    font-size:11pt;
}
table {border: 1px solid rgb(104,107,112); text-align: left;}
th {background-color: #d2e3f7;border-bottom:2px solid rgb(79,129,189);text-align: left;}
tr {border-bottom:2px solid rgb(71,85,112);text-align: left;}
td {border-bottom:1px solid rgb(99,105,112);text-align: left;}
h1 {
    text-align: left;
    color:#5292f9;
    Font-size: 14pt;
    font-family: Verdana, Arial;
}
h2 {
    text-align: left;
    color:#323a33;
    Font-size: 20pt;
}

</style>
</head>
<body style="font-family:verdana;font-size:13">
Hello, <br><br>

Below is the scheduled tasks report
<br>
<br>
<h2>Tasks and Statuses</h2>
$output

<br>
<br>
Thank you,<br>
IT Department<br><br>

</body> 
</html> 
"@ 

# Set users/departments for email notification
$mailnotification = "<somerecipient@somedomain.com>"

# Notification email that includes HTML report 
Send-MailMessage -From '<streports@somedomain.com>' -To $mailnotification -Subject "Scheduled Task Report: $server" -BodyAsHtml $htmlbod -SmtpServer '<yourdomain-com.mail.protection.outlook.com>'

 
}
