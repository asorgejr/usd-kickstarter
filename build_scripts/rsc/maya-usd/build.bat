@echo OFF
rem // MAYA USD PLUGIN
rem //set this to your Maya Install Path.
set MAYA_INSTALL_DIR=C:\Program Files\Autodesk\Maya2020

rem //set this to your Maya devkit folder: https://www.autodesk.com/developer-network/platform-technologies/maya
set MAYA_DEVKIT=D:\SDK\devkitBase



rem // DO NOT MODIFY BELOW THIS POINT

set PYTHONPATH=C:\Python27
set PATHSTORE=%PATH%
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;%PATH%


set REL_USD_PARENT_DIR=%USD_ROOT%\..
set USD_PARENT_DIR=
rem // Save current directory and change to target directory
pushd %REL_USD_PARENT_DIR%
rem // Save value of CD variable (current directory)
set USD_PARENT_DIR=%CD%
rem // Restore original directory
popd


set INSTALL_DIR=%USD_PARENT_DIR%\maya-usd
set PXR_USD_LOCATION=%USD_ROOT%
set USD_INCLUDE_DIR=%INSTALL_DIR%\include
set USD_LIBRARY_DIR=%INSTALL_DIR%\lib

set BOOST_ROOT=%USD_ROOT%
set BOOST_INCLUDEDIR=%BOOST_ROOT%\include
set BOOST_LIBRARYDIR=%BOOST_ROOT%\lib


set ARGS=--generator Ninja -v 3 -j 44
set ARGS_MAYA=--maya-location "%MAYA_INSTALL_DIR%"
set ARGS_USD=--pxrusd-location "%PXR_USD_LOCATION%"
set ARGS_DEV=--devkit-location "%MAYA_DEVKIT%"
rem // Compilation will error out if -DBUILD_TESTS=OFF is set. Tests must be built.
rem // Documentation recommends -DBUILD_PXR_PLUGIN=OFF, but this is erroneous. Linker errors will occur, so the obsolete plugin must be built.
set BUILD_ARGS=--stages=configure,build,install --build-args="-DCMAKE_BUILD_TYPE=RelwithDebInfo,-DBUILD_ADSK_PLUGIN=ON"

set ARGS_LIST=%ARGS% %ARGS_MAYA% %ARGS_DEV% %ARGS_USD%
@echo ON

py -2 ../build.py --install-location %INSTALL_DIR% %ARGS_LIST% %BUILD_ARGS% %INSTALL_DIR%

@echo OFF
set PATH=%PATHSTORE%
set PYTHONPATH=
echo.
echo Build is now complete. Installed to : "%INSTALL_DIR%"
echo.
echo IMPORTANT NOTE: Please add "%INSTALL_DIR%" to your MAYA_MODULE_PATH environment variable. i.e.: MAYA_MODULE_PATH="C:\Program Files\Common Files\Autodesk Shared\Modules\maya;%INSTALL_DIR%"
echo.