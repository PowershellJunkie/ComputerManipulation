# Get all servers in preparation to enable LSA Logging for later capture. This assumes all servers are online and correct in AD

$servers = Get-ADComputer -Filter {operatingSystem -like "*Server*"} -Properties * | Select-Object Name,operatingSystem

# Definine Script for LSA logging registry entries
$lsalogging = {
New-Item -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe" | Out-Null
New-ItemProperty -Path "HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\LSASS.exe" -Name "AuditLevel" -PropertyType DWORD -Value "00000008" -Force | Out-Null
}

# Cycle through all servers, initiating a remote PSSession and adding running the script to enable LSA logging for later capture
$servers | ForEach-Object{

  $server = $_.Name
  $session = New-PSSession -ComputerName $server
  Invoke-Command -Session $session -Script $lsalogging
  Remove-PSSession $session

  }
  
