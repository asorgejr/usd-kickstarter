@echo OFF
set USD_INSTALL_PATH=C:\USD\usd20

set PYTHONPATH=C:\Python27
set PATHSTORE=%PATH%
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%

set BUILD_ARGS=--build-args boost,"--with-date_time --with-thread --with-system --with-filesystem --with-python"

set ARGS=-j 44 --ptex --embree --alembic --materialx --draco

set ARGS_PRMAN=--prman --prman-location "%RMANTREE%"

rem set ARGLIST=%ARGS% %BUILD_ARGS% %ARGS_PRMAN% // replace following line if you have Renderman 23.4.
set ARGLIST=%ARGS% %BUILD_ARGS%
@echo ON

python build_usd.py %ARGLIST% %USD_INSTALL_PATH%

@echo OFF
echo. & echo "The build has finished...hopefully! Please add USD_PATH=%USD_INSTALL_PATH% to your Environment Variables."
set PATH=%PATHSTORE%