
@echo off
cls

echo [apoc] Remove Apoc-Mutator files...

del /q /f System\ApocCharacterPack.u*
del /q /f System\ApocWeaponPack.u*
del /q /f System\ApocZEDPack.u*
del /q /f System\ApocMutators.u*

echo [apoc] Building...
System\ucc.exe make

del /q /f System\steam_appid.txt
echo [apoc] Build successed...