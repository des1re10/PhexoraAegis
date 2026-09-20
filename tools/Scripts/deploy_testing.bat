@echo off
setlocal EnableExtensions

call "%~dp0..\..\..\Libraries\Scripts\deploy_registered_app_to_cloud.bat" "PhexoraAegis" "%~1" "%~2"
set "DEPLOY_EXIT_CODE=%ERRORLEVEL%"

endlocal & exit /b %DEPLOY_EXIT_CODE%
