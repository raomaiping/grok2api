# GitHub Actions Docker 构建说明

## 权限问题排查

如果遇到 `permission_denied: write_package` 错误，请按以下步骤检查：

### 1. 检查仓库 Actions 权限设置

1. 访问：`https://github.com/raomaiping/grok2api/settings/actions`
2. 在 "Workflow permissions" 部分：
   - 选择 **"Read and write permissions"**
   - 勾选 **"Allow GitHub Actions to create and approve pull requests"**（如果需要）

### 2. 检查包可见性设置

1. 访问：`https://github.com/raomaiping/grok2api/settings`
2. 在左侧菜单找到 "Packages" 或访问：`https://github.com/orgs/raomaiping/packages`
3. 确保包的可见性设置正确

### 3. 如果使用组织仓库

如果是组织仓库，需要：
1. 访问组织设置：`https://github.com/organizations/raomaiping/settings/actions`
2. 确保 "Workflow permissions" 设置为允许写入

### 4. 使用 Personal Access Token（备选方案）

如果 `GITHUB_TOKEN` 仍然无法工作，可以：

1. 创建 Personal Access Token (PAT)：
   - 访问：`https://github.com/settings/tokens`
   - 创建新 token，权限包括：`write:packages`, `read:packages`, `delete:packages`

2. 在仓库中添加 Secret：
   - 访问：`https://github.com/raomaiping/grok2api/settings/secrets/actions`
   - 添加名为 `GHCR_TOKEN` 的 secret

3. 修改工作流文件，将 `secrets.GITHUB_TOKEN` 改为 `secrets.GHCR_TOKEN`

