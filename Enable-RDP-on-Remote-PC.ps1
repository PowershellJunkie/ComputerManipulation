$compname = Read-Host "Enter Computer Name"
Enter-PSSession -ComputerName $compname
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Exit-PSSession