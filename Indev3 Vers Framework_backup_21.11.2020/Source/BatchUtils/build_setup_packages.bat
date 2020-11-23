@echo off
echo Build Setup Packages Starting...
echo In order for this batch file to work properly, you have to set your date format from the Regional and Language Options in Control Panel to any of the following formats: MM/DD/YYYY, MM-DD-YYYY or MM.DD.YYYY
if not "%1"=="NOWAIT" pause

for /f "tokens=1-3 delims=/-. " %%a in ('DATE /T') do set THEDATE=%%c%%a%%b

if "%TARGET_DIR%"=="" SET TARGET_DIR="..\..\Packages\%THEDATE%"

echo Create target directories
md "%TARGET_DIR%"
md "%TARGET_DIR%\Indev3Root"

echo Creating SVN stamp file...
call svnrevision2file.bat "%TARGET_DIR%"
if errorlevel 1 goto err

echo Set Source Dir
if "%SOURCE_DIR%"=="" SET SOURCE_DIR=".."

echo Register VS8 environment variables and paths
if "%VSINSTALLDIR%"=="" call "%VS80COMNTOOLS%\vsvars32.bat" > nul

echo Rebuilding the application...
call build_all_release.bat %1
if errorlevel 1 goto err

echo Copying the INDev3WebSite...
rd "%TARGET_DIR%\Indev3Root\INDev3WebSite" /S /Q
%windir%\Microsoft.NET\Framework\v2.0.50727\aspnet_compiler.exe -p "%SOURCE_DIR%\Indev3Root\Indev3" -v / "%TARGET_DIR%\Indev3Root\INDev3WebSite"
if errorlevel 1 goto err

echo Copy Indev3 Reporting
xcopy "%SOURCE_DIR%\Indev3WebSite\WebReports" "%TARGET_DIR%\Indev3Root\WebReports" /Y /Q /E /I

echo Copy the upload directories
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UploadDirectories" "%TARGET_DIR%\Indev3Root\INDev3WebSite\UploadDirectories" /Y /Q /E /I

xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UploadDirectoriesAnnual" "%TARGET_DIR%\Indev3Root\INDev3WebSite\UploadDirectoriesAnnual" /Y /Q /E /I

xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UploadDirectoriesInitial" "%TARGET_DIR%\Indev3Root\INDev3WebSite\UploadDirectoriesInitial" /Y /Q /E /I

echo Starting to create scripts for Database
call build_database.bat %1
if errorlevel 1 goto err

goto ENDING

:err
  echo   ******************************************************************************
  echo      Build Setup Packages has encountered an error!
  echo   ******************************************************************************
  echo Build Setup Packages was NOT completed.
  goto batchfail

:ENDING
  echo Build Setup Packages Completed Succesfully
  goto batchsuccess

:batchsuccess
     if not "%1"=="NOWAIT" pause
     EXIT /B 0

:batchfail
    if not "%1"=="NOWAIT" pause
    EXIT /B 1
