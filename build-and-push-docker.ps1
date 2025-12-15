# Docker镜像构建和推送脚本 (PowerShell版本)
# 使用方法: .\build-and-push-docker.ps1 [tag]
# 如果不提供tag，默认使用latest

param(
    [string]$Tag = "latest"
)

$ImageName = "ghcr.io/raomaiping/grok2api"
$FullImageName = "${ImageName}:${Tag}"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "开始构建Docker镜像: $FullImageName" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 构建镜像
docker build -t $FullImageName .

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 镜像构建失败！" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "镜像构建成功！" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

# 询问是否推送到远程仓库
$push = Read-Host "是否推送到远程仓库 (ghcr.io)? (y/n)"

if ($push -eq "y" -or $push -eq "Y") {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "开始推送镜像到远程仓库..." -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # 推送镜像
    docker push $FullImageName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✅ 镜像推送成功！" -ForegroundColor Green
        Write-Host "镜像地址: $FullImageName" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "❌ 镜像推送失败！" -ForegroundColor Red
        Write-Host "提示: 请确保已登录到GitHub Container Registry" -ForegroundColor Yellow
        Write-Host "登录命令: `$env:GITHUB_TOKEN | docker login ghcr.io -u raomaiping --password-stdin" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "跳过推送，镜像已构建完成: $FullImageName" -ForegroundColor Yellow
}

