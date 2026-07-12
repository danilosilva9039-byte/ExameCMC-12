@echo off
setlocal enabledelayedexpansion
title Git Pull Avancado e Automatizado

:: Garante que o script roda na pasta onde ele esta localizado
cd /d "%~dp0"

echo ====================================================
echo        GIT PULL AUTOMATICO COM CONFIGURACOES
echo ====================================================
echo.

:: 1. Verificar se e um repositorio valido
git rev-parse --is-inside-work-tree >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo [ERRO] Esta pasta nao eh um repositorio Git valido.
    echo Certifique-se de que este arquivo .bat esta dentro da pasta do projeto clonado.
    echo.
    pause
    exit /b
)

:: 2. Capturar automaticamente a branch ativa (ex: structure, main, etc.)
for /f "delims=" %%i in ('git branch --show-current') do set BRANCH=%%i
if "%BRANCH%"=="" (
    for /f "tokens=2 delims=* " %%i in ('git branch ^| findstr /b "*"') do set BRANCH=%%i
)

echo [INFO] Branch ativa detectada: %BRANCH%

:: 3. BUROCRACIA DO PULL: Configurar a estrategia de reconciliacao padrao do Git
:: Evita o famoso aviso irritante de "divergent branches" exigindo rebase ou merge explicito.
git config pull.rebase >nul 2>&1
if %errorlevel% neq 0 (
    echo [CONFIG] Definindo estrategia padrao de sincronizacao como 'merge' (padrao seguro).
    git config --local pull.rebase false
)

echo.
echo [INFO] Puxando atualizacoes do GitHub especificas da branch '%BRANCH%'...
echo.

:: Puxa garantindo o vinculo correto com a branch remota correspondente
git pull origin %BRANCH%

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo [SUCESSO] Sua branch '%BRANCH%' esta 100%% sincronizada e atualizada!
) else (
    color 0C
    echo.
    echo [ERRO] Ocorreu um erro ao tentar fazer o pull.
    echo Se houver arquivos modificados localmente que conflitam com o GitHub, resolva os conflitos primeiro.
)

echo.
pause