@echo off
REM Phexora Aegis - Local Development Server (Windows)

setlocal EnableExtensions EnableDelayedExpansion

for %%I in ("%~dp0.") do set "PROJECT_ROOT=%%~fI"
set "PAPERS_DIR=%PROJECT_ROOT%\papers\zkprivacy"
set "LIBRARIES_PYTHON=%PROJECT_ROOT%\..\Libraries\Python"
set "STARTUP_WINDOWS_HELPER=%PROJECT_ROOT%\..\Libraries\Scripts\startup_windows.bat"
set "PORT=%~1"

if not exist "%STARTUP_WINDOWS_HELPER%" (
    echo FATAL: Shared Windows startup helper not found at %STARTUP_WINDOWS_HELPER%.
    exit /b 1
)
where py.exe >nul 2>&1
if errorlevel 1 (
    echo FATAL: Windows Python launcher py.exe was not found.
    exit /b 1
)

if not defined PORT (
    set "PORT_OUTPUT=%TEMP%\aegis_preview_port_!RANDOM!!RANDOM!.txt"
    py -3 -c "import sys; sys.path.insert(0, r'%LIBRARIES_PYTHON%'); from ApplicationRegistry import get_application; config = get_application('aegis'); assert config is not None; print(config.local_preview_port)" > "!PORT_OUTPUT!" 2>&1
    if errorlevel 1 (
        type "!PORT_OUTPUT!"
        del "!PORT_OUTPUT!" 2>nul
        echo FATAL: Failed to resolve the Phexora Aegis preview port from ApplicationRegistry.
        exit /b 1
    )
    set /p "PORT="<"!PORT_OUTPUT!"
    del "!PORT_OUTPUT!" 2>nul
)
if not defined PORT (
    echo FATAL: Phexora Aegis preview port is empty.
    exit /b 1
)

call "%STARTUP_WINDOWS_HELPER%" prepare-app-py3 "Phexora Aegis Preview" "%PROJECT_ROOT%" "%PORT%=module:http.server"
set "PORT_GUARD_EXIT=!ERRORLEVEL!"
if "!PORT_GUARD_EXIT!"=="10" exit /b 0
if not "!PORT_GUARD_EXIT!"=="0" exit /b 1

pushd "%PROJECT_ROOT%"

echo ================================================
echo   Phexora Aegis - Privacy, Scalability and Post-Quantum Security Research
echo   Local Development Server
echo ================================================
echo.

set "REBUILD_NEEDED=0"
if not exist "%PAPERS_DIR%\*.md" (
    echo FATAL: No active Markdown papers found in %PAPERS_DIR%.
    popd
    exit /b 1
)
for %%F in ("%PAPERS_DIR%\*.md") do (
    call :needs_rebuild "%%~fF" "%%~dpnF.pdf"
    if not errorlevel 1 set "REBUILD_NEEDED=1"
)

if "!REBUILD_NEEDED!"=="1" (
    echo PDFs missing or outdated. Building automatically...
    echo.

    if not exist "%PROJECT_ROOT%\build-pdfs.bat" (
        echo FATAL: PDF build script not found at %PROJECT_ROOT%\build-pdfs.bat.
        popd
        exit /b 1
    )

    call "%PROJECT_ROOT%\build-pdfs.bat"
    if errorlevel 1 (
        echo.
        echo FATAL: PDF generation failed; local preview was not started.
        popd
        exit /b 1
    )

    echo.
) else (
    echo PDFs are up to date.
    echo.
)

echo Starting local web server...
echo URL: http://127.0.0.1:%PORT%
echo Press Ctrl+C to stop
echo.

py -3 -X startup_owner="%PROJECT_ROOT%" -m http.server "%PORT%" --bind 127.0.0.1
set "SERVER_EXIT_CODE=!ERRORLEVEL!"

popd
endlocal & exit /b %SERVER_EXIT_CODE%

:needs_rebuild
if not exist "%~2" exit /b 0
if not exist "%~1" exit /b 0

set "COMPARE_RESULT="
for /f %%R in ('powershell -NoProfile -Command "$md = Get-Item -LiteralPath '%~1'; $pdf = Get-Item -LiteralPath '%~2'; if ($md.LastWriteTimeUtc -gt $pdf.LastWriteTimeUtc) { 'rebuild' } else { 'current' }" 2^>nul') do set "COMPARE_RESULT=%%R"
if /I "%COMPARE_RESULT%"=="current" exit /b 1
exit /b 0
