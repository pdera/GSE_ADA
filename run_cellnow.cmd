@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
REM script to automate indexing with cell_now
REM 2015-02-14 pd
SET CELL="cell_now.exe"
SET COMM="cell_now_commands.txt"

SET PROJ=xxx.p4p
cd ""
REM announce target
ECHO Processing %PROJ% ...
ECHO %CELL%
%CELL% < %COMM%
REM done
ENDLOCAL
ECHO ON
