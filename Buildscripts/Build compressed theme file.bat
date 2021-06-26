@echo off
cls
echo -------------------------- HiBy R3PRO Theme compression tool ---------------------
echo=
echo Step one: Edit version.txt in this folder
echo Step two: Enter a name of the theme package. [NO SPACES] [File extension *.t will be added!]
echo Step three: Press the Enter button.
echo=
echo Theme file XXX.t will be generated.
echo=
echo ------------------------------ Use theme pack on player --------------------------------
echo=
echo (1) Manually create a "theme" folder in the Micro SD card root directory.
echo (2) Copy the generated theme package *.t into the theme directory of the SD card.
echo (3) Insert the SD card containing the theme package into the R3PRO machine.
echo (4) Click ^<System Settings^>--^<Theme Style^>--^<Use custom Theme^> on R3PRO, and select the corresponding theme.
echo=
set ver="MaterialDesign"
:: set /p ver=Enter a Theme name (NO SPACES): 

set base_dir="..\GUI Simulator"

echo Copying theme data to temp directory...
rmdir /S /Q font layout theme  >nul 2>nul
del font layout theme  >nul 2>nul
mkdir font layout theme
xcopy %base_dir%\data\res\R3PRO\fonts font /E /Y  >nul 2>nul
xcopy %base_dir%\data\res\R3PRO\layout\theme2 layout /E /Y >nul 2>nul
xcopy %base_dir%\data\res\R3PRO\litegui\theme2 theme /E /Y >nul 2>nul


echo Generating compressed file...
7z a -tzip -mx0 ..\Builds\R3PRO\%ver%.t font layout theme ..\Builds\R3PRO\version.txt  >nul 2>nul


echo Removing temp directories...
rmdir /S /Q font layout theme  >nul 2>nul
del font layout theme  >nul 2>nul


echo Generated complete: %ver%.t
pause
