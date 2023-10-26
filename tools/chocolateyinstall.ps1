. .\variables.ps1

$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'MSI'
  url            = $url

  softwareName   = 'TimeXtender ODX [0-9][0-9][0-9][0-9]*'

  checksum       = $checksum
  checksumType   = 'sha256'

  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

$zipPath = Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath "$toolsDir\TimeXtender ODX Server.zip" -Url $url

Get-ChocolateyUnzip -FileFullPath $zipPath -Destination $toolsDir

$msiPath = Get-ChildItem -Path $toolsDir -Filter "TimeXtender ODX Server*.msi" | Sort-Object | Select-Object -Last 1

Install-ChocolateyInstallPackage -PackageName $env:ChocolateyPackageName -FileType $packageArgs.fileType -SilentArgs $packageArgs.silentArgs -File $msiPath.FullName
