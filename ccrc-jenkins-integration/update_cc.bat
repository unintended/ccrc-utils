@echo off
setlocal EnableDelayedExpansion

rem !!!TODO!!! set these values
set SERVER_URL=
set USERNAME=
set PASSWORD=
set REPO_DIR=%1

set command=rcleartool update -server %SERVER_URL% -username %USERNAME% -password %PASSWORD% %REPO_DIR%
rem set command=cat P:\cc_succ.log
set command="%command% 2>&1"

set ret_code=-1
set lc=0
set success=0

echo updating repository %REPO_DIR%...

for /f "usebackq delims=%%" %%i in (`%command%`) do (
  echo output: %%i

  rem check for error
  echo %%i | findstr /r /c:"^CR" > NUL
  if !errorlevel! EQU 0 goto onError

  rem count changes
  echo %%i | findstr /r /c:"^(L|Unl)oading" > NUL
  if !errorlevel! EQU 0 set /a lc=lc + 1

  rem found success marker
  echo %%i | findstr /r /c:"^Done Loading" > NUL
  if !errorlevel! EQU 0 set success=1
)
echo changes count: %lc%, success marker: %success%

IF %lc% GEQ 1 goto onChangesFound

goto return

:onChangesFound
echo found %lc% changes
set ret_code=0
goto return

:onError
echo update completed with error
set ret_code=-99
goto return

:return
echo exiting with code %ret_code%
exit /B %RET_CODE%
