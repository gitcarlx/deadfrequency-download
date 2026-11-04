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

if not exist "%MC_DIR%" (
    echo [!] Cartella .minecraft non trovata in:
    echo     %MC_DIR%
    echo Creo la cartella...
    mkdir "%MC_DIR%" >nul 2>&1
)

if not exist "%RP_DIR%" mkdir "%RP_DIR%" >nul 2>&1

echo [*] Scaricamento Resource Pack da GitHub in corso...
echo     URL: %DOWNLOAD_URL%
powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%DOWNLOAD_URL%', '%TEMP_ZIP%'); exit 0 } catch { Write-Error $_.Exception.Message; exit 1 }"
if errorlevel 1 (
    echo.
    echo [X] Errore durante il download del pacchetto.
    echo     Verifica la connessione internet e riprova.
    pause
    exit /b 1
)

echo [*] Estrazione nella cartella resourcepacks...
if exist "%DEST_DIR%" (
    rmdir /s /q "%DEST_DIR%" >nul 2>&1
)
mkdir "%DEST_DIR%" >nul 2>&1

powershell -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%DEST_DIR%' -Force"
del "%TEMP_ZIP%" >nul 2>&1

echo [*] Configurazione automatica options.txt per attivare la pack...
set "OPT_FILE=%MC_DIR%\options.txt"
if exist "%OPT_FILE%" (
    powershell -Command "$opt = Get-Content '%OPT_FILE%'-Raw; if ($opt -notmatch 'file/Phasmophobia Pack') { if ($opt -match 'resourcePacks:\[(.*?)\]') { $curr = $matches[1]; if ($curr.Trim() -eq '') { $rep = 'resourcePacks:[\"vanilla\",\"file/Phasmophobia Pack\"]' } else { $rep = 'resourcePacks:[' + $curr + ',\"file/Phasmophobia Pack\"]' }; $opt = $opt -replace 'resourcePacks:\[.*?\]', $rep; Set-Content '%OPT_FILE%' $opt -NoNewline } }"
)

echo.
echo ========================================================
echo [OK] Resource Pack installata e attivata con successo!
echo.
echo Per giocare:
echo 1. Avvia il tuo Minecraft (versione consigliata 1.20.1 o superiore).
echo 2. Collega al server: liliumnetwork.com
echo 3. La resource pack sara' gia' attiva e funzionante!
echo ========================================================
echo.
pause
exit /b 0
