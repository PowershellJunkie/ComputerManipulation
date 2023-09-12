#Define Variables
$compname = Read-Host "Enter the computer name or IP Address" 
$output = "InstalledPrograms"
$uname = Read-Host "Enter the user's Win2K name from Active Directory; aka the sAMAccountName"
$mail = Read-Host "Enter full email address to receive notification to when backup is complete"


mkdir \\yourserver\directory\UserBackups\$uname
mkdir \\yourserver\directory\UserBackups\$uname\Desktop
mkdir \\yourserver\directory\UserBackups\$uname\Downloads
mkdir \\yourserver\directory\UserBackups\$uname\Pictures
mkdir \\yourserver\directory\UserBackups\$uname\Favorites
mkdir \\yourserver\directory\UserBackups\$uname\Signatures
mkdir \\yourserver\directory\UserBackups\$uname\AutomaticDestinations
mkdir \\yourserver\directory\UserBackups\$uname\ChromeBackup
mkdir \\yourserver\directory\UserBackups\$uname\EdgeBackup

$outputpath = '\\yourserver\directory\UserBackups' + "\$uname"


#Backup Remote User's profile
Copy-Item -Path "\\$compname\c$\Users\$uname\Desktop\*" -Destination "$outputpath\Desktop\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\Downloads\*" -Destination "$outputpath\Downloads\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\appdata\roaming\microsoft\signatures\*" -Destination "$outputpath\Signatures\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\Appdata\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\*" -Destination "$outputpath\AutomaticDestinations\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\Favorites\*" -Destination "$outputpath\Favorites\"-Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\AppData\Local\Google\Chrome\User Data\Default\Bookmarks" -Destination "$outputpath\ChromeBackup\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\AppData\Local\Google\Chrome\User Data\Default\Bookmarks.bak" -Destination "$outputpath\ChromeBackup\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks" -Destination "$outputpath\EdgeBackup\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks.bak" -Destination "$outputpath\EdgeBackup\" -Recurse
Copy-Item -Path "\\$compname\c$\Users\$uname\Pictures\*" -Destination "$outputpath\Pictures\" -Recurse

#Get list of all installed programs
$installed = Get-WmiObject -ComputerName $compname -Class Win32_Product | Select-Object Name,Vendor,Version

$installHTML = $installed | ConvertTo-HTML -As Table -Fragment

$Htmlbody = @" 
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
    Font-size: 34pt;
    font-family: Verdana, Arial;
}
h2 {
    text-align: left;
    color:#323a33;
    Font-size: 20pt;
}
h3 {
    text-align: center;
    color:#211b1c;
    Font-size: 15pt;
}
h4 {
    text-align: left;
    color:#2a2d2a;
    Font-size: 15pt;
}
h5 {
    text-align: center;
    color:#2a2d2a;
    Font-size: 12pt;
}
a:link {
    color:#0098e5;
    text-decoration: underline;
    cursor: auto;
    font-weight: 500;
}
a:visited {
    color:#05a3b7;
    text-decoration: underline;
    cursor: auto;
    font-weight: 500;
}
</style>
</head>
<body>
<h1>Remote Backup Installations</h1> 
<br><br>
Please ensure the following programs are installed to the new PC prior to it being issued to the user.
<br><br>
<h4>$compname, $uname</h4>
$installHTML




</body> 
</html> 
"@  

Send-MailMessage -To $mail -From "Hardware Backups <hwbackups@yourdomain.com>" -Subject "Backed Up Computer: $compname" -BodyAsHtml $Htmlbody -SmtpServer yourdomain-com.mail.protection.outlook.com
