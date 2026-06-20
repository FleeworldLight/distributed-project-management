# DPM - Docker 构建与运行脚本
# 用法: .\build-and-run.ps1 [command]
#   build   - 编译所有服务并构建 Docker 镜像
#   up      - 启动所有容器
#   down    - 停止并删除所有容器
#   rebuild - build + up (全量重建)

param(
    [string]$command = "rebuild"
)

$ROOT = $PSScriptRoot

function Build-Jars {
    Write-Host "=== 编译所有模块 ===" -ForegroundColor Cyan
    Set-Location $ROOT
    mvn package -DskipTests -q
    if ($LASTEXITCODE -ne 0) {
        Write-Host "编译失败!" -ForegroundColor Red
        exit 1
    }
    Write-Host "编译成功" -ForegroundColor Green
}

function Build-Docker {
    Write-Host "=== 构建 Docker 镜像 ===" -ForegroundColor Cyan
    docker compose build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker 构建失败!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Docker 镜像构建成功" -ForegroundColor Green
}

function Start-Containers {
    Write-Host "=== 启动所有容器 ===" -ForegroundColor Cyan
    docker compose up -d
    if ($LASTEXITCODE -ne 0) {
        Write-Host "启动失败!" -ForegroundColor Red
        exit 1
    }
    Write-Host "=== 启动完成 ===" -ForegroundColor Green
    Write-Host "Eureka:  http://localhost:8761" -ForegroundColor Yellow
    Write-Host "Gateway: http://localhost:6880" -ForegroundColor Yellow
    Write-Host "Monitor: http://localhost:6888" -ForegroundColor Yellow
}

function Stop-Containers {
    Write-Host "=== 停止并清理 ===" -ForegroundColor Cyan
    docker compose down
    Write-Host "已清理" -ForegroundColor Green
}

switch ($command) {
    "build" {
        Build-Jars
        Build-Docker
    }
    "up" {
        Start-Containers
    }
    "down" {
        Stop-Containers
    }
    "rebuild" {
        Build-Jars
        Build-Docker
        Start-Containers
    }
    default {
        Write-Host "用法: .\build-and-run.ps1 [build|up|down|rebuild]" -ForegroundColor Yellow
    }
}
