. .\tools\variables.ps1

$tmp = New-TemporaryFile
Invoke-WebRequest -Uri $url -OutFile $tmp
$new_hash = (Get-FileHash -Algorithm SHA256 -Path $tmp).Hash

#$checksum
#$new_hash

if ($new_hash -ne $checksum) {

    $scriptfile = 'tools\variables.ps1'
    $nuspecfile = 'timextender-odx.nuspec'

    (Get-Content $scriptfile) -replace "'$($checksum)'", "'$($new_hash)'" | Set-Content $scriptfile
    
    $FileList = Expand-Archive -PassThru -DestinationPath $tmp.DirectoryName -Path $tmp -Force 

    $installername = ($FileList | Where-Object { $_ -like "*.msi" }).Name

    $installername -match "TimeXtender ODX Server (\d{4}\.\d)"

    $version = $Matches.1

    $xmldata = [xml] (Get-Content $nuspecfile)

    $xmldata.package.metadata.version = $version

    $xmldata.Save($nuspecfile)

    Remove-Item '*.nupkg'

    choco pack

    choco push --source "https://push.chocolatey.org/"

    git add .

    git commit -m "new version: $version"

    git push
}
else {
    "hashes match, no action required"
}