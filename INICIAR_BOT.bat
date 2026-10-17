@echo off
setlocal
cd /d "%~dp0"

chcp 65001 >nul 2>nul

echo.
echo ================================================================
echo   BOT IQ OPTION - V109.4 FRESH PAYOUT PROOF + FALLBACK TRUTH + ELITE GUARD
echo ================================================================
echo   Backend unico: iqbot_server.py
echo   Ollama: http://127.0.0.1:11434
echo   Trader: lumi-trader-fast:4b ^(base qwen3:4b-instruct^)
echo   Analyst: qwen3:14b
echo ================================================================
echo.

where python >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Python nao encontrado no PATH.
    echo Instale o Python 3 e execute este BAT novamente.
    echo.
    pause
    exit /b 1
)

python -c "import flask, flask_cors, requests; import iqoptionapi.stable_api" >nul 2>nul
if errorlevel 1 (
    echo [PYTHON] Dependencias ausentes; instalando requirements.txt...
    python -m pip install -r "%~dp0requirements.txt"
    if errorlevel 1 (
        echo [ERRO] Falha ao instalar dependencias Python.
        pause
        exit /b 1
    )
) else (
    echo [PYTHON] OK: dependencias do bot disponiveis.
)

where ollama >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Ollama nao encontrado no PATH.
    echo Instale/inicie o Ollama e execute este BAT novamente.
    echo.
    pause
    exit /b 1
)

echo [LUMI] Verificando modelo ULTRA-FAST...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar_lumi_trader_fast.ps1"
if errorlevel 1 (
    echo.
    echo [ERRO] Nao foi possivel preparar a Lumi ULTRA-FAST.
    echo O bot nao sera iniciado para evitar usar a base antiga.
    echo.
    pause
    exit /b 1
)

echo.
echo [BOT] Lumi ULTRA-FAST validada + Fresh Payout Proof V109.4 + Fallback Truth Sync + Elite Guard. Iniciando servidor...
echo [LOGIN] Recovery V108.8.3 preservado: correcao upstream WebSocket/JSON/SSID habilitada.
echo [LEARNING] V109.4: Fresh Payout Proof + Fallback Truth Sync + Elite Scan Guard + Decision History + ALI 2.7 + Preflight JIT.
echo.
python iqbot_server.py

echo.
echo [BOT] Servidor encerrado.
pause
