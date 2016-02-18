$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packageName = 'toad.mysql'
$installerType = 'exe'
$url = 'http://community-downloads.quest.com/toadsoft/MySQL/ToadforMySQL_Freeware_7.7.0.579.zip'
$url64 = $url 
$silentArgs = '/S'
$validExitCodes = @(0)

try {
  Install-ChocolateyZipPackage "$packageName" "$url" "$toolsDir" "$url64"

  $fileToInstall = Join-Path "$toolsDir" 'ToadforMySQL_Freeware_7.7.0.579.exe'

  Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" "$fileToInstall" -validExitCodes $validExitCodes

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}
