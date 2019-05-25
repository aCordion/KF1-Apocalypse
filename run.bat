
@echo off
cls

set MAP=KF-IceCave
set GAME=ApocMutators.ApocGameType
set OPTIONS=-log=server.log
set MUTATOR=ApocMutators.ApocMutatorLoader

System\KillingFloor.exe ^
%MAP%?game=%GAME%?VACSecured=true?Mutator=%MUTATOR% %OPTIONS%
