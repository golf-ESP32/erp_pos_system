@echo off
title ERP/POS System Launcher
echo =========================================
echo    Starting ERP/POS System Services
echo =========================================
echo.

:: 1. Start Backend Server (If applicable)
echo [1/2] Starting Backend Server...
start "Backend API Server" cmd /k "cd /d D:\erp_pos_system\apps\backend && npm start"

:: 2. Start Flutter Web Frontend
echo [2/2] Starting Flutter Frontend Application...
start "Flutter Frontend" cmd /k "cd /d D:\erp_pos_system\apps\erp_pos_flutter && flutter run -d chrome"

echo.
echo =========================================
echo  All services are launching in background.
echo =========================================
pause