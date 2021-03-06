echo off 
REM CREATE TEMPORARY FOLDER
set BUILDFOLDER=build
set OUTPUTFOLDER=dist\testJR
if not exist %BUILDFOLDER% mkdir %BUILDFOLDER%

REM GET PYTHON INSTALLATION FOLDER
(python -c "import sys; print(sys.exec_prefix)") > tmp.txt
set /P WINPYDIR=<tmp.txt
echo %WINPYDIR%

REM GET PYTHON VERSION
(python -c "import sys; print('.'.join(map(str, sys.version_info[:3])))") > tmp.txt
set /P PYTHONVERSION=<tmp.txt
echo %PYTHONVERSION%
del tmp.txt

echo ###################################################################
echo Creating installation package on Windows for Python %PYTHONVERSION%
echo Python running on folder %WINPYDIR%
echo ###################################################################

REM GET PYTHON (SET VERSION EQUAL TO CURRENT VERSION ON YOUR SYSTEM, WHERE REPTATE IS WORKING)
REM AND TRY TO GET IT TO BE THE SAME VERSION AS IN THE GITHUB SERVER
set FILENAME=python-%PYTHONVERSION%-embed-amd64.zip
curl -s -f -L -o %BUILDFOLDER%\%FILENAME% https://www.python.org/ftp/python/%PYTHONVERSION%/%FILENAME%

REM CREATE WHEEL CORRESPONDING TO OUR APPLICATIOn
del %BUILDFOLDER%\*.whl
python setup.py bdist_wheel --dist-dir %BUILDFOLDER%

REM PACK ALL NEEDED FOLDERS AND FILES FOR TCL/TK
if not exist %OUTPUTFOLDER% mkdir %OUTPUTFOLDER%
if not exist %OUTPUTFOLDER%\tcl mkdir %OUTPUTFOLDER%\tcl
if not exist %OUTPUTFOLDER%\tkinter mkdir %OUTPUTFOLDER%\tkinter
xcopy /S %WINPYDIR%\tcl %OUTPUTFOLDER%\tcl
xcopy /S %WINPYDIR%\Lib\tkinter %OUTPUTFOLDER%\tkinter
copy %WINPYDIR%\DLLs\_tkinter.pyd %OUTPUTFOLDER%
copy %WINPYDIR%\DLLs\tcl86t.dll %OUTPUTFOLDER%
copy %WINPYDIR%\DLLs\tk86t.dll %OUTPUTFOLDER%

REM UNPACK PYTHON IN THE INSTALLATION FOLDER
"C:\Program Files\7-Zip\7z.exe" x -aos -o"%OUTPUTFOLDER%" "%BUILDFOLDER%\%FILENAME%"
copy %BUILDFOLDER%\*.whl %OUTPUTFOLDER%

cd %OUTPUTFOLDER%
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
echo. >> python37._pth
echo Lib/site-packages>> python37._pth
echo. >> python37._pth
python get-pip.py
del get-pip.py
python -m pip install -r ..\..\requirements.txt
for /f "delims=" %%a in ('dir /b *.whl') do python -m pip install %%a
del *.whl
python -c "import compileall; compileall.compile_dir('./', force=True)"

REM INVOKE makensis
cd ..
makensis testJR.nsi
