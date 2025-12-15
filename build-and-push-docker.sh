#!/bin/bash

# Docker镜像构建和推送脚本
# 使用方法: ./build-and-push-docker.sh [tag]
# 如果不提供tag，默认使用latest

IMAGE_NAME="ghcr.io/raomaiping/grok2api"
TAG=${1:-latest}
FULL_IMAGE_NAME="${IMAGE_NAME}:${TAG}"

echo "=========================================="
echo "开始构建Docker镜像: ${FULL_IMAGE_NAME}"
echo "=========================================="

# 构建镜像
docker build -t ${FULL_IMAGE_NAME} .

if [ $? -ne 0 ]; then
    echo "❌ 镜像构建失败！"
    exit 1
fi

echo ""
echo "=========================================="
echo "镜像构建成功！"
echo "=========================================="
echo ""

# 询问是否推送到远程仓库
read -p "是否推送到远程仓库 (ghcr.io)? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "=========================================="
    echo "开始推送镜像到远程仓库..."
    echo "=========================================="
    
    # 推送镜像
    docker push ${FULL_IMAGE_NAME}
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ 镜像推送成功！"
        echo "镜像地址: ${FULL_IMAGE_NAME}"
    else
        echo ""
        echo "❌ 镜像推送失败！"
        echo "提示: 请确保已登录到GitHub Container Registry"
        echo "登录命令: echo \$GITHUB_TOKEN | docker login ghcr.io -u raomaiping --password-stdin"
        exit 1
    fi
else
    echo "跳过推送，镜像已构建完成: ${FULL_IMAGE_NAME}"
fi

