# Forces local client to purge all Kerberos tokens/tickets and immediately request new ones

Get-WmiObject -ClassName Win32_LogonSession -Filter "AuthenticationPackage !='NTLM'" | ForEach-Object{[Convert]::ToString($_.LogonId, 16)} | ForEach-Object {klist.exe purge -li $_}
