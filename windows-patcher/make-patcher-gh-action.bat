@echo off
cd %~dp0

echo.
echo +--------------------------------+
echo |     VIPHACKER100 Edition       |
echo |   BurpSuite Patcher Builder    |
echo +--------------------------------+
echo.

:: Add Path to 7z.exe here
set OUTPUT=Build\burpsuite_pro_patcher_windows_x86-64.exe

:: Create Archive
7z a archive.7z BurpLoaderKeygen_v1.18.jar burploader.bat
copy /b 7zSD.sfx + config.txt + archive.7z %OUTPUT%


:: Error handling

:Cleanup
del /Q archive.7z
exit 0