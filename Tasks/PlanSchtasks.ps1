<#
Copyright ©Даниил Кузьмин,версия: 2017 Январь.По всем вопросам обращаться по почте:Dalred@mail.ru;Daniil.Kuzmin@maykor.com
Планирование задания.Собираем свой настраиваемый план.
#>
[Console]::outputEncoding = [System.Text.Encoding]::GetEncoding('cp866')
$name="CryptoPs"
SCHTASKS /Create /tr "powershell.exe -NoLogo -NonInteractive -WindowStyle Hidden -File $PSScriptRoot\$name.ps1" /TN $name /SC ONSTART /RL HIGHEST /DELAY 0010:00
$R=schtasks /Query /XML /TN $name | ? {$_.trim() -ne "" } 
    $xml = [xml] $R
    $xml.Task.RemoveAttribute("xmlns");
    $newRepetition = $xml.task.Triggers.BootTrigger.AppendChild($xml.CreateElement("Repetition", $xml.DocumentElement.NamespaceURI));
    $newXmlNameElement=$newRepetition.AppendChild($xml.CreateElement("Interval", $xml.DocumentElement.NamespaceURI))
    $newXmlNameTextNode = $newXmlNameElement.AppendChild($xml.CreateTextNode("PT1H"))
    $newXmlDuration=$newRepetition.AppendChild($xml.CreateElement("Duration", $xml.DocumentElement.NamespaceURI))
    $newXmlDurationTextNode = $newXmlDuration.AppendChild($xml.CreateTextNode("P1D"))
    $xml.Task.Principals.Principal.LogonType="S4U"
    $xml.Task.Settings.DisallowStartIfOnBatteries="false"
    $xml.Task.Settings.StopIfGoingOnBatteries="false"
    $xml.Task.Actions.Exec.SetAttribute("id","StartPowerShellJob")
    $xml.Save("$PSScriptRoot\$name.xml")
SCHTASKS /Delete /TN "$name" /F 
schtasks /Create /XML $PSScriptRoot\$name.xml /tn "Microsoft\Windows\PowerShell\ScheduledJobs\$name"
Remove-Item "$PSScriptRoot\$name.xml"
