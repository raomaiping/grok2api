# GitHub Container Registry 包清理脚本
# 用于删除旧的 GHCR 包或重新关联仓库权限

param(
    [Parameter(Mandatory=$true)]
    [string]$GitHubToken,
    
    [Parameter(Mandatory=$false)]
    [string]$PackageName = "grok2api",
    
    [Parameter(Mandatory=$false)]
    [string]$Username = "raomaiping",
    
    [Parameter(Mandatory=$false)]
    [switch]$DeletePackage,
    
    [Parameter(Mandatory=$false)]
    [switch]$AddRepositoryAccess
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "GitHub Container Registry 包管理工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 获取包信息
$packageUrl = "https://api.github.com/users/$Username/packages/container/$PackageName"
$headers = @{
    "Authorization" = "Bearer $GitHubToken"
    "Accept" = "application/vnd.github.v3+json"
}

Write-Host "正在检查包: $PackageName..." -ForegroundColor Yellow

try {
    # 获取包列表
    $packagesUrl = "https://api.github.com/user/packages?package_type=container"
    $packages = Invoke-RestMethod -Uri $packagesUrl -Headers $headers -Method Get
    
    $targetPackage = $packages | Where-Object { $_.name -eq $PackageName }
    
    if (-not $targetPackage) {
        Write-Host "未找到包: $PackageName" -ForegroundColor Red
        Write-Host "可能包已被删除或不存在" -ForegroundColor Yellow
        exit 0
    }
    
    $packageId = $targetPackage.id
    Write-Host "找到包 ID: $packageId" -ForegroundColor Green
    
    # 添加仓库访问权限
    if ($AddRepositoryAccess) {
        Write-Host ""
        Write-Host "正在添加仓库访问权限..." -ForegroundColor Yellow
        
        $repoAccessUrl = "https://api.github.com/user/packages/container/$PackageName/permissions"
        $body = @{
            selected_repository_ids = @()  # 需要先获取仓库 ID
        } | ConvertTo-Json
        
        Write-Host "注意: 需要通过 GitHub Web UI 手动添加仓库访问权限" -ForegroundColor Yellow
        Write-Host "访问: https://github.com/users/$Username/packages/container/$PackageName/settings" -ForegroundColor Cyan
        Write-Host "在 'Manage Actions access' 部分添加仓库" -ForegroundColor Cyan
    }
    
    # 删除包
    if ($DeletePackage) {
        Write-Host ""
        Write-Host "警告: 即将删除包 $PackageName (ID: $packageId)" -ForegroundColor Red
        $confirm = Read-Host "确认删除? (输入包名 '$PackageName' 确认)"
        
        if ($confirm -eq $PackageName) {
            Write-Host "正在删除包..." -ForegroundColor Yellow
            $deleteUrl = "https://api.github.com/user/packages/container/$PackageName"
            Invoke-RestMethod -Uri $deleteUrl -Headers $headers -Method Delete
            Write-Host "包已成功删除!" -ForegroundColor Green
        } else {
            Write-Host "取消删除操作" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "操作完成!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    
} catch {
    Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "如果遇到权限错误，请确保:" -ForegroundColor Yellow
    Write-Host "1. GitHub Token 具有 'delete:packages' 权限" -ForegroundColor Yellow
    Write-Host "2. Token 已正确设置" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "建议通过 Web UI 手动操作:" -ForegroundColor Cyan
    Write-Host "访问: https://github.com/users/$Username/packages/container/$PackageName/settings" -ForegroundColor Cyan
    exit 1
}

