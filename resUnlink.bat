
@echo off
cls

pushd "%~dp0"
call :UnlinkResourceFiles Animations
call :UnlinkResourceFiles Sounds
call :UnlinkResourceFiles StaticMeshes
call :UnlinkResourceFiles Textures
popd
echo [apoc] Successed resource files unlink ...
pause
exit /b %errorlevel%

:UnlinkResourceFiles
cd %~1
for /f "tokens=4,5 delims= " %%a in ('dir "*.*" 2^>nul ^|^|(echo:No resources files to process^)') do (
	if "%%a" EQU "<SYMLINK>" (
		echo Unlink file [%%b]
		del %%b
	)
)
cd ..
exit /b 0
