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
powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TEMP_ZIP%'); exit 0 } catch { Write-Error $_.Exception.Message; exit 1 }"
if errorlevel 1 (
    echo [X] Errore nel download. Controlla la connessione.
    pause
    exit /b 1
)

echo [*] Aggiornamento file in corso...
if exist "%DEST_DIR%" rmdir /s /q "%DEST_DIR%" >nul 2>&1
mkdir "%DEST_DIR%" >nul 2>&1
powershell -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%DEST_DIR%' -Force"
del "%TEMP_ZIP%" >nul 2>&1

echo.
echo [OK] Resource Pack aggiornata all'ultima versione!
pause
exit /b 0
