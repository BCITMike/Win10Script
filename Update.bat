@echo off
:: Version 1.0
:: August 26th, 2017

SETLOCAL ENABLEDELAYEDEXPANSION

Set FileDir=%~dp0
Set URL_Base=https://raw.githubusercontent.com/madbomb122/
Set UpdateArg=no
Set RunArg=no
Set DownloadBV=no
Set DownloadW10=no
Set DownloadBV-W10=no
Set BatDownload=no
Set TestV=no
Set MiscArg=

if [%1]==[] (
	goto MainMenu
) else (
	goto loop
)

:loop
if x%1 equ x (
	echo.
	If /i %DownloadBV%==yes If /i %DownloadW10%==yes (
		Set DownloadBV-W10=yes
		Set DownloadBV=no
		Set DownloadW10=no
	)
	If /i %DownloadBV-W10%==yes goto BV
	If /i %DownloadBV%==yes goto BV
	If /i %DownloadW10%==yes goto W10
	goto Invalid
)
set param=%1
goto checkParam

:next
shift /1
goto loop

:checkParam
If "%1" equ "-help" goto ShowArgs
If "%1" equ "-h" goto ShowArgs
If "%1" equ "-u" (
	Set UpdateArg=yes
	goto next
)
If "%1" equ "-r" (
	Set RunArg=yes
	goto next
)
If "%1" equ "-bv" (
	Set DownloadBV=yes
	goto next
)
If "%1" equ "-w10" (
	Set DownloadW10=yes
	goto next
)
If "%1" equ "-both" (
	Set DownloadBV-W10=yes
	goto next
)
If "%1" equ "-test" (
	Set TestV=yes
	goto next
)
Set MiscArg=!MiscArg! %1
goto next


:BV
	Set ScriptFileName=BlackViper-Win10.ps1
	Set FilePath=!FileDir!!ScriptFileName!
	Set ScriptUrl=!URL_Base!BlackViperScript/master/
	If /i !TestV!==yes Set ScriptUrl=!ScriptUrl!Testing/
	Set ScriptUrl=!ScriptUrl!!ScriptFileName!
	echo Downloading Black Viper Script
	::echo from !ScriptUrl!
	echo to !FilePath!
	echo.
	powershell -Command "Invoke-WebRequest !ScriptUrl! -OutFile !FilePath!"
	If /i %UpdateArg%==no (
		Set ServiceFilePath=!FileDir!BlackViper.csv
		Set ServiceUrl=!URL_Base!BlackViperScript/master/BlackViper.csv
		echo Downloading Black Viper Service File
		::echo from !ServiceUrl!
		echo to !ServiceFilePath!
		echo.
		powershell -Command "Invoke-WebRequest !ServiceUrl! -OutFile !ServiceFilePath!"
		If !BatDownload!==yes (
			Set BatFilePath=!FileDir!_Win10-BlackViper.bat
			Set BatUrl=!URL_Base!BlackViperScript/master/_Win10-BlackViper.bat
			echo Downloading Black Viper Script Bat File
			::echo from !BatUrl!
			echo to !BatFilePath!
			echo.
			powershell -Command "Invoke-WebRequest !BatUrl! -OutFile !BatFilePath!"
		)
	)
	goto CheckRun

:W10
	Set ScriptFileName=Win10-Menu.ps1
	Set FilePath=!FileDir!!ScriptFileName!
	Set ScriptUrl=!URL_Base!Win10Script/master/
	If /i !TestV!==yes Set ScriptUrl=!ScriptUrl!Testing/
	Set ScriptUrl=!ScriptUrl!!ScriptFileName!
	echo Downloading Windows 10 Script
	::echo from !ScriptUrl!
	echo to !FilePath!
	echo.
	powershell -Command "Invoke-WebRequest !ScriptUrl! -OutFile !FilePath!"
	If !BatDownload!==yes (
		Set BatFilePath=!FileDir!_Win10-Script-Run.bat
		Set BatUrl=!URL_Base!Win10Script/master/_Win10-Script-Run.bat
		echo Downloading Windows 10 Script Bat File
		::echo from !BatUrl!
		echo to !BatFilePath!
		echo.
		powershell -Command "Invoke-WebRequest !BatUrl! -OutFile !BatFilePath!"
	)
	If /i %DownloadBV-W10%==yes set DownloadBV-W10=Done
	goto CheckRun


