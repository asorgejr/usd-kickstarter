
function Expand-Tar($tarFile, $dest, [string]$rename=$null) {
    if (-not (Get-Command Expand-7Zip -ErrorAction Ignore)) {
        Install-Module -Name 7Zip4Powershell > $null
    }
    if ($rename) {
        $tempdir = "${dest}/.extract_temp"
        $outpath = "${dest}/${rename}"
        Expand-7Zip -ArchiveFileName $tarFile -TargetPath "${tempdir}"
        $result = Get-ChildItem -Path "${tempdir}/*" -directory
        Move-Item -Path "${result}" -Destination "${outpath}"
        Remove-Item -Path "${tempdir}" -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Expand-7Zip -ArchiveFileName $tarFile -TargetPath $dest
    }
}


# VARIABLES
$curdir="$PSScriptRoot"
$projdir=$curdir+"/.."
$tmpdirname="tmp"
$src_dir_name="src"
$usd_src_dirname = "USD-20.08"
$usd_subarchive_name="usd-v20.08.tar"
$usd_archive_name="${usd_subarchive_name}.gz"
$maya_usd_dir_name="maya-usd"
$maya_usd_src_name="MayaUSD_dev"
$maya_usd_subarch_name="${maya_usd_src_name}.tar"
$maya_usd_archname="${maya_usd_subarch_name}.gz"
$maya_usd_exe_name="MayaUSD_0.4.0_Maya2020.2_Windows_202009170712_f92ca3f.exe"


# CHECK FOR ARCHIVE DL FOLDER
$tmpdirexists = Test-Path "${projdir}/${tmpdirname}"
if($tmpdirexists -ne $true) {
    New-Item -Path "${projdir}" -ItemType "directory" -Name "${tmpdirname}"
}
$tmpdir=Get-Item -Path "${projdir}/${tmpdirname}"
$usdarchexists = Test-Path "${tmpdir}/${usd_archive_name}"


# DL ARCHIVES IF NOT PRESENT
#USD ARCHIVE
if ($usdarchexists -ne $true) {
    Invoke-RestMethod -Uri https://github.com/PixarAnimationStudios/USD/archive/v20.08.tar.gz -Method Get -OutFile "${tmpdir}/${usd_archive_name}"
}
#MAYA USD ARCHIVES
$mayausdexeexists = Test-Path "${tmpdir}/${maya_usd_exe_name}"
if ($mayausdexeexists -ne $true) {
    Invoke-RestMethod -Uri https://github.com/Autodesk/maya-usd/releases/download/v0.4.0/MayaUSD_0.4.0_Maya2020.2_Windows_202009170712_f92ca3f.exe -Method Get -OutFile "${tmpdir}/${maya_usd_exe_name}"
}
$mayausdarchexists = Test-Path "${tmpdir}/${maya_usd_archname}"
if($mayausdarchexists -ne $true) {
    # Invoke-RestMethod -Uri https://github.com/Autodesk/maya-usd/archive/v0.4.0.tar.gz -Method Get -OutFile "${tmpdir}/${maya_usd_archname}"
    Invoke-RestMethod -Uri https://github.com/Autodesk/maya-usd/tarball/dev -Method Get -OutFile "${tmpdir}/${maya_usd_archname}"
}


#FIND USD DIR
$usdarchive = Get-Item -Path "${tmpdir}/${usd_archive_name}"
$usd_extract = "${projdir}/${src_dir_name}"
$usdextrexists = Test-Path "${usd_extract}"
#CREATE IF NOT PRESENT
if ($usdextrexists -ne $true) {
    Expand-Tar -tarFile "${usdarchive}" -dest "${usd_extract}"
    # Remove-Item -Path "${projdir}/${tmpdir}" -Recurse -Force -ErrorAction SilentlyContinue # TODO: fix.
}

