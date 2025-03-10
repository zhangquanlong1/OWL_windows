@echo off
setlocal enabledelapsedexpansion

:: 阶段1：环境初始化
title OWL项目启动器
color 0A
set "PROJECT_ROOT=%~dp0"
cd /d "%PROJECT_ROOT%"

:: 阶段2：虚拟环境检测
if not exist ".venv\" (
    echo █ 正在初始化虚拟环境...
    uv venv .venv --python=3.10 || (
        echo ? 环境创建失败，尝试传统方式...
        python -m venv .venv
    )
    
    echo █ 安装核心依赖...
    call .venv\Scripts\activate.bat
    uv pip install -e . --retry 3 || (
        echo ? UV安装失败，切换PIP安装...
        pip install -r requirements.txt
    )
    playwright install chromium
    deactivate
)

:: 阶段3：环境变量配置
if not exist ".env" (
    echo █ 生成环境配置文件...
    copy /Y .env_template .env >nul
    start notepad .env
    echo ? 请填写API密钥后重新启动！
    pause
    exit
)

:: 阶段4：服务启动
call .venv\Scripts\activate.bat
start http://localhost:7860
python run_app.py

:: 异常处理
if %errorlevel% neq 0 (
    echo ? 启动失败，错误代码：%errorlevel%
    pause
)