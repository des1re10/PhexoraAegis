@echo off
REM Phexora Aegis - PDF Build Script (Windows)
REM Converts active root-level Markdown papers to PDF using DocWizard-Pro

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "DOCWIZARD_ROOT=%SCRIPT_DIR%..\DocWizard-Pro"
set "DOCWIZARD_SCRIPT=%DOCWIZARD_ROOT%\Src\universal_converter.py"
set "DOCWIZARD_PYTHON=%DOCWIZARD_ROOT%\.venv\Scripts\python.exe"
set "PAPERS_DIR=%SCRIPT_DIR%papers\zkprivacy"

echo ================================================
echo   Phexora Aegis - PDF Build Script
echo ================================================
echo.

REM Check if DocWizard-Pro exists
if not exist "%DOCWIZARD_SCRIPT%" (
    echo ERROR: DocWizard-Pro not found at: %DOCWIZARD_SCRIPT%
    echo        Make sure DocWizard-Pro is in the same parent directory as Phexora Aegis
    exit /b 1
)

if not exist "%DOCWIZARD_PYTHON%" (
    echo ERROR: DocWizard-Pro Python runtime not found at: %DOCWIZARD_PYTHON%
    echo        Prepare the DocWizard-Pro .venv before building Phexora Aegis PDFs
    exit /b 1
)

REM Check if Pandoc is installed
where pandoc >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: Pandoc is not installed
    echo        Install from: https://pandoc.org/installing.html
    exit /b 1
)

if not exist "%PAPERS_DIR%\*.md" (
    echo ERROR: No active Markdown papers found in: %PAPERS_DIR%
    exit /b 1
)

set /a "PAPER_COUNT=0"
for %%F in ("%PAPERS_DIR%\*.md") do set /a "PAPER_COUNT+=1"

echo Building !PAPER_COUNT! active paper PDF(s)...
echo.

set /a "PAPER_INDEX=0"
for %%F in ("%PAPERS_DIR%\*.md") do (
    set /a "PAPER_INDEX+=1"
    echo [!PAPER_INDEX!/!PAPER_COUNT!] Converting %%~nxF...
    "%DOCWIZARD_PYTHON%" "%DOCWIZARD_SCRIPT%" "%%~fF" "%%~dpnF.pdf"

    if errorlevel 1 (
        echo       FAILED: %%~nF.pdf
        exit /b 1
    )

    echo       Done: %%~nF.pdf
)

echo.
echo ================================================
echo   Build complete!
echo   PDFs generated in: %PAPERS_DIR%
echo ================================================

endlocal
