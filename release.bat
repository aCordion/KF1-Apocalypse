
@echo off
cls
set SERVER_DRV=K:

mkdir %SERVER_DRV%\Downloads

::for /f "tokens=*" %%d in ('dir /b "Apoc*" 2^>nul ^|^|(echo:No Apoc folders to process^)') do (
::	call :CopyResources %%d
::)

::call :CopyResources ApocCharacterPack
::call :CopyResources ApocMutators
::call :CopyResources ApocWeaponPack
::call :CopyResources ApocZEDPack
call :CopyApocMutatorFiles

exit /b %errorlevel%


:CopyResources
set src=%cd%\%~1
set dst=%SERVER_DRV%\%~1
rd /s /q %dst%
c:\windows\system32\xcopy.exe /f /s /y /i %src% %dst%
rd /s /q %dst%\Assets
rd /s /q %dst%\Classes
del /q %dst%\*.md
exit /b 0


:CopyApocMutatorFiles
del /q %SERVER_DRV%\ApocMutators\Resources\System\Apoc*.u*
c:\windows\system32\xcopy.exe /f /s /y /i System\Apoc*.u* %SERVER_DRV%\ApocMutators\Resources\System
exit /b 0
