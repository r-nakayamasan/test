@echo off
REM ============================================
REM Edge & Bob関連データクリーンアップスクリプト
REM ============================================
REM 作成日: 2026-04-14
REM 説明: Microsoft EdgeとBob関連のデータを削除します
REM ============================================

setlocal enabledelayedexpansion

set TIMESTAMP=%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2%

echo.
echo [%TIMESTAMP%] クリーンアップを開始します...

REM 管理者権限チェック
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [警告] 管理者権限で実行されていません。一部の操作が失敗する可能性があります。
    pause
)

REM ============================================
REM 1. Microsoft Edge プロセスの終了
REM ============================================
echo.
echo [1/6] Microsoft Edge プロセスを終了しています...

tasklist /FI "IMAGENAME eq msedge.exe" 2>NUL | find /I /N "msedge.exe">NUL
if "%ERRORLEVEL%"=="0" (
    taskkill /F /IM msedge.exe >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [成功] Microsoft Edge を終了しました
    ) else (
        echo   [エラー] Microsoft Edge の終了に失敗しました
    )
) else (
    echo   [情報] Microsoft Edge は実行されていません
)

timeout /t 2 /nobreak >nul

REM ============================================
REM 2. Edge ユーザーデータの削除
REM ============================================
echo.
echo [2/6] Edge ユーザーデータを削除しています...

set EDGE_DATA="%LOCALAPPDATA%\Microsoft\Edge\User Data"
if exist %EDGE_DATA% (
    rmdir /S /Q %EDGE_DATA% >nul 2>&1
    if !errorLevel! equ 0 (
        echo   [成功] Edge ユーザーデータを削除しました
    ) else (
        echo   [エラー] Edge ユーザーデータの削除に失敗しました
    )
) else (
    echo   [情報] Edge ユーザーデータは存在しません
)

REM ============================================
REM 3. Bob関連データの削除
REM ============================================
echo.
echo [3/6] Bob関連データを削除しています...

set BOB_DIRS[0]="%USERPROFILE%\.bob"
set BOB_DIRS[1]="%LOCALAPPDATA%\.bobide"
set BOB_DIRS[2]="%LOCALAPPDATA%\.continue"
set BOB_DIRS[3]="%APPDATA%\IBM Bob"

for /L %%i in (0,1,3) do (
    set DIR=!BOB_DIRS[%%i]!
    if exist !DIR! (
        rmdir /S /Q !DIR! >nul 2>&1
        if !errorLevel! equ 0 (
            echo   [成功] !DIR! を削除しました
        ) else (
            echo   [エラー] !DIR! の削除に失敗しました
        )
    ) else (
        echo   [情報] !DIR! は存在しません
    )
)

REM ============================================
REM 4. 一時ファイルのクリーンアップ
REM ============================================
echo.
echo [4/6] 一時ファイルをクリーンアップしています...

del /F /Q "%TEMP%\*" >nul 2>&1
if !errorLevel! equ 0 (
    echo   [成功] 一時ファイルを削除しました
) else (
    echo   [警告] 一部の一時ファイルの削除に失敗しました
)

REM ============================================
REM 5. ゴミ箱のクリア
REM ============================================
echo.
echo [5/6] ゴミ箱をクリアしています...

powershell -NoProfile -Command "Clear-RecycleBin -Force" >nul 2>&1
if !errorLevel! equ 0 (
    echo   [成功] ゴミ箱をクリアしました
) else (
    echo   [警告] ゴミ箱のクリアに失敗しました
)

REM ============================================
REM 6. 完了
REM ============================================
echo.
echo [6/6] クリーンアップが完了しました
echo.
echo ============================================
echo すべての処理が完了しました
echo ============================================
echo.

endlocal

pause

@REM Made with Bob
