#---Dynamic Install for RSAT tools, local computer. This way, if Microsoft changes the version, as long as the repos remain the same, the version won't matter---#
$tools = @()
$deets = Get-WindowsCapability -Online -Name RSAT*
$tools += $deets

$rsat = $tools | Select Name,State | Where {$_.State -like "*NotPresent*"}


$rsat | ForEach-Object{

    $name = $_.Name
    Add-WindowsCapability -Online -Name $name

    }

