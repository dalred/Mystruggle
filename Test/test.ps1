[void][reflection.assembly]::Load('System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
$source = 'https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.tar.bz2'
$dest = 'C:\tempDan\linux-2.6.18.tar.bz2'

$webclient_DownloadProgressChanged = {
param([object]$sender,[System.Net.DownloadProgressChangedEventArgs]$e)
    write-host $e.ProgressPercentage
}
	
$webclient_DownloadFileCompleted = {
    Write-Host Завершено
}
	
$webclient = New-Object -TypeName System.Net.WebClient
$webclient.add_DownloadProgressChanged([System.Net.DownloadProgressChangedEventHandler]$webclient_DownloadProgressChanged)
$webclient.add_DownloadFileCompleted([System.Net.AsyncCompletedEventHandler]$webclient_DownloadFileCompleted)
$webclient.DownloadFileAsync($source,$dest)
	
