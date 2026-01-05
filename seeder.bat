@echo off
setlocal enabledelayedexpansion

REM Usage:
REM   seeder.bat [FAUCET_URL]
REM Example:
REM   seeder.bat http://localhost:3010

set "FAUCET_URL=%~1"
if "%FAUCET_URL%"=="" set "FAUCET_URL=http://localhost:3010"

echo Fetching faucet status from %FAUCET_URL%/status ...

for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "try { (Invoke-RestMethod '%FAUCET_URL%/status').faucet_address } catch { '' }"`) do set "FAUCET_ADDRESS=%%A"

if "%FAUCET_ADDRESS%"=="" (
  echo Failed to read faucet address from %FAUCET_URL%/status
  echo Is the faucet running and reachable?
  exit /b 1
)

echo.
echo Faucet address:
echo   %FAUCET_ADDRESS%
echo.
echo Next:
echo   Seed/fund this address on testnet-12.
echo.
echo Optional miner integration:
echo   Set KASPA_MINER_CMD to a command template containing {ADDRESS}
echo   Example:
echo     set KASPA_MINER_CMD=kaspa-miner.exe -s 127.0.0.1:16210 -a {ADDRESS}
echo.

if not "%KASPA_MINER_CMD%"=="" (
  set "CMD=%KASPA_MINER_CMD:{ADDRESS}=%FAUCET_ADDRESS%%"
  echo Running:
  echo   !CMD!
  echo.
  call !CMD!
)

endlocal
