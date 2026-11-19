@echo off
echo ========================================
echo   Ejecutando publicacion automatica
echo ========================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0publicar_usuario_auto.ps1"
echo.
echo Presiona cualquier tecla para salir...
pause >nul
