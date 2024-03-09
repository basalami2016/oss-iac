param (
    [Parameter(Mandatory = $true)][String]$pipelineName
    # send parameters as a json serialized string
    #[Parameter][String]$pipelineParameters
)

$auth = "Bearer $env:System_AccessToken"
$baseUri = "$($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)$env:SYSTEM_TEAMPROJECTID/";
$headers = @{Authorization = $auth };

Write-Host "baseUrl $($baseUri)"

# Getting pipeline definitions that match with the pipeline name
$definitions = Invoke-RestMethod -Uri "$($baseUri)_apis/build/definitions?name=$(${pipelineName})" -Method Get -ContentType "application/json" -Headers $headers;

if (-Not ($definitions -and $definitions.count -eq 1)) {
    Write-Error "Problem occured while getting the build"
    exit 1;
}

$specificUri = $definitions.value[0].url

# Getting the pipeline definition
$definition = Invoke-RestMethod -Uri $specificUri -Method Get -ContentType "application/json" -Headers $headers;

if (-Not $definition) {
    Write-Error "The Build definition could not be found."
    exit 2;
}

$build = New-Object PSObject -Property @{
    definition = New-Object PSObject -Property @{
        id = $definition.id
        #parameters = $pipelineParameters
    }
    reason = "userCreated"
}

$jsonbody = $build | ConvertTo-Json -Depth 100

try {
    # trigger the pipeline
    $result = Invoke-RestMethod -Uri "$($baseUri)_apis/build/builds?api-version=5.0-preview.5" -Method Post -ContentType "application/json" -Headers $headers -Body $jsonbody;
}
catch {
    if ($_.ErrorDetails.Message) {

        $errorObject = $_.ErrorDetails.Message | ConvertFrom-Json

        foreach ($validationError in $errorObject.customProperties.ValidationResults) {
            Write-Warning $validationError.message
        }
        Write-Error $errorObject.message
    }

    throw $_.Exception
}

Write-Host "Triggered Build: $($result.buildnumber)"