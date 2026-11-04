@echo off
setlocal enabledelayedexpansion
title Dead Frequency - Installatore Resource Pack Minecraft
color 0c

echo ========================================================
echo        DEAD FREQUENCY - RESOURCE PACK MINECRAFT         
echo               Server: liliumnetwork.com                 
echo ========================================================
echo.
echo Questo script installera' automaticamente la Resource Pack
echo ufficiale di Dead Frequency / PhasmoCraft nella tua
echo installazione di Minecraft (Java Edition).
echo.

set "MC_DIR=%APPDATA%\.minecraft"
set "RP_DIR=%MC_DIR%\resourcepacks"
set "PACK_NAME=Phasmophobia Pack"
set "DEST_DIR=%RP_DIR%\%PACK_NAME%"
set "DOWNLOAD_URL=https://github.com/gitcarlx/deadfrequency-download/releases/latest/download/Phasmophobia-Pack.zip"
set "TEMP_ZIP=%TEMP%\Phasmophobia-Pack.zip"

if not exist "%MC_DIR%" mkdir "%MC_DIR%" >nul 2>&1
if not exist "%RP_DIR%" mkdir "%RP_DIR%" >nul 2>&1

echo [*] Scaricamento Resource Pack da GitHub in corso...
where curl.exe >nul 2>nul
if %errorlevel% equ 0 (
    curl.exe -L -k --progress-bar -o "%TEMP_ZIP%" "%DOWNLOAD_URL%"
) else (
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TEMP_ZIP%')"
)

if not exist "%TEMP_ZIP%" (
    echo.
    echo [X] Errore: download non riuscito. Controlla la connessione internet.
    pause
    exit /b 1
)

echo [*] Estrazione in: %DEST_DIR%...
if exist "%DEST_DIR%" rmdir /s /q "%DEST_DIR%" >nul 2>&1
mkdir "%DEST_DIR%" >nul 2>&1

where tar.exe >nul 2>nul
if %errorlevel% equ 0 (
    tar.exe -xf "%TEMP_ZIP%" -C "%DEST_DIR%"
) else (
    powershell -NoProfile -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%DEST_DIR%' -Force"
)

del "%TEMP_ZIP%" >nul 2>&1

echo [*] Configurazione options.txt per attivazione automatica...
set "OPT_FILE=%MC_DIR%\options.txt"
if exist "%OPT_FILE%" (
    powershell -NoProfile -Command "$f = '%OPT_FILE%'; if (Test-Path $f) { $t = [System.IO.File]::ReadAllText($f); if ($t -notmatch 'file/Phasmophobia Pack') { if ($t -match 'resourcePacks:\[(.*?)\]') { $c = $matches[1]; $r = if ($c.Trim() -eq '') { 'resourcePacks:[\"vanilla\",\"file/Phasmophobia Pack\"]' } else { 'resourcePacks:[' + $c + ',\"file/Phasmophobia Pack\"]' }; $t = $t -replace 'resourcePacks:\[.*?\]', $r; [System.IO.File]::WriteAllText($f, $t) } } }"
)

echo.
echo ========================================================
echo [OK] Resource Pack installata e attivata con successo!
echo.
echo Per giocare:
echo 1. Avvia Minecraft (Java Edition 1.20.1 o superiore).
echo 2. Connettiti al server: liliumnetwork.com
echo 3. La resource pack sara' gia' attiva!
echo ========================================================
echo.
pause
exit /b 0
