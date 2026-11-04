@echo off
setlocal enabledelayedexpansion
title Dead Frequency - Aggiorna Resource Pack Minecraft
color 0c

echo ========================================================
echo        DEAD FREQUENCY - AGGIORNA RESOURCE PACK          
echo ========================================================
echo.
set "MC_DIR=%APPDATA%\.minecraft"
set "DEST_DIR=%MC_DIR%\resourcepacks\Phasmophobia Pack"
set "DOWNLOAD_URL=https://github.com/gitcarlx/deadfrequency-download/releases/latest/download/Phasmophobia-Pack.zip"
set "TEMP_ZIP=%TEMP%\Phasmophobia-Pack.zip"

echo [*] Scaricamento dell'ultima versione della Resource Pack...
where curl.exe >nul 2>nul
if %errorlevel% equ 0 (
    curl.exe -L -k --progress-bar -o "%TEMP_ZIP%" "%DOWNLOAD_URL%"
) else (
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TEMP_ZIP%')"
)

if not exist "%TEMP_ZIP%" (
    echo [X] Errore nel download. Controlla la connessione.
    pause
    exit /b 1
)

echo [*] Aggiornamento file in corso...
if exist "%DEST_DIR%" rmdir /s /q "%DEST_DIR%" >nul 2>&1
mkdir "%DEST_DIR%" >nul 2>&1

where tar.exe >nul 2>nul
if %errorlevel% equ 0 (
    tar.exe -xf "%TEMP_ZIP%" -C "%DEST_DIR%"
) else (
    powershell -NoProfile -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%DEST_DIR%' -Force"
)

del "%TEMP_ZIP%" >nul 2>&1

echo.
echo ========================================================
echo [OK] Resource Pack aggiornata all'ultima versione!
echo ========================================================
echo.
pause
exit /b 0
