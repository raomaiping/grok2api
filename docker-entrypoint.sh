#!/bin/sh

# 初始化脚本 - 确保必要的配置文件存在

echo "正在初始化 Grok2API..."

# 创建必要的目录
mkdir -p /app/data/temp/image /app/data/temp/video

# 如果 token.json 不存在则创建默认文件
if [ ! -f /app/data/token.json ]; then
    echo "创建默认 token.json 文件..."
    echo '{"ssoNormal": {}, "ssoSuper": {}}' > /app/data/token.json
    echo "✓ token.json 已创建"
else
    echo "✓ token.json 已存在"
fi

# 如果 setting.toml 不存在则从镜像复制
if [ ! -f /app/data/setting.toml ]; then
    if [ -f /app/data/setting.toml.default ]; then
        echo "复制默认 setting.toml 文件..."
        cp /app/data/setting.toml.default /app/data/setting.toml
        echo "✓ setting.toml 已创建"
    fi
else
    echo "✓ setting.toml 已存在"
fi

echo "初始化完成,启动服务..."
echo "========================================"

# 启动应用
exec python -m uvicorn main:app --host 0.0.0.0 --port 8000
