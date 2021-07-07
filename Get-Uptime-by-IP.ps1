$computer = Read-Host "Enter computer IP address"
(Get-Date) - [Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $computer).LastBootUpTime)