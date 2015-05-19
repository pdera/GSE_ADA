@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion

REM script to automate indexing with cell_now
REM 2015-02-14 pd


SET CELL="C:\Users\przemyslaw\Dropbox (UH Mineral Physics)\software\RSV_mSXD 2.5\cell_now.exe"
SET COMM="C:\Users\przemyslaw\Dropbox (UH Mineral Physics)\software\RSV_mSXD 2.5\cell_now_commands.txt"

REM select project file
SET PROJ=xxx.p4p

REM announce target

ECHO Processing %PROJ% ...

ECHO %CELL% 
%CELL% < %COMM%

REM done
ENDLOCAL
ECHO ON
