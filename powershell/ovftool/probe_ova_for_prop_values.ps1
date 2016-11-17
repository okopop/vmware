# Probe ova file for prop values
# Mattias Ukusic 2016

$OVTOOL_PATH="C:\ovftool.exe"

$ova = Read-Host -Prompt 'Enter ova file name path'

& $OVTOOL_PATH $ova

$HOST.UI.RawUI.ReadKey(“NoEcho,IncludeKeyDown”) | OUT-NULL
$HOST.UI.RawUI.Flushinputbuffer()
