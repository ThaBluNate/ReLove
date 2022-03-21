@echo off
Title ReLOVE
if not exist ReLove.ini (
echo [Build Info]>ReLove.ini
echo Name=Build>>ReLove.ini
echo Separator=_>>ReLove.ini
echo State=Release>>ReLove.ini
echo Version=1.1.5>>ReLove.ini
echo.>>ReLove.ini
echo 	# Name,Separator,State,Separator,Version>>ReLove.ini
echo 	# Build_Release_1.1.5>>ReLove.ini
echo.>>ReLove.ini
echo [Nameing Info]>>ReLove.ini
echo ExeNameOnly=true>>ReLove.ini
echo ZipNameOnly=false>>ReLove.ini
echo.>>ReLove.ini
echo 	# If you enable these, they check if the file name should >>ReLove.ini
echo 	# be 'Name' or 'Name,Separator,State,Separator,Version'>>ReLove.ini
echo 	# for the ZIP name or the EXE name inside>>ReLove.ini
echo.>>ReLove.ini
echo [Misc. Info]>>ReLove.ini
echo SkipFileChecks=false>>ReLove.ini
echo.>>ReLove.ini
echo 	# Skip file checks for love or ico files at begining>>ReLove.ini
echo 	# This skips the errors without any human intervention.>>ReLove.ini
)
for /f "tokens=1,2 delims==" %%a in (ReLove.ini) do (
if %%a==Name set name=%%b
if %%a==Separator set separator=%%b
if %%a==State set state=%%b
if %%a==Version set version=%%b
if %%a==ExeNameOnly set ExeNameOnly=%%b
if %%a==ZipNameOnly set ZipNameOnly=%%b
if %%a==SkipFileChecks set SkipFileChecks=%%b
)
if %ExeNameOnly% == true (set fn=%name%) else (set fn=%name%%separator%%state%%separator%%version%)
if %ZipNameOnly% == true (set zn=%name%) else (set zn=%name%%separator%%state%%separator%%version%)
if %SkipFileChecks% == true (goto 2)
if exist *.love (
:1
if exist icon.ico (
:2
color 0a
echo Copying temp...
powershell -NoProfile -NonInteractive -NoLogo -Command "Expand-Archive -Force -Path Make.zip -DestinationPath Temp/" >nul
echo Copying LOVE file to Temp...
copy *.love temp /V /Y >nul
copy icon.ico temp /V /Y >nul
cd temp >nul
echo Making executable...
copy /b love.exe+*.love TempBuild.exe >nul
if exist *.ico (ResHack -log nul -open TempBuild.exe -save %fn%.exe -action addskip -res icon.ico -mask ICONGROUP,MAINICON,) else (ren TempBuild.exe %fn%.exe&&set del=1)
echo Extracting DLLs...
7za x dll.7z -y >nul
echo Cleanup...
del love.exe /f /q >nul
del dll.7z /f /q >nul
del *.love /f /q >nul
del 7za.exe /f /q >nul
del 7za.dll /f /q >nul
del ResHack.exe /f /q >nul
del ResHack.ini /f /q >nul
del TempBuild.exe /f /q >nul
del *.ico /f /q >nul
echo Making ZIP...
powershell -NoProfile -NonInteractive -NoLogo -Command "Compress-Archive -Path *.* -DestinationPath ..\%zn%.zip" >nul
echo.
Echo Done! Press any key to clean up and exit!
pause>nul
cd..
rd /s /q Temp >nul
) else (Title ReLOVE - Error&&color 04&&echo Coudn't find ICON.&&echo Make sure it's named icon.ico&&echo Press any key to Ignore...&&pause>nul&&cls&&goto 2)
) else (Title ReLOVE - Error&&color 04&&echo Coudn't find LOVE source file.&&echo Press any key to Ignore...&&pause>nul&&cls&&goto 1)