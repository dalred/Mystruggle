<#
Copyright ©Даниил Кузьмин,версия: 2017 Январь.По всем вопросам обращаться по почте:Daniil.Kuzmin@maykor.com
#>
<#
How to get current dir script, when I used Register-ScheduledJob cmdlet? It is only by Param((
#>
Param(
    [String]$curDir
)

$myobject=@()
#$curDir=$PSScriptRoot
$date1=(Get-Date).ToString('dd.MM.yyyy')

IF ((Test-Path $curDir\log) -ne "True") {
New-Item  $curDir\log -type directory
}

function Service  ($Pr) 
{
    $name=[Environment]::UserName
    $R=Get-Service zCSSVC
    $date=(Get-Date).ToString("dd.MM.yyyy HH:mm:ss")
    $script:MyVar=$R.Status
    $Pechat=$date+" "+$name+": "+$Pr+$R.DisplayName+" "+"Статус: "+ $R.Status|Out-File -Append "$curDir\log\$date1.txt"
}

Service "Видит: "
IF ($MyVar -ne "Running")
{
    $EventSys=Get-EventLog -LogName System -After (Get-Date).AddMinutes(-20)
    $EventApp=Get-EventLog -LogName Application -After (Get-Date).AddMinutes(-20)

    Foreach ($EventsysElement in $EventSys) 
    { 
        $properties = @{
        Время=$EventsysElement.TimeWritten;
        Сообщение=$EventsysElement.Message;
        Источник="Системный журнал:";
        }
        $myobject+=new-object psobject -property $properties
    }

    Foreach ($EventAppElement in $EventApp) 
    { 
        $properties2 = @{
        Время=$EventAppElement.TimeWritten;
        Сообщение=$EventAppElement.Message;
        Источник="Журнал приложений:"
        }
        $myobject+=new-object psobject -property $properties2

    }
    "События за 20 минут до остановки!"|Out-File -Append "$curDir\log\$date1.txt"
    $myobject|Sort-Object -Property "Время"|foreach {$_.Время.tostring()+" "+$_.Источник.tostring()+" "+$_.Сообщение.tostring()}|Out-File -Append "$curDir\log\$date1.txt"
    Start-Service -name zCSSVC
    Start-Sleep -Milliseconds 1000
Service "Принудительно запускает(скрипт)- "
}