#FIND USD SRC DIR
$usd_src_path = "${usd_extract}/${usd_src_dirname}"
$usdsrcexists = Test-Path "${usd_src_path}"
#CREATE IF NOT PRESENT OR ARCHIVE NOT EXTRACTED
if ($usdsrcexists -ne $true) {
    $usdsubarchexists = Test-Path "${usd_extract}/${usd_subarchive_name}"
    if ($usdsubarchexists -ne $true) {
        Expand-Tar -tarFile "${usdarchive}" -dest "${usd_extract}"
    }
    Expand-Tar -tarFile "${usd_extract}/${usd_subarchive_name}" -dest "${usd_extract}"
    Remove-Item -Path "${usd_extract}/${usd_subarchive_name}" -Recurse -Force -ErrorAction SilentlyContinue
}


#COPY BUILD SCRIPTS TO USD SRC DIR
$scripts_rsc_path="${curdir}/rsc/usd"
$bld_py = Get-Item -Path "${scripts_rsc_path}/build_usd.py"
$bld_py_content = Get-Content -Path $bld_py -Encoding "utf8" -Raw
Set-Content -Path "${usd_src_path}/build_scripts/build_usd.py" -Value("${bld_py_content}") -Encoding "utf8"

$bld_bats = Get-ChildItem -Path "${scripts_rsc_path}/*.bat"
foreach ($bldscr in $bld_bats) {
    $bldscr_content = Get-Content -Path $bldscr -Encoding "utf8" -Raw
    $bldscr_name = $bldscr.Name
    Out-File -FilePath "${usd_src_path}/build_scripts/${bldscr_name}" -InputObject "${bldscr_content}" -Encoding "utf8"
}



# MAYA USD
$mayausdarchive = Get-Item -Path "${tmpdir}/${maya_usd_archname}"
$mayausd_extract = "${projdir}/${src_dir_name}"
$mayausdextrexists = Test-Path "${mayausd_extract}"
#CREATE IF NOT PRESENT
if ($mayausdextrexists -ne $true) {
    Expand-Tar -tarFile "${mayausdarchive}" "${mayausd_extract}"
    # Remove-Item -Path "${projdir}/${tmpdir}" -Recurse -Force -ErrorAction SilentlyContinue # TODO: fix.
}
#FIND MAYA-USD SRC DIR
$mayausd_src_path = "${mayausd_extract}/${maya_usd_dir_name}"
$mayausdsrcexists = Test-Path "${mayausd_src_path}"
#CREATE IF NOT PRESENT OR ARCHIVE NOT EXTRACTED
if ($mayausdsrcexists -ne $true) {
    $mayausdsubarchexists = Test-Path "${mayausd_extract}/${maya_usd_subarch_name}"
    if ($mayausdsubarchexists -ne $true) {
        Expand-Tar "${mayausdarchive}" "${mayausd_extract}"
    }
    Expand-Tar "${mayausd_extract}/${maya_usd_subarch_name}" -dest "${mayausd_extract}" -rename "${maya_usd_dir_name}"
    Remove-Item -Path "${mayausd_extract}/${maya_usd_subarch_name}" -Recurse -Force -ErrorAction SilentlyContinue
}


#COPY BUILD SCRIPTS TO MAYA-USD SRC DIR
$scripts_rsc_path="${curdir}/rsc/maya-usd"

$bld_bats = Get-ChildItem -Path "${scripts_rsc_path}/*.bat"
$bldscriptdirexists = Test-Path "${mayausd_src_path}/build_scripts"
if ($bldscriptdirexists -ne $true) {
    New-Item -Path "${mayausd_src_path}" -Name "build_scripts" -ItemType directory
}
foreach ($bldscr in $bld_bats) {
    $bldscr_content = Get-Content -Path $bldscr -Encoding "utf8" -Raw
    $bldscr_name = $bldscr.Name
    Out-File -FilePath "${mayausd_src_path}/build_scripts/${bldscr_name}" -InputObject "${bldscr_content}" -Encoding "utf8"
}

$Global:maya_usd_installer = "${maya_usd_exe_name}"