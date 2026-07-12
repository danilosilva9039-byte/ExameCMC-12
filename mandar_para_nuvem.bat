@echo off
setlocal enabledelayedexpansion
title Git Push Avancado e Automatizado

:: Garante que o script roda na pasta onde ele esta localizado
cd /d "%~dp0"

echo ====================================================
echo        GIT PUSH AUTOMATICO COM CONFIGURACOES
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

:: 2. BUROCRACIA 1: Verificar se Nome e Email estao configurados no Git (essencial para o Commit)
git config user.name >nul 2>&1
if %errorlevel% neq 0 (
    color 0E
    echo [CONFIG] Identidade do Git nao encontrada!
    set /p git_name="Digite o seu Nome do GitHub: "
    git config --global user.name "!git_name!"
    echo [OK] Nome configurado globalmente.
    echo.
)

git config user.email >nul 2>&1
if %errorlevel% neq 0 (
    color 0E
    set /p git_email="Digite o seu Email do GitHub: "
    git config --global user.email "!git_email!"
    echo [OK] Email configurado globalmente.
    echo.
)

:: Restaurar cor padrao apos configuracoes iniciais
color 0F

:: 3. BUROCRACIA 2: Capturar automaticamente a branch ativa (ex: structure, main, etc.)
for /f "delims=" %%i in ('git branch --show-current') do set BRANCH=%%i
if "%BRANCH%"=="" (
    for /f "tokens=2 delims=* " %%i in ('git branch ^| findstr /b "*"') do set BRANCH=%%i
)

echo [INFO] Branch ativa detectada: %BRANCH%
echo ====================================================
echo.

:: 4. Mostrar alteracoes atuais
echo [INFO] Verificando arquivos alterados...
git status -s
echo.

:: 5. Pedir a mensagem do commit
set /p commit_msg="Digite a mensagem do commit (ou pressione Enter para 'Update automatico na branch %BRANCH%'): "

if "%commit_msg%"=="" (
    set commit_msg=Update automatico na branch %BRANCH%
)

:: 6. Executar os procedimentos em cadeia do Git
echo.
echo [1/3] Adicionando alteracoes (git add .)...
git add .

echo.
echo [2/3] Criando o commit formal (git commit)...
git commit -m "%commit_msg%"

echo.
echo [3/3] Enviando e vinculando a branch remota (git push -u origin %BRANCH%)...
:: A flag -u resolve a burocracia de "no upstream branch", vinculando sua branch local a do GitHub permanentemente
git push -u origin %BRANCH%

if %errorlevel% equ 0 (
    color 0A
    echo.
    echo [SUCESSO] Procedimento completo concluido com sucesso na branch: %BRANCH%!
) else (
    color 0C
    echo.
    echo [ERRO] Ocorreu um erro ao tentar fazer o push.
    echo Verifique se voce tem permissoes na branch '%BRANCH%' ou se precisa fazer um PULL primeiro.
)

echo.
pause