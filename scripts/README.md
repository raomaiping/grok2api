# GHCR 包清理脚本使用说明

这些脚本用于清理或管理 GitHub Container Registry (GHCR) 中的旧包，解决权限问题。

## 问题说明

当删除并重新创建同名仓库后，GHCR 中的容器包可能仍然存在，但失去了与新仓库的关联，导致推送失败并出现 `permission_denied: write_package` 错误。

## 解决方案

### 方案 1: 使用 PowerShell 脚本 (Windows)

```powershell
# 需要 GitHub Personal Access Token (需要 delete:packages 权限)
.\scripts\cleanup-ghcr-package.ps1 -GitHubToken "your_token_here" -DeletePackage

# 或者只查看包信息
.\scripts\cleanup-ghcr-package.ps1 -GitHubToken "your_token_here"
```

### 方案 2: 使用 Python 脚本

```bash
# 安装依赖
pip install requests

# 删除包
python scripts/cleanup-ghcr-package.py --token "your_token_here" --delete

# 查看包信息
python scripts/cleanup-ghcr-package.py --token "your_token_here"
```

### 方案 3: 通过 GitHub Web UI (推荐，最简单)

1. 访问: https://github.com/users/raomaiping/packages/container/grok2api
2. 点击 `Package settings`
3. 选择以下操作之一:
   - **重新关联仓库**: 在 `Manage Actions access` 部分添加 `raomaiping/grok2api` 仓库，设置权限为 `Write`
   - **删除包**: 滚动到底部 `Danger Zone`，点击 `Delete this package`，输入包名确认

## 获取 GitHub Token

1. 访问: https://github.com/settings/tokens
2. 点击 `Generate new token` > `Generate new token (classic)`
3. 设置权限:
   - `delete:packages` (删除包)
   - `read:packages` (读取包信息)
4. 生成并复制 Token

## 注意事项

- 删除包是不可逆操作，请谨慎操作
- 如果包中有重要镜像，建议先备份
- 删除包后，需要重新推送才能创建新包
- 确保仓库的 Actions 权限设置为 `Read and write permissions`

## 验证修复

删除包或重新关联权限后:

1. 确保仓库 Actions 权限正确: https://github.com/raomaiping/grok2api/settings/actions
2. 重新运行 GitHub Actions 工作流
3. 检查推送是否成功

