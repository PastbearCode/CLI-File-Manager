param($p1)

$path1 = Get-Location
$path2 = $p1
$path = Join-Path $path1 $path2
$path = Join-Path $path ""

Write-Host $path

$runPath2 = Join-Path $PSScriptRoot "file-manager-cli.exe"
Start-Process $runPath2 $path