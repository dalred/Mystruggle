$source = 'https://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.18.tar.bz2'
$dest = 'C:\tempDan\linux-2.6.18.tar.bz2'
	
$webclient_DownloadProgressChanged = {
    param([object]$sender,[System.Net.DownloadProgressChangedEventArgs]$e)
    write-host $e.ProgressPercentage
	}
	
$webclient_DownloadFileCompleted = {
	    $labelProgress.Text = 'Download complete'
}
	
	
$webclient = New-Object -TypeName System.Net.WebClient
$webclient.add_DownloadProgressChanged([System.Net.DownloadProgressChangedEventHandler]$webclient_DownloadProgressChanged)
$webclient.add_DownloadFileCompleted($webclient_DownloadFileCompleted)
$webclient.DownloadFileAsync($source,$dest)
	
