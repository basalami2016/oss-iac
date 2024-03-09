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