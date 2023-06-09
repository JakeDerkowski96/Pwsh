If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

        [Security.Principal.WindowsBuiltInRole] “Administrator”))
{

    Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”

    Break

}




# https://devblogs.microsoft.com/scripting/check-for-admin-credentials-in-a-powershell-script/

$admincheck = Test-IsAdmin

If ($admincheck -is [System.Management.Automation.PSCredential])
{

    Start-Process -FilePath PowerShell.exe -Credential $admincheck -ArgumentList $myinvocation.mycommand.definition

    Break

}
