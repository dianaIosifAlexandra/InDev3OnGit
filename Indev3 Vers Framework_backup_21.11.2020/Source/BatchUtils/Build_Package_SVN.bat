@echo off
echo In order for this batch file to work properly, you have to set your date format from the Regional and Language Options in Control Panel to any of the following formats: MM/DD/YYYY, MM-DD-YYYY or MM.DD.YYYY

for /f "tokens=1-3 delims=/-. " %%a in ('DATE /T') do set THEDATE=%%c%%a%%b

md "..\..\Packages\%THEDATE%"
PUSHD "..\..\Packages\%THEDATE%"
SET TARGET_DIR="%CD%"

POPD

MD ".\%THEDATE%"
PUSHD ".\%THEDATE%"
SET SOURCE_DIR="%CD%"

POPD

echo Export the latest version of sources from SVN
svn export --non-interactive --force "svn://projects/home/svn/INERGY/projects/INDev3/trunk/Source" "%SOURCE_DIR%"
call build_setup_packages.bat %1

rd "%SOURCE_DIR%" /S /Q