@echo off
REM Script to update all language files in assets/minecraft/lang from the template

setlocal enabledelayedexpansion

set "SOURCE_FILE=%~dp0en_us.json"
set "TARGET_DIR=%~dp0..\assets\minecraft\lang"

if not exist "%SOURCE_FILE%" (
    echo Error: Source file not found: %SOURCE_FILE%
    exit /b 1
)

if not exist "%TARGET_DIR%" (
    echo Error: Target directory not found: %TARGET_DIR%
    exit /b 1
)

echo Updating language files from %SOURCE_FILE%
echo Target directory: %TARGET_DIR%
echo.

REM Copy content to all JSON files in the target directory
for %%f in ("%TARGET_DIR%\*.json") do (
    echo Updating: %%~nxf
    copy /Y "%SOURCE_FILE%" "%%f" >nul
)

echo.
echo Language files updated successfully!
