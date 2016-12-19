param(
       [string][Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()] $extensionManifestFilePath
)

Write-Host "Build number is $env:BUILD_BUILDNUMBER"

Write-Host "Publishing package from $extensionManifestFilePath..."

tfx extension create --manifest-globs $extensionManifestFilePath

exit $LASTEXITCODE
