if (-not (Test-Path env:USD_ROOT)) { 
    Write-Warning -Message "Environment variable USD_ROOT is not set. Please set USD_ROOT to the USD installation directory (i.e: C:\USD)."
    $env:USD_ROOT = 'C:\USD'
    exit
}
$usd_root="${env:USD_ROOT}"

rm -Force "${usd_root}/build/boost*"
rm -Force "${usd_root}/include/boost*"
rm -Force "${usd_root}/lib/boost*"
rm -Force "${usd_root}/share/boost*"
rm -Force "${usd_root}/src/boost*"
