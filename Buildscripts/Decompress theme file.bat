@echo off
cls
echo HiBy R3PRO Theme pack decompression tool.
echo Usage:
echo Put the theme pack in the same directory as this batch file
echo Theme files will be extracted in "Decompressed theme" subfolder
echo Files with the same name will be overwritten!!
echo ---------------------------------------------------
set ver=
set /p ver=Enter Theme name to extract:

7z x -y %ver%.t -o"Decompressed theme\"
