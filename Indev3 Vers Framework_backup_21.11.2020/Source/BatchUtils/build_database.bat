@echo off
echo Build Database Starting...

for /f "tokens=1-3 delims=/-. " %%a in ('DATE /T') do set THEDATE=%%c%%a%%b
if "%TARGET_DIR%"=="" GOTO parmiss
if "%SOURCE_DIR%"=="" SET SOURCE_DIR=".."

md "%TARGET_DIR%"
md "%TARGET_DIR%\Database"

echo Create database schema script
copy "%SOURCE_DIR%\Database\Schema\*.sql" "%TARGET_DIR%\Database\1. Create DB.sql"
if errorlevel 1 goto err

replace -find INDEV3Work -replace INDEV3Test_%THEDATE% -srcdir "%TARGET_DIR%\Database\" -destdir "%TARGET_DIR%\Database\" -fname "1. Create DB.sql"
if errorlevel 1 goto err

echo Initialization script
copy "%SOURCE_DIR%\Database\Initialization\*.sql" "%TARGET_DIR%\Database\2. Initialization.sql"
if errorlevel 1 goto err

echo StoredProcedures script
copy "%SOURCE_DIR%\Database\Stored Procedures\*.sql" "%TARGET_DIR%\Database\3. StoredProcedures.sql"
if errorlevel 1 goto err

echo Views script
copy "%SOURCE_DIR%\Database\Views\*.sql" "%TARGET_DIR%\Database\4. Views.sql"
if errorlevel 1 goto err

echo OLAP cabs
copy "%SOURCE_DIR%\Database\OLAP\INDEV3.CAB" "%TARGET_DIR%\Database\X_INDEV3.CAB"
if errorlevel 1 goto err

goto END

:err
  echo   ******************************************************************************
  echo      Build has encountered an error!
  echo   ******************************************************************************
  echo Build Build Database was NOT completed.
  goto batchfail

:parmiss
  echo TARGET_DIR environment variable is not set. This scripts needs a source and target directory.
  echo Build Build Database was NOT completed.
  goto batchfail

:END
 echo Build Database Completed Succesfully
 goto batchsuccess

:batchsuccess
     if not "%1"=="NOWAIT" pause
     EXIT /B 0

:batchfail
    if not "%1"=="NOWAIT" pause
    EXIT /B 1

