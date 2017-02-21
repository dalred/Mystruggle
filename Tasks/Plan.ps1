<#
Copyright ©Даниил Кузьмин,версия: 2017 Январь.По всем вопросам обращаться по почте:Dalred@mail.ru
Планирование задания.
#>
<#
How to get current dir script, when I used Register-ScheduledJob cmdlet? It is only by Param((
#>

$name="CryptoPs"
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
# $datenow=(get-date).AddSeconds(10)
$tm=New-JobTrigger -AtStartup -RandomDelay 00:10:00
$td=New-JobTrigger -Daily -At 09:00
$tn=New-JobTrigger -Daily -At 19:55

$o = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
Register-ScheduledJob -Name CryptoMorning -FilePath "$PSScriptRoot\$name.ps1" -ArgumentList ($PSScriptRoot) -Trigger $tm -ScheduledJobOption $o 
Register-ScheduledJob -Name CryptoDay -FilePath "$PSScriptRoot\$name.ps1" -ArgumentList ($PSScriptRoot) -Trigger $td -ScheduledJobOption $o 
Register-ScheduledJob -Name CryptoNight -FilePath "$PSScriptRoot\$name.ps1" -ArgumentList ($PSScriptRoot) -Trigger $tn -ScheduledJobOption $o 
