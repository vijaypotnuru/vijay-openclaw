@echo off
:: ============================================================
:: OpenClaw Employee Setup - One-Click Installer
:: STEP 1: Put this .bat file next to openclaw-employee-setup.ps1
:: STEP 2: Right-click this file -> Run as Administrator
:: ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   OpenClaw Employee Setup
echo ============================================================
echo.

powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0openclaw-employee-setup.ps1"

echo.
pause
