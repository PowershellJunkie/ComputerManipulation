$path = ""
$files = Get-ChildItem $path
$time = (Get-Date).AddDays(-(30))

$delfiles = $files | ?{$_.LastWriteTime -le $time}

ForEach($file in $delfiles){

Remove-Item -Path $file.FullName -Force

}
