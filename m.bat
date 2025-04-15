@echo off
title Installing Python & Dependencies

:: Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -command "Start-Process '%~f0' -Verb RunAs"
    exit
)

echo Checking for Python installation...

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Downloading and installing silently...
    curl -o "%TEMP%\python-installer.exe" https://www.python.org/ftp/python/3.12.1/python-3.12.1.exe
    start /wait "%TEMP%\python-installer.exe" /quiet InstallAllUsers=1 PrependPath=1
    :: Give the installer a little time to update the PATH
    timeout /t 10 >nul
    echo Python installed successfully.
) else (
    echo Python is already installed.
)

:: Ensure pip is installed and upgrade it
python -m ensurepip --default-pip
python -m pip install --upgrade pip

:: Install missing dependencies individually
:: pywin32: imported as win32api
python -c "import win32api" 2>nul || python -m pip install pywin32

:: pycryptodome: install as 'pycryptodome', but import as Crypto
python -c "import Crypto" 2>nul || python -m pip install pycryptodome

:: requests: module name remains the same
python -c "import requests" 2>nul || python -m pip install requests

echo All dependencies installed.
pause
exit
