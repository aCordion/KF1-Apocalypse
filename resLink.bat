
@echo off
cls

pushd "%~dp0"
set rootPath=%cd%

::mklink /j Animations ..\KillingFloor\Animations
::mklink /j KarmaData ..\KillingFloor\KarmaData
::mklink /j Sounds ..\KillingFloor\Sounds
::mklink /j StaticMeshes ..\KillingFloor\StaticMeshes
::mklink /j Textures ..\KillingFloor\Textures

call :FindApocFolders %rootPath%
popd
echo [apoc] Successed resource files link ...
pause
exit /b %errorlevel%


:FindApocFolders
set path=%~1
for /f "tokens=*" %%d in ('dir /b "Apoc*" 2^>nul ^|^|(echo:No Apoc folders to process^)') do (
	call :FindResourcesFolder %path%\%%d %%d
)
exit /b 0


:FindResourcesFolder
set path=%~1
set folder=%~2
pushd "%~dp0"
cd %folder%
for /f "tokens=*" %%d in ('dir /b "*" 2^>nul ^|^|(echo:No resources files to process^)') do (
	if "%%d" == "Resources" (
		call :TravelResourcesFolders %path%\%%d %%d
	)
)
popd
exit /b 0


:TravelResourcesFolders
set path=%~1
set folder=%~2
cd %folder%
for /f "tokens=*" %%d in ('dir /b "*" 2^>nul ^|^|(echo:No resources files to process^)') do (
	if "%%d" == "Animations" call :TravelResoucesFiles %path%\%%d %%d
	if "%%d" == "Sounds" call :TravelResoucesFiles %path%\%%d %%d
	if "%%d" == "StaticMeshes" call :TravelResoucesFiles %path%\%%d %%d
	if "%%d" == "Textures" call :TravelResoucesFiles %path%\%%d %%d
	if "%%d" == "KarmaData" call :TravelResoucesFiles %path%\%%d %%d
)
cd ..
exit /b 0


:TravelResoucesFiles
set path=%~1
set folder=%~2
cd %folder%
for /f "tokens=*" %%f in ('dir /b "*.*" 2^>nul ^|^|(echo:No resources files to process^)') do (
	call :LinkFile %path% %%f
)
cd ..
exit /b 0


:LinkFile
set path=%~1
set aFilename=%~2
set src=%path%\%aFilename%
if "%~x2" == ".ukx" (
	mklink "..\..\..\Animations\%aFilename%" %src%
)
if "%~x2" == ".uax" (
	mklink "..\..\..\Sounds\%aFilename%" %src%
)
if "%~x2" == ".usx" (
	mklink "..\..\..\StaticMeshes\%aFilename%" %src%
)
if "%~x2" == ".utx" (
	mklink "..\..\..\Textures\%aFilename%" %src%
)
exit /b 0