:Invalid
	echo No valid Argument/Switch was used,
	goto ShowArgs

:ShowArgs
	echo The following is a list of valid Argument/Switch
	echo.
	echo Switch    Description
	echo -----------------------------------------------------------------
	echo -Help     Shows the Argument/Switch
	echo -BV       Download BlackViper Script
	echo -W10      Download Windows 10 Script
	echo -Both     Download BlackViper and Windows 10 Script
	echo -Test     Download the Test Version of Script
	echo -Run      Download then runs the script..Does not work with -Both
	GOTO:EOF

:CheckRun
	If /i %DownloadBV-W10%==yes goto W10
	If /i %UpdateArg%==yes (
		powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "!FilePath! !MiscArg!"' -Verb RunAs}"
		Exit
	)
	If /i %RunArg%==yes (
		If /i %DownloadBV-W10%==Done (
			echo Cannot do a -Run with -Both
		) else (
			powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "!FilePath!"' -Verb RunAs}"
		)
		Exit
	)
	GOTO:EOF

:MainMenu
cls
echo  ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo  ºÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ Madbomb122's Script Updater/Downloader ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿º
echo  º³                ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                ³º
echo  º³                                                                          ³º
If /i !TestV!==no (
echo  º³                              Stable Version                              ³º
) Else (
echo  º³                               Test Version                               ³º
)
echo  º³                     --------------------------------                     ³º
If !BatDownload!==no (
echo  º³                      1^) Black Viper Script*                              ³º
echo  º³                      2^) Windows 10 Script                                ³º
echo  º³                      3^) Black Viper ^& Windows 10 Script                  ³º
) Else (
echo  º³                      1^) Black Viper Script* ^& Bat File                   ³º
echo  º³                      2^) Windows 10 Script ^& Bat File                     ³º
echo  º³                      3^) Black Viper ^& Windows 10 Script ^& Bat Files      ³º
)
echo  º³                                                                          ³º
echo  º³                        Download Options (Toggles)                        ³º
echo  º³                     --------------------------------                     ³º
If /i !TestV!==no (
echo  º³                      4^) Dont Download Test Version ^(Stable^) of Script    ³º
) Else (
echo  º³                      4^) Download Test Version of Script                  ³º
)
If /i !BatDownload!==no (
echo  º³                      5^) Dont Download bat file                           ³º
) Else (
echo  º³                      5^) Download bat file                                ³º
)
If /i !RunArg!==no (
echo  º³                      6^) Dont Run Script after download**                 ³º
) Else (
echo  º³                      6^) Run A Script after download**                    ³º
)
echo  º³                                                                          ³º
echo  º³                     --------------------------------                     ³º
echo  º³                      Q^) Quit                                             ³º
echo  º³                                                                          ³º
echo  º³  *Note: Will also download the Service file for Black Viper Script.      ³º
echo  º³  **Note: Will NOT Run Script if downloading both Scripts. ^(Option 3^)     ³º
echo  º³                                                                          ³º
echo  ºÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙº
echo  ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
echo.
CHOICE /C 123456Q /N /M "Please Input Choice:"
IF %ERRORLEVEL%==1 goto BV
IF %ERRORLEVEL%==2 goto W10
IF %ERRORLEVEL%==3 (
	Set DownloadBV-W10=yes
	goto BV 
)
IF %ERRORLEVEL%==4 (
	If !TestV!==no (
		Set TestV=yes
	) Else (
		Set TestV=no
	)
	goto MainMenu 
)
IF %ERRORLEVEL%==5 (
	If !BatDownload!==no (
		Set BatDownload=yes
	) Else (
		Set BatDownload=no
	)
	goto MainMenu
)
IF %ERRORLEVEL%==6 (
	If /i !RunArg!==no (
		Set RunArg=yes
	) Else (
		Set RunArg=no
	)
	goto MainMenu
)
IF %ERRORLEVEL%==7 GOTO:EOF

ENDLOCAL DISABLEDELAYEDEXPANSION
