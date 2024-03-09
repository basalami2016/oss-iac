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

$m = New-Module -ScriptBlock {
  function Hello ($name) {
    Write-Output "Hello, $name"
    Write-Host "Hello, $name"
  }
  function Goodbye ($name) {
    Write-Output  "Goodbye, $name"             
  }
  function ReadData () {
    $data = @(
       'Zero'
       'One'
       'Two'
       'Three'             )
    foreach ($d in $data) { 
     try {
        Write-Verbose -Message "Attempting to perform some action on $d"            
        Write-Output $d
     }
     catch {
       Write-Warning -Message "Unable to connect to Computer: $d"
     }          
    }
  }
} -AsCustomObject
$m
$m | Get-Member
$m.goodbye("Jane")
$m.hello("Manoj")
$m.ReadData()