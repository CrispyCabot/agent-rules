@echo off
set "APP=C:\Users\cbrid\OneDrive\Documents\Projects\vectorcraft\target\release\vectorcraft.exe"
set "WORK=C:\Users\cbrid\OneDrive\Documents\CHANGE ME"
set "DOC=%WORK%\CHANGE ME.vectorcraft"
set "PORT=7979"

if exist "%DOC%" (
  start "" "%APP%" --control %PORT% "%DOC%"
) else (
  start "" "%APP%" --control %PORT%
)

powershell -NoProfile -Command "for ($i=0; $i -lt 30; $i++) { try { (New-Object Net.Sockets.TcpClient('127.0.0.1',%PORT%)).Close(); exit 0 } catch { Start-Sleep 1 } }; exit 1"
if errorlevel 1 echo VectorCraft did not open its control port; Claude may not be able to reach it.

where wt >nul 2>nul
if %errorlevel%==0 (
  start "" wt -d "%WORK%" cmd /k claude --mcp-config vectorcraft-mcp.json
) else (
  start "Claude - VectorCraft" /D "%WORK%" cmd /k claude --mcp-config vectorcraft-mcp.json
)
