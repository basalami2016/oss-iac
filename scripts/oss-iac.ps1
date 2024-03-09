<#
  https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.4
  run a script in the current directory .\Get-ServiceLog.ps1
  script with parameters .\Get-ServiceLog.ps1 -ServiceName WinRM
  scripts on other computers Invoke-Command -ComputerName Server01 -FilePath C:\Scripts\Get-ServiceLog.ps1
  Get help for scripts get-help C:\admin\scripts\ServicesLog.ps1
  Script scope and dot sourcing
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.4#script-scope-and-dot-sourcing
    dot sourcing: lets you run a script in the current scope instead of in the script scope
  Module https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7.4
#>

param ($ComputerName = $(throw "ComputerName parameter is required."))

function CanPing {
   $error.clear()
   $tmp = test-connection $computername -erroraction SilentlyContinue

if (!$?)
       {
        write-host "Ping failed: $ComputerName."; return $false
        write-host $tmp
       }
   else
       {
        write-host "Ping succeeded: $ComputerName"; return $true
        write-host $tmp
      }
}

function CanRemote {
    $s = new-pssession $computername -erroraction SilentlyContinue

if ($s -is [System.Management.Automation.Runspaces.PSSession])
        {write-host "Remote test succeeded: $ComputerName."}
    else
        {write-host "Remote test failed: $ComputerName."}
}

if (CanPing $computername) {CanRemote $computername}
