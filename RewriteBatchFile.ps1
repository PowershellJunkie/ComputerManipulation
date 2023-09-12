$file = "\\yourpath\directory\filename.bat"
If(!($file)){
New-Item $file
}
Set-Content $file '

All of your batchfile code content within these single quotations

'
