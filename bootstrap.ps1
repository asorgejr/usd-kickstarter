
$curdir = $PSScriptRoot

$get_archives="${curdir}/build_scripts/get-archives.ps1"
. $get_archives

Write-Host "The project has been successfully bootstrapped. You can now build from source using the build scripts. 
The maya-usd project can be difficult to build.
You can optionally run the maya-usd installer located in:
'${curdir}/tmp/${maya_usd_exe_name}'" -ForegroundColor green
