param(
       # Getting the control percentage as an argument
       [int]$desiredCodeCoveragePercent = 95
)
Write-Host "Desired Code Coverage Percent is " -nonewline; Write-Host $desiredCodeCoveragePercent

# Copied from https://blogs.msdn.microsoft.com/tfssetup/2015/11/06/controlling-build-result-with-code-coverage-percentage-using-build-vnext/
 
# Setting a few values
[int]$coveredBlocks = 0
[int]$skippedBlocks = 0
[int]$totalBlocks = 0
[int]$codeCoveragePercent = 0
 
# Getting a few environment variables we need
[String]$buildID = "$env:BUILD_BUILDID"
[String]$project = "$env:SYSTEM_TEAMPROJECT"
 
# Setting up basic authentication 
$username = "eduardomhg@gmail.com"
$password = "aau7il3a2vpmgmkdaupze5lfksb7to4fdilvso4mrh2ok2ts5c4q"
 
$basicAuth = ("{0}:{1}" -f $username, $password)
$basicAuth = [System.Text.Encoding]::UTF8.GetBytes($basicAuth)
$basicAuth = [System.Convert]::ToBase64String($basicAuth)
$headers = @{Authorization=("Basic {0}" -f $basicAuth)}
 
$url = "https://imaginera.visualstudio.com/DefaultCollection/" + $project + "/_apis/test/codeCoverage?buildId=" + $buildID + "&flags=1&api-version=2.0-preview"
Write-Host $url
 
$responseBuild = (Invoke-RestMethod -Uri $url -Headers $headers -Method Get).value | Select modules
 
foreach ($module in $responseBuild.modules)
{
       $coveredBlocks += $module.statistics[0].blocksCovered
       $skippedBlocks += $module.statistics[0].blocksNotCovered
}
 
$totalBlocks = $coveredBlocks + $skippedBlocks;
if ($totalBlocks -eq 0)
{
       $codeCoveragePercent = 0
       Write-Host $codeCoveragePercent -nonewline; Write-Host " is the Code Coverage. Failing the build"
       exit -1 
}
 
$codeCoveragePercent = $coveredBlocks * 100.0 / $totalBlocks
Write-Host "Code Coverage percentage is " -nonewline; Write-Host $codeCoveragePercent
 
if ($codeCoveragePercent -le $desiredCodeCoveragePercent)
{
       Write-Host "Failing the build as CodeCoverage limit not met"
       exit -1
}
Write-Host "CodeCoverage limit met"