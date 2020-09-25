@echo OFF
set USD_INSTALL_PATH=C:\USD\usd20

set PYTHONPATH=C:\Python36
set PATHSTORE=%PATH%
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%


set ARGS=-j 44 --ptex --embree --alembic --materialx --draco

set ARGS_PRMAN=--prman --prman-location "C:/Program Files/Pixar/RenderManProServer-23.4"

rem set ARGLIST=%ARGS% %ARGS_PRMAN% // replace following line if you have Renderman 23.4.
set ARGLIST=%ARGS%
@echo ON

python build_scripts\build_usd.py %ARGLIST% %USD_INSTALL_PATH%

@echo OFF
echo. & echo "The build has finished...hopefully! Please add USD_PATH=%USD_INSTALL_PATH% to your Environment Variables."
set PATH=%PATHSTORE%