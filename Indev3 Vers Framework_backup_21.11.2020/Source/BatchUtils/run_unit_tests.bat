@echo off
echo In order for this batch file to work properly, you must have NUnit installed in the following folder "C:\Program Files\NUnit-Net-2.0 2.2.9" and you also have to set your date format from the Regional and Language Options in Control Panel to any of the following formats: MM/DD/YYYY, MM-DD-YYYY or MM.DD.YYYY

for /f "tokens=1-3 delims=/-. " %%a in ('DATE /T') do set THEDATE=%%c%%a%%b

md UnitTestResults\%THEDATE%

echo Running ApplicationFramework tests
"C:\Program Files\NUnit 2.4.6\bin\nunit-console" "..\Framework\UnitTests\ApplicationFrameworkTests.nunit" /xml="UnitTestResults\%THEDATE%\ApplicationFrameworkTests-%THEDATE%.xml" /nologo > "UnitTestResults\%THEDATE%\ApplicationFrameworkTests-%THEDATE%.txt"

echo Running DataAccess tests
"C:\Program Files\NUnit 2.4.6\bin\nunit-console" "..\DataAccess\UnitTests\DataAccessTests.nunit" /xml="UnitTestResults\%THEDATE%\DataAccessTests-%THEDATE%.xml" /nologo > "UnitTestResults\%THEDATE%\DataAccessTests-%THEDATE%.txt"

echo Running BusinessLogic tests
"C:\Program Files\NUnit 2.4.6\bin\nunit-console" "..\BusinessLogic\UnitTests\BusinessLogicTests.nunit" /xml="UnitTestResults\%THEDATE%\BusinessLogicTests-%THEDATE%.xml" /nologo > "UnitTestResults\%THEDATE%\BusinessLogicTests-%THEDATE%.txt"

echo Finished
if not "%1"=="NOWAIT" pause