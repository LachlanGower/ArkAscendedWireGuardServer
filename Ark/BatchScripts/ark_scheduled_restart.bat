@echo off
echo === ARK Scheduled Maintenance Started ===
echo %DATE% %TIME%

REM --- 10 minute warning ---
call "C:\ArkAscendedWireGuardServer\Ark\BatchScripts\BroadcastRestart.bat"

echo Waiting 10 minutes before shutdown...
timeout /t 600 /nobreak

REM --- Final save warning ---
call "C:\ArkAscendedWireGuardServer\Ark\BatchScripts\BroadcastSave.bat"

REM --- Force world save ---
call "C:\ArkAscendedWireGuardServer\Ark\BatchScripts\SaveWorld.bat"

REM --- Give save time to flush ---
timeout /t 15

REM --- Clean shutdown ---
call "C:\ArkAscendedWireGuardServer\Ark\BatchScripts\ExitServer.bat"

REM --- Wait for process to exit fully ---
timeout /t 30

REM --- Update server ---
call "C:\ArkAscendedWireGuardServer\Ark\BatchScripts\update_server.bat"

REM --- Start server ---
call "C:\ArkAscendedWireGuardServer\Ark\BatchScriptss\start_island.bat"

echo === ARK Maintenance Complete ===
echo %DATE% %TIME%
