# Get all machines with server operating systems

$servers = Get-ADComputer -Filter {operatingSystem -like "*Server*"} -Properties | Select Name,operatingSystem

# Loop through all servers (assuming all of them are online) and force enable LSA protection via the registry

$servers | ForEach-Object{

  $server = $_.Name
  $session = New-PSSession -ComputerName $server
  $script = {New-ItemProperty -Path "HKLM:SYSTEM\CurrentControlSet\Control\Lsa" -Name "RunAsPPL" -Property DWORD -Value "00000001" -Force | Out-Null}
  Invoke-Command -Session $session -Scriptblock $script
  Remove-PSSession $session

  }

  
