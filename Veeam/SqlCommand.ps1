Param (
[string]$configPath,
[string]$sqlPath
)

#region Property
$PropertyErrorText = @{
	ForegroundColor = "White";
	BackgroundColor = "Red";
}
$PropertyinfoText = @{
	ForegroundColor = "White";
	BackgroundColor = "Blue";
}
#endregion
<# Креды для запуска в Trustеd, но из под другого пользователя.
$global:username = ""
$global:password = ""
$sec_password = ConvertTo-SecureString -String $password -AsPlainText -Force
$creds = New-Object -Typename System.Management.Automation.PSCredential -ArgumentList $username, $sec_password
#>


<#Определение Instance на всякий случай
$Instance=([System.Data.Sql.SqlDataSourceEnumerator]::Instance.GetDataSources()|?{$_.ServerName -eq $env:COMPUTERNAME})
#>


<#
Ну не знаю, обычно формат config что-то типо этого.
<connectionStrings>
  <add 
    name="MyConnectionString" 
    connectionString="Data Source=sergio-desktop\sqlexpress;Initial 
    Catalog=MyDatabase;User ID=userName;Password=password"
    providerName="System.Data.SqlClient"
  />
</connectionStrings>
#>



#$ConnectionString ="Server=.\SQLEXPRESS;Database=master;user=User;Password=123;Connect Timeout=5"


Function GenericSqlQuery {
param($SQLQuery)
				$Datatable = New-Object System.Data.DataTable
				$Connection = New-Object System.Data.SQLClient.SQLConnection
				$Connection.ConnectionString = $ConnectionString
				try
				{
					$connection.Open()
				}
				catch [System.Data.SqlClient.SqlException]
				{
					throw "Невозможно открыть соединение."
					break
				}
				$handler = {
					param ([object]$sender,
						[System.Data.SqlClient.SqlInfoMessageEventArgs]$Global:event)
                    Write-Host "Инфо месседж: "$event.Message @PropertyinfoText;    
					throw "Неправильный синтаксис!" #Throw месседж в Handler не попадает к сожалению, не знал.
				};
				$connection.add_InfoMessage([System.Data.SqlClient.SqlInfoMessageEventHandler]$handler);
				$connection.FireInfoMessageEventOnUserErrors = $true;
				$Command = New-Object System.Data.SQLClient.SQLCommand
				$Command.Connection = $Connection
				$Command.CommandText = $SQLQuery
                try {
				$DataAdapter = new-object System.Data.SqlClient.SqlDataAdapter $Command
                $DataAdapter.SelectCommand.CommandTimeout=600
				$Dataset = new-object System.Data.Dataset
				[void]$DataAdapter.Fill($Dataset) #Потому что хотим, потом работать с этими данными.
				return $Dataset.tables[0]
                }
                catch{
                throw "ERROR:Невозможно выполнить запрос:$SQLQuery $Error[0]"
                }
                Finally {
                $Connection.close()
                }
}

try
{
If ($configPath -and $sqlPath) {
    if ((Test-Path -Path $sqlPath ) -and (Test-Path -Path $configPath)) {
        $SQLQuery=Get-Content $sqlPath
        [array]$str=Get-Content $configPath
        } else {
            throw "Один из путей к файлу указан неверно!"
        }
} else {
    throw "Ошибка ошибок!"
}


$str2=$str| where{$_ -match "Database" -or $_ -match "User"} 
$str=$str|Select-String "instanceName","server"
$server=($str -split "=")[2]+"="+($str -split "=")[3]+"\"+($str -split "=")[1] -Replace("`"","")
$str2=[string]$str2 -replace("[`"]","") -replace("\s",";") -replace("userPwd","Password") -replace ("userName","user")
[string]$ConnectionString=$server+"`;"+$str2  

GenericSqlQuery -SQLQuery $SQLQuery
}
catch
{[system.exception]|Out-Null
    $ErrorMessage = $_.Exception.Message
	if ($ErrorMessage)
	{
		Write-Host  "Error: "$_.Exception.Message @PropertyErrorText
		break
	}
	
}finally {
    Write-Host "Завершил запрос!"
}
