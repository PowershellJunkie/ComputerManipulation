#Define Variables
$compname = Read-Host "Enter the computer name or IP Address for restoration" 
$uname = Read-Host "Enter the user's Win2K name from Active Directory; aka the sAMAccountName"
$restoreinput = '\\nas\IT_DOC_SOFT\UserBackups' + "\$uname\"
$restoreoutput = '\\$compname\c$\Users\$uname'


#Restore User's Profile to new machine
Copy-Item -Path "$restoreinput\Desktop\*" -Destination "\\$compname\c$\Users\$uname\Desktop\" -Recurse -Force
Copy-Item -Path "$restoreinput\Downloads\*" -Destination "\\$compname\c$\Users\$uname\Downloads\" -Recurse -Force
Copy-Item -Path "$restoreinput\Favorites\*" -Destination "\\$compname\c$\Users\$uname\Favorites\" -Recurse -Force
Copy-Item -Path "$restoreinput\Signatures\*" -Destination "\\$compname\c$\Users\$uname\AppData\Roaming\Microsoft\Signatures\" -Recurse -Force
Copy-Item -Path "$restoreinput\AutomaticDestinations\*" -Destination "\\$compname\c$\Users\$uname\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations\" -Recurse -Force
Copy-Item -Path "\\nas\IT_DOC_SOFT\UserBackups\$uname\ChromeBackup\Bookmarks" -Destination "\\$compname\c$\Users\$uname\AppData\Local\Google\Chrome\User Data\Default\" -Recurse -Force
Copy-Item -Path "\\nas\IT_DOC_SOFT\UserBackups\$uname\ChromeBackup\Bookmarks.bak" -Destination "\\$compname\c$\Users\$uname\AppData\Local\Google\Chrome\User Data\Default\" -Recurse -Force
Copy-Item -Path "\\nas\IT_DOC_SOFT\UserBackups\$uname\EdgeBackup\Bookmarks" -Destination "\\$compname\c$\Users\$uname\AppData\Local\Microsoft\Edge\User Data\Default\" -Recurse -Force
Copy-Item -Path "\\nas\IT_DOC_SOFT\UserBackups\$uname\EdgeBackup\Bookmarks.bak" -Destination "\\$compname\c$\Users\$uname\AppData\Local\Microsoft\Edge\User Data\Default\" -Recurse -Force
Copy-Item -Path "\\nas\IT_DOC_SOFT\UserBackups\$uname\Pictures\" -Destination "$restoreoutput\Pictures\" -Recurse -Force
