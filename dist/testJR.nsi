; The name of the installer
Name "testJR"

; The file to write
OutFile "Install_testJR.exe"

; Request application privileges for Windows Vista
RequestExecutionLevel user

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $DESKTOP\testJR

;--------------------------------

; Pages

Page directory
Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File /r "testJR\*" 

	# Start Menu
	createDirectory "$SMPROGRAMS\testJR"
	createShortCut "$SMPROGRAMS\testJR\testJR.lnk" "$INSTDIR\pythonw.exe" "-m testJR" ""
   
  
SectionEnd ; end the section
