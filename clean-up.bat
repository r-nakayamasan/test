@echo off
REM ============================================
REM Edge & Bob Data Cleanup Script
REM ============================================
REM Created: 2026-04-14
REM Description: Removes Microsoft Edge and Bob-related data
REM ============================================

setlocal enabledelayedexpansion

set TIMESTAMP=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%

echo.
echo [%TIMESTAMP%] Starting cleanup...

REM Check administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Not running with administrator privileges. Some operations may fail.
    pause
)

REM ============================================
REM 1. Terminate Microsoft Edge Process
REM ============================================
echo.
echo [1/6] Terminating Microsoft Edge process...

tasklist /FI "IMAGENAME eq msedge.exe" 2>NUL | find /I /N "msedge.exe">NUL
if "%ERRORLEVEL%"=="0" (
    taskkill /F /IM msedge.exe >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [SUCCESS] Microsoft Edge terminated
    ) else (
        echo   [ERROR] Failed to terminate Microsoft Edge
    )
) else (
    echo   [INFO] Microsoft Edge is not running
)

timeout /t 2 /nobreak >nul

REM ============================================
REM 2. Delete Edge User Data
REM ============================================
echo.
echo [2/6] Deleting Edge user data...

set EDGE_DATA="%LOCALAPPDATA%\Microsoft\Edge\User Data"
if exist %EDGE_DATA% (
    rmdir /S /Q %EDGE_DATA% >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [SUCCESS] Edge user data deleted
    ) else (
        echo   [ERROR] Failed to delete Edge user data
    )
) else (
    echo   [INFO] Edge user data does not exist
)

REM ============================================
REM 3. Delete Bob-related Data
REM ============================================
echo.
echo [3/6] Deleting Bob-related data...

set BOB_DIRS[0]="%USERPROFILE%\.bob"
set BOB_DIRS[1]="%LOCALAPPDATA%\.bobide"
set BOB_DIRS[2]="%LOCALAPPDATA%\.continue"
set BOB_DIRS[3]="%APPDATA%\IBM Bob"

for /L %%i in (0,1,3) do (
    set DIR=!BOB_DIRS[%%i]!
    if exist !DIR! (
        rmdir /S /Q !DIR! >nul 2>&1
        if !errorLevel! equ 0 (
            echo   [SUCCESS] Deleted !DIR!
        ) else (
            echo   [ERROR] Failed to delete !DIR!
        )
    ) else (
        echo   [INFO] !DIR! does not exist
    )
)

REM ============================================
REM 4. Clean Temporary Files
REM ============================================
echo.
echo [4/6] Cleaning temporary files...

del /F /Q "%TEMP%\*" >nul 2>&1
if !errorLevel! equ 0 (
    echo   [SUCCESS] Temporary files deleted
) else (
    echo   [WARNING] Some temporary files could not be deleted
)

REM ============================================
REM 5. Clear Recycle Bin
REM ============================================
echo.
echo [5/6] Clearing recycle bin...

powershell -NoProfile -Command "Clear-RecycleBin -Force" >nul 2>&1
if !errorLevel! equ 0 (
    echo   [SUCCESS] Recycle bin cleared
) else (
    echo   [WARNING] Failed to clear recycle bin
)

REM ============================================
REM 6. Complete
REM ============================================
echo.
echo [6/6] Cleanup completed
echo.
echo ============================================
echo All operations completed
echo ============================================
echo.

endlocal

pause

@REM Made with Bob
