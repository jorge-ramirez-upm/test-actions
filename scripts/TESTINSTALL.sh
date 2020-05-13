echo off 
# CREATE TEMPORARY FOLDER
BUILDFOLDER="build"
OUTPUTFOLDER="dist/testJR"
mkdir -p $BUILDFOLDER

# GET PYTHON INSTALLATION FOLDER
(python3 -c "import sys; print(sys.exec_prefix)") > tmp.txt
WINPYDIR=$(<tmp.txt)
echo $WINPYDIR

# GET PYTHON VERSION
(python3 -c "import sys; print('.'.join(map(str, sys.version_info[:3])))") > tmp.txt
PYTHONVERSION=$(<tmp.txt)
echo $PYTHONVERSION
rm -f tmp.txt

echo "###################################################################"
echo "Creating installation package on Windows for Python $PYTHONVERSION"
echo "Python running on folder $WINPYDIR"
echo "###################################################################"

# GET PYTHON (SET VERSION EQUAL TO CURRENT VERSION ON YOUR SYSTEM, WHERE REPTATE IS WORKING)
# AND TRY TO GET IT TO BE THE SAME VERSION AS IN THE GITHUB SERVER
FILENAME="Python-${PYTHONVERSION}.tgz"
curl -s -f -L -o ${BUILDFOLDER}/${FILENAME} https://www.python.org/ftp/python/${PYTHONVERSION}/${FILENAME}

# CREATE WHEEL CORRESPONDING TO OUR APPLICATIOn
rm -f ${BUILDFOLDER}/*.whl
python3 setup.py bdist_wheel --dist-dir $BUILDFOLDER

# PACK ALL NEEDED FOLDERS AND FILES FOR TCL/TK
mkdir -p $OUTPUTFOLDER
# mkdir -p ${OUTPUTFOLDER}/tcl
# mkdir -p ${OUTPUTFOLDER}/tkinter
# cp -r ${WINPYDIR}/tcl ${OUTPUTFOLDER}/tcl
# cp -r ${WINPYDIR}/Lib/tkinter ${OUTPUTFOLDER}/tkinter
# cp ${WINPYDIR}/DLLs/_tkinter.pyd $OUTPUTFOLDER
# cp $WINPYDIR}/DLLs/tcl86t.dll $OUTPUTFOLDER
# cp $WINPYDIR}/DLLs/tk86t.dll $OUTPUTFOLDER

# UNPACK PYTHON IN THE INSTALLATION FOLDER
tar -xvzf ${BUILDFOLDER}/${FILENAME} -C ${OUTPUTFOLDER}
cp ${BUILDFOLDER}/*.whl ${OUTPUTFOLDER}

cd $OUTPUTFOLDER
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# echo "." >> python37._pth
# echo "Lib/site-packages" >> python37._pth
# echo "." >> python37._pth
python3 get-pip.py --user
rm -f get-pip.py
python3 -m pip install -r ../../requirements.txt
for f in *.whl; do python3 -m pip install $f; done
rm -f *.whl
python3 -c "import compileall; compileall.compile_dir('./', force=True)"

# # INVOKE makensis
# cd ..
# makensis testJR.nsi
