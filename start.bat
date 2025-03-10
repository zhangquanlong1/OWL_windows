@echo off
setlocal enabledelapsedexpansion

:: �׶�1��������ʼ��
title OWL��Ŀ������
color 0A
set "PROJECT_ROOT=%~dp0"
cd /d "%PROJECT_ROOT%"

:: �׶�2�����⻷�����
if not exist ".venv\" (
    echo �� ���ڳ�ʼ�����⻷��...
    uv venv .venv --python=3.10 || (
        echo ? ��������ʧ�ܣ����Դ�ͳ��ʽ...
        python -m venv .venv
    )
    
    echo �� ��װ��������...
    call .venv\Scripts\activate.bat
    uv pip install -e . --retry 3 || (
        echo ? UV��װʧ�ܣ��л�PIP��װ...
        pip install -r requirements.txt
    )
    playwright install chromium
    deactivate
)

:: �׶�3��������������
if not exist ".env" (
    echo �� ���ɻ��������ļ�...
    copy /Y .env_template .env >nul
    start notepad .env
    echo ? ����дAPI��Կ������������
    pause
    exit
)

:: �׶�4����������
call .venv\Scripts\activate.bat
start http://localhost:7860
python run_app.py

:: �쳣����
if %errorlevel% neq 0 (
    echo ? ����ʧ�ܣ�������룺%errorlevel%
    pause
)