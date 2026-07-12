@echo off
setlocal EnableDelayedExpansion
cd %~dp0

echo.
echo +-----------------------+
echo |    VIPHACKER100       |
echo |   BurpSuite Patcher   |
echo +-----------------------+
echo.

:: Find Burp Suite
FOR /F "skip=2 tokens=2,*" %%A IN ('reg.exe query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall\7318-9294-3757-1226" /v "InstallLocation"') DO set "BurpPath=%%B"

if exist %BurpPath% goto FoundPath

:PromptBurpPath
echo [!] Couldn't find BurpSuite path.
set /p BurpPath=Enter Path to Burp Suite installation:

:FoundPath
echo [+] Found Path: %BurpPath%

:: Clean up old patching approach (activation.vmoptions / -javaagent)
set "OptionsFile=%BurpPath%\BurpSuitePro.vmoptions"
if exist "%BurpPath%\activation.vmoptions" (
    echo [+] Removing old activation.vmoptions
    del "%BurpPath%\activation.vmoptions"
)
if exist "%OptionsFile%" (
    echo [+] Cleaning old -include-options from BurpSuitePro.vmoptions
    findstr /V /C:"-include-options activation.vmoptions" "%OptionsFile%" > "%OptionsFile%.tmp"
    move /Y "%OptionsFile%.tmp" "%OptionsFile%" >nul
)

:: Copy Loader
echo [+] Copying Loader to Path
copy BurpLoaderKeygen_v1.18.jar "%BurpPath%\Loader.jar"

:: Kill any running Burp processes
echo [+] Closing any running Burp instances
taskkill /F /IM BurpSuitePro.exe 2>nul >nul
taskkill /F /IM javaw.exe 2>nul >nul

echo [+] Launching Loader...
echo.
echo    In the Loader window, click "Run" to start Burp Suite.
echo    Then follow the manual activation process between both windows.
echo.
start "" "%BurpPath%\jre\bin\javaw.exe" -jar "%BurpPath%\Loader.jar"

echo [+] Done!
