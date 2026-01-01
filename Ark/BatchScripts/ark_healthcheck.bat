@echo off
setlocal

REM =============================
REM CONFIG
REM =============================
set ARK_EXE=ArkAscendedServer.exe
set RCON=C:\ArkAscended\Ark\BatchScript\asa_rcon.exe"
set RCON_HOST=10.69.69.2
set RCON_PORT=27020
set RCON_PASS=DonkeyDiddler999
set LOG=C:\Users\ADMIN\Documents\ASAClusterMelon\logs\healthcheck.log

set LOCK=C:\Users\ADMIN\Documents\ASAClusterMelon\healthcheck.lock

if exist %LOCK% (
    echo [%TS%] Restart already in progress >> %LOG%
    goto END
)

REM =============================
REM TIMESTAMP
REM =============================
for /f "tokens=1-3 delims=/: " %%a in ("%date% %time%") do (
    set TS=%date% %time%
)

echo [%TS%] Health check started >> %LOG%

REM =============================
REM CHECK 1: PROCESS EXISTS
REM =============================
tasklist | find /i "%ARK_EXE%" >nul
if errorlevel 1 (
    echo [%TS%] Ark process not running >> %LOG%
    goto RESTART
)

REM =============================
REM CHECK 2: RCON RESPONDS
REM =============================
%RCON% --Settings:Host=%RCON_HOST% ^
       --Settings:Port=%RCON_PORT% ^
       --Settings:Password=%RCON_PASS% ^
       --Settings:Command=listplayers >nul 2>&1

if errorlevel 1 (
    echo [%TS%] RCON not responding >> %LOG%
    goto RESTART
)

echo [%TS%] Health OK >> %LOG%
goto END

REM =============================
REM RESTART SEQUENCE
REM =============================
:RESTART
echo [%TS%] Restarting server >> %LOG%

call "C:\ArkAscended\Ark\BatchScripts\BroadcastRestart.bat"
timeout /t 30 /nobreak

call C:\ArkAscended\Ark\BatchScript\SaveWorld.bat"
timeout /t 10 /nobreak

echo restart > %LOCK%

call C:\ArkAscended\Ark\BatchScript\ExitServer.bat"
timeout /t 30 /nobreak

call "C:\Users\ADMIN\Documents\start_island.bat"
del C:\Ark\healthcheck.lock

echo [%TS%] Restart triggered >> %LOG%

:END
endlocal
