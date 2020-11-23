@echo off

SET OUT_DIR=%1
if "%1"=="" SET OUT_DIR="."

echo Setting current directory ..
for /f %%i in ("%0") do set curpath=%%~dpi
cd /d %curpath% 

echo Creating SVN Revision XML file...
svn info "svn://projects/home/svn/INERGY/projects/INDev3/trunk" --xml > "%OUT_DIR%"\SVNState.xml
if errorlevel 1 goto err

echo Creating SVN Revision text file...
SVNRevisionNumberXML %OUT_DIR%\SVNState.xml %OUT_DIR%\SVNRevision.txt
if errorlevel 1 goto err

echo Deleting SVN Revision XML file...
del "%OUT_DIR%"\SVNState.xml

set /p LAST_SVN_REVISION= <%OUT_DIR%\SVNRevision.txt
echo Revision is: %LAST_SVN_REVISION%

goto end

:err
  echo   ******************************************************************************
  echo      SVN Revision 2 File encountered an error!
  echo   ******************************************************************************
goto end

:parmiss
echo The path of the exported file is missing
goto end

:end
