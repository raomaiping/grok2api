# 设置 GitHub Container Registry Token

## 问题
如果遇到 `permission_denied: write_package` 错误，需要创建 Personal Access Token (PAT) 并添加到仓库 Secrets。

## 解决步骤

### 1. 创建 Personal Access Token

1. 访问：https://github.com/settings/tokens
2. 点击 **"Generate new token"** → **"Generate new token (classic)"**
3. 填写 Token 名称（如：`GHCR_Push_Token`）
4. 选择过期时间（建议选择较长时间或不过期）
5. **重要：勾选以下权限：**
   - ✅ `write:packages` - 推送包到 GitHub Container Registry
   - ✅ `read:packages` - 从 GitHub Container Registry 读取包
   - ✅ `delete:packages` - 删除包（可选）
6. 点击 **"Generate token"**
7. **立即复制 token**（只显示一次！）

### 2. 添加 Token 到仓库 Secrets

1. 访问：https://github.com/raomaiping/grok2api/settings/secrets/actions
2. 点击 **"New repository secret"**
3. Name: `GHCR_TOKEN`
4. Secret: 粘贴刚才复制的 token
5. 点击 **"Add secret"**

### 3. 验证

推送代码后，GitHub Actions 会自动使用 `GHCR_TOKEN`（如果存在），否则使用 `GITHUB_TOKEN`。

## 备选方案：检查仓库 Actions 权限

如果不想使用 PAT，也可以检查仓库的 Actions 权限：

1. 访问：https://github.com/raomaiping/grok2api/settings/actions
2. 在 "Workflow permissions" 部分：
   - 选择 **"Read and write permissions"**
   - 勾选 **"Allow GitHub Actions to create and approve pull requests"**
3. 点击 **"Save"**

然后重新运行工作流。

