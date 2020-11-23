@echo off
echo Build All Release Starting...
if "%SOURCE_DIR%"=="" SET SOURCE_DIR=".."

rem Test if VS8 is installed  
if "%VS100COMNTOOLS%"=="" goto errenv

rem Register VS8 environment variables and paths
if "%VSINSTALLDIR%"=="" call "%VS100COMNTOOLS%\vsvars32.bat" > nul

msbuild.exe /nologo "%SOURCE_DIR%\Framework\ApplicationFramework\ApplicationFramework.csproj" /t:Build /p:Configuration=Release
if errorlevel 1 goto err

msbuild.exe /nologo "%SOURCE_DIR%\Entities\Entities.csproj" /t:Build /p:Configuration=Release
if errorlevel 1 goto err

msbuild.exe /nologo "%SOURCE_DIR%\DataAccess\DataAccess\DataAccess.csproj" /t:Build /p:Configuration=Release
if errorlevel 1 goto err

msbuild.exe /nologo "%SOURCE_DIR%\BusinessLogic\BusinessLogic\BusinessLogic.csproj" /t:Build /p:Configuration=Release
if errorlevel 1 goto err

msbuild.exe /nologo "%SOURCE_DIR%\Framework\WebFramework\WebFramework.csproj" /t:Build /p:Configuration=Release
if errorlevel 1 goto err

copy "%SOURCE_DIR%\Bin" "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Bin"

msbuild.exe /nologo "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite.sln" /t:Build /p:Configuration=Release
if errorlevel 1 goto err

REM Build unit tests

REM msbuild.exe /nologo "%SOURCE_DIR%\Framework\UnitTests\ApplicationFrameworkTests\ApplicationFrameworkTests.csproj" /t:Build /p:Configuration=Release
REM if errorlevel 1 goto err

REM msbuild.exe /nologo "%SOURCE_DIR%\DataAccess\UnitTests\DataAccessTests\DataAccessTests.csproj" /t:Build /p:Configuration=Release
REM if errorlevel 1 goto err

REM msbuild.exe /nologo "%SOURCE_DIR%\BusinessLogic\UnitTests\BusinessLogicTests\BusinessLogicTests.csproj" /t:Build /p:Configuration=Release
REM if errorlevel 1 goto err

echo STOP the World Wide Web service
net stop w3svc

echo Delete the INdev3 directory
rd "%SOURCE_DIR%\Indev3Root" /S /Q

xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Bin" "%SOURCE_DIR%\Indev3Root\Indev3\Bin" /Y /Q /I
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UserControls" "%SOURCE_DIR%\Indev3Root\Indev3\UserControls" /Y /E /Q /I
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Web.config" "%SOURCE_DIR%\Indev3Root\Indev3" /Y /Q
copy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\*.aspx" "%SOURCE_DIR%\Indev3Root\Indev3" /Y
copy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\*.xml" "%SOURCE_DIR%\Indev3Root\Indev3" /Y
copy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\*.cs" "%SOURCE_DIR%\Indev3Root\Indev3" /Y
copy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\*.master" "%SOURCE_DIR%\Indev3Root\Indev3" /Y
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\App_Code" "%SOURCE_DIR%\Indev3Root\Indev3\App_Code" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Pages" "%SOURCE_DIR%\Indev3Root\Indev3\Pages" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Images" "%SOURCE_DIR%\Indev3Root\Indev3\Images" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Styles" "%SOURCE_DIR%\Indev3Root\Indev3\Styles" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Scripts" "%SOURCE_DIR%\Indev3Root\Indev3\Scripts" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\Skins" "%SOURCE_DIR%\Indev3Root\Indev3\Skins" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UploadDirectories" "%SOURCE_DIR%\Indev3Root\Indev3\UploadDirectories" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UploadDirectoriesAnnual" "%SOURCE_DIR%\Indev3Root\Indev3\UploadDirectoriesAnnual" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\Indev3WebSite\UploadDirectoriesInitial" "%SOURCE_DIR%\Indev3Root\Indev3\UploadDirectoriesInitial" /Y /E /I /Q
xcopy "%SOURCE_DIR%\Indev3WebSite\WebReports" "%SOURCE_DIR%\Indev3Root\WebReports" /Y /E /I /Q

echo Retrieving the SVN revision...
call svnrevision2file.bat "%TARGET_DIR%"
if errorlevel 1 goto err

echo Prepare the web.config file to include the SVN revision
ssr 1 @revision@ %LAST_SVN_REVISION% %SOURCE_DIR%\Indev3Root\Indev3\Web.Config
if errorlevel 1 goto err

echo START the World Wide Web service
net start w3svc

goto ending

:errenv
    echo VS2010 is not installed!  
    goto batchfail

:err
  echo   ******************************************************************************
  echo      Build All Release has encountered an error!
  echo   ******************************************************************************
  echo Build All Release was NOT completed.
  goto batchfail


:ending
    echo   ******************************************************************************
    echo      Build All Release finished!
    echo   ******************************************************************************
    echo Build All Release Successfully!
    goto batchsuccess

:batchsuccess
     if not "%1"=="NOWAIT" pause
     EXIT /B 0

:batchfail
    if not "%1"=="NOWAIT" pause
    EXIT /B 1
