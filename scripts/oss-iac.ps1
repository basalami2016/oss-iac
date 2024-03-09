$m = New-Module -ScriptBlock {

  $url =  "https://dev.azure.com/niqflex-org/niqflex/_apis/wit/queries?api-version=7.1-preview.2"

  #Invoke-RestMethod -Uri $url | 
    #Format-Table -Property  [System.Title],

  $output = Invoke-RestMethod -Uri $url -Method Get -ContentType "application/json"  #-Headers $header 
  Write-Output $output.content
  $output.value | ForEach-Object {
        Write-Host $_.System.Title
  }

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