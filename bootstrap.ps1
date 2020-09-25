
$curdir = $PSScriptRoot
$get_archives="${curdir}/build_scripts/get-archives.ps1"
&$get_archives

Write-Host "The project has been successfully bootstrapped. You can now build from source using the build scripts. 
The maya-usd project can be difficult to build.
You can optionally run the maya-usd installer located in:
'${curdir}/tmp/MayaUSD_0.4.0_Maya2020.2_Windows_202009170712_f92ca3f.exe'" -ForegroundColor green
