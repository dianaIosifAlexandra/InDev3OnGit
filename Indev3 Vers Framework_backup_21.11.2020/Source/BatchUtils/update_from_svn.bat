@echo off

cd ..\..\
echo Update sources from SVN - please wait...
svn update
cd Source/BatchUtils
goto end

:svnmiss
echo SVN installation could not be traced. Please install SVN command line utilities first.
goto end

:end
