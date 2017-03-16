PowerShell: Working With TaskDefinition object
I'm trying to change scheduled tasks through powershell. You can retrieve a list of running tasks on local or remote servers using the COM object Schedule.Service. After connecting to the scheduler service on the remote server using the Connect() method.
>Scripting object that defines all the components of a task.
https://msdn.microsoft.com/en-us/library/windows/desktop/aa382542(v=vs.85).aspx
You then define the properties for the new task and register
the task. Properties for the new task include the Actions, Data, Principal, RegistrationInfo, Settings, Triggers, and XmlText. Of these properties, Data and XmlText are optional.

So navigate to the Tasks folder, which that contains script to resolve problems with creation Tasks.
###Background Jobs
>Use an existing interactive token to run a task. The user must log on using a service for user (S4U) logon.
When an S4U logon is used, no password is stored by the system and there is no access to either the network or encrypted files.
