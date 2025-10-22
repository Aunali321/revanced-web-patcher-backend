@echo off
setlocal enabledelayedexpansion

set SCRIPT_DIR=%~dp0
set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
if exist "%SCRIPT_DIR%\bin" (
  set APP_DIR=%SCRIPT_DIR%
) else (
  for %%I in ("%SCRIPT_DIR%\..\dist\local") do set APP_DIR=%%~fI
)

if "%DATA_DIR%"=="" (
  for %%I in ("%APP_DIR%\data") do set DATA_DIR=%%~fI
)
if not exist "%DATA_DIR%" mkdir "%DATA_DIR%"

if "%PORT%"=="" set PORT=3000

pushd "%APP_DIR%"
call "%APP_DIR%\bin\web-patcher-service.bat" %*
popd
endlocal
