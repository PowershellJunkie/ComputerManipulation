$computer = Read-Host "Enter remote computer name"
(Get-Date) - (Get-CimInstance Win32_OperatingSystem -ComputerName $computer).LastBootupTime