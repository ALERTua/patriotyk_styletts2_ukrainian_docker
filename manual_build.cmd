
@echo off
setlocal enabledelayedexpansion enableextensions

if not defined DOCKER_HOSTNAME set DOCKER_HOSTNAME=docker
if not defined DOCKER_HOST set DOCKER_HOST=tcp://%DOCKER_HOSTNAME%:2375
if not defined STAGE set STAGE=production
if not defined DOCKERFILE set DOCKERFILE=Dockerfile
set TAG_BASE=ghcr.io/alertua/patriotyk_styletts2_ukrainian_docker
set TAG_BASE_DOCKERHUB=alertua/patriotyk_styletts2_ukrainian_docker


choice /C YN /m "latest?"
if "%errorlevel%"=="1" (
    set TAG=%TAG_BASE%:latest
    set TAG_DOCKERHUB=%TAG_BASE_DOCKERHUB%:latest
) else (
    choice /C YN /m "all?"
    if "!errorlevel!"=="1" (
        set TAG=%TAG_BASE%:all
        set TAG_DOCKERHUB=%TAG_BASE_DOCKERHUB%:all
    ) else (
        echo no option given
        exit /b 1
    )

)

choice /C YN /d N /T 15 /m "Build %TAG%?"
if "%errorlevel%"=="1" (
    docker build -f %DOCKERFILE% --target %STAGE% -t %TAG% -t %TAG_DOCKERHUB% .
)

choice /C YN /m "Push %TAG%?"
if "%errorlevel%"=="1" (
    docker push %TAG_DOCKERHUB%
    docker push %TAG%
)
