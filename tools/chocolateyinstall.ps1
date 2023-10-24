
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://ftp-2.hostedftp.com/~timextender/TimeXtender+SaaS/TimeXtender ODX Server.zip'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'MSI'
  url            = $url

  softwareName   = 'TimeXtender ODX [0-9][0-9][0-9][0-9]*'

  checksum       = '4A7A993E7DDD6D97FB176B425B371C1C5685E01E9C3FB439692AA170DB08BAFA'
  checksumType   = 'sha256'

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

$zipPath = Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath "$toolsDir\TimeXtender ODX Server.zip" -Url $url

Get-ChocolateyUnzip -FileFullPath $zipPath -Destination $toolsDir

$msiPath = Get-ChildItem -Path $toolsDir -Filter "TimeXtender ODX Server*.msi" | Sort-Object | Select-Object -Last 1

Install-ChocolateyInstallPackage -PackageName $env:ChocolateyPackageName -FileType $packageArgs.fileType -SilentArgs $packageArgs.silentArgs -File $msiPath.FullName
