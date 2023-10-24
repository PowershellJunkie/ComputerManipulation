# This is pretty straight forward. This script forces the local client to check in to your WSUS server. 
# This assumes you have deployed a group policy object(s) on your domain to force use of your WSUS server.
$updateSession = new-object -com "Microsoft.Update.Session"
$updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates
wuauclt /reportnow
