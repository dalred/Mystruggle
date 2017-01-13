<#
Copyright ©Даниил Кузьмин,версия: 2017 Январь.По всем вопросам обращаться по почте:Dalred@mail.ru
How to get current dir script, when I used Register-ScheduledJob cmdlet? It is only by Param((
#>
Param(
    [String]$curDir
)
$myobject=@()
$myobject2=@()
$myobject3=@()
#$curDir=$PSScriptRoot
$date1=(Get-Date).ToString('dd.MM.yyyy')
$EventSys=Get-EventLog -LogName System -After (Get-Date).AddMinutes(-20)
$EventApp=Get-EventLog -LogName Application -After (Get-Date).AddMinutes(-20)
$EventDown=Get-EventLog -LogName System  -Source USER32 -After (Get-Date).AddMinutes(-20)| 
where { @(1076,1074) -contains ($_.InstanceId -bAnd 0xFFFF) }


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

Foreach ($EventDownElement in  $EventDown) 
{ 
    If (($EventDownElement.Message -like "*Выключение питания*") -and ($EventDownElement.Message -ne $null))
        {
            $properties3 = @{
            Время=$EventDownElement.TimeWritten;
            Сообщение="Выключение питания"
            Источник="Системный журнал:"
            }
            $myobject3+=new-object psobject -property $properties3
        }
    If (($EventDownElement.Message -like "*Перезапустить*") -and ($EventDownElement.Message -ne $null))      
    {
            $properties4 = @{
            Время=$EventDownElement.TimeWritten;
            Сообщение="Перезагрузка"
            Источник="Системный журнал:"
            }
            $myobject3+=new-object psobject -property $properties4
     }
}
$myobject3|Sort-Object -Property "Время"|foreach {$_.Время.tostring()+" "+$_.Источник.tostring()+" "+$_.Сообщение.tostring()}|Out-File -Append "$curDir\log\$date1.txt"

Service "Видит: "
IF ($MyVar -ne "Running")
{
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
    "`t"+"События за 20 минут до остановки!"|Out-File -Append "$curDir\log\$date1.txt"
    $myobject|Sort-Object -Property "Время" -Unique|foreach {$_.Время.tostring()+" "+$_.Источник.tostring()+" "+$_.Сообщение.tostring()}|Out-File -Append "$curDir\log\$date1.txt"
    Start-Service -name zCSSVC
    Start-Sleep -Milliseconds 1000
Service "Принудительно запускает(скрипт)- "
} else {
$EventSys=Get-EventLog -LogName System -Source "Service Control Manager" -Message "*CryptoServer Service*" -After (Get-Date).AddMinutes(-20)
    If ($EventSys -ne $null)
    {
        Foreach ($EventsysElement in $EventSys) 
        { 
            $properties = @{
            Время=$EventsysElement.TimeWritten;
            Сообщение=$EventsysElement.Message;
            Источник="Системный журнал:";
            }
        $myobject2+=new-object psobject -property $properties
        }
    "`t"+"События которые происходили со службой последние 20 минут в случае ее запуска!"|Out-File -Append "$curDir\log\$date1.txt"
    $myobject2| Sort-Object -Property "Время" -Unique|where { $_.Сообщение -like "*CryptoServer Service*"}| foreach {"`t"+$_.Время.tostring()+" "+$_.Источник.tostring()+" "+$_.Сообщение.tostring()}|Out-File -Append "$curDir\log\$date1.txt"
    }
}
Exit 
 
