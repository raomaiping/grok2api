#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GitHub Container Registry 包清理脚本
用于删除旧的 GHCR 包或重新关联仓库权限
"""

import requests
import sys
import json
from typing import Optional


def get_package_info(token: str, username: str, package_name: str) -> Optional[dict]:
    """获取包信息"""
    url = "https://api.github.com/user/packages"
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    params = {"package_type": "container"}
    
    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        
        packages = response.json()
        for package in packages:
            if package.get("name") == package_name:
                return package
        return None
    except requests.exceptions.RequestException as e:
        print(f"❌ 获取包信息失败: {e}")
        return None


def delete_package(token: str, package_name: str) -> bool:
    """删除包"""
    url = f"https://api.github.com/user/packages/container/{package_name}"
    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    try:
        response = requests.delete(url, headers=headers)
        response.raise_for_status()
        return True
    except requests.exceptions.RequestException as e:
        print(f"❌ 删除包失败: {e}")
        if response.status_code == 404:
            print("   包可能不存在或已被删除")
        elif response.status_code == 403:
            print("   权限不足，请确保 Token 具有 'delete:packages' 权限")
        return False


def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="清理 GitHub Container Registry 包")
    parser.add_argument("--token", required=True, help="GitHub Personal Access Token")
    parser.add_argument("--package", default="grok2api", help="包名称 (默认: grok2api)")
    parser.add_argument("--username", default="raomaiping", help="GitHub 用户名")
    parser.add_argument("--delete", action="store_true", help="删除包")
    parser.add_argument("--add-repo", action="store_true", help="添加仓库访问权限 (需要通过 Web UI)")
    
    args = parser.parse_args()
    
    print("=" * 50)
    print("GitHub Container Registry 包管理工具")
    print("=" * 50)
    print()
    
    # 检查包是否存在
    print(f"🔍 正在检查包: {args.package}...")
    package_info = get_package_info(args.token, args.username, args.package)
    
    if not package_info:
        print(f"❌ 未找到包: {args.package}")
        print("   可能包已被删除或不存在")
        return 0
    
    print(f"✅ 找到包 ID: {package_info.get('id')}")
    print(f"   包名: {package_info.get('name')}")
    print(f"   可见性: {package_info.get('visibility', 'unknown')}")
    print()
    
    # 添加仓库访问权限
    if args.add_repo:
        print("ℹ️  添加仓库访问权限需要通过 GitHub Web UI 手动操作")
        print(f"   访问: https://github.com/users/{args.username}/packages/container/{args.package}/settings")
        print("   在 'Manage Actions access' 部分添加仓库")
        print()
    
    # 删除包
    if args.delete:
        print(f"⚠️  警告: 即将删除包 {args.package}")
        confirm = input(f"   确认删除? (输入包名 '{args.package}' 确认): ")
        
        if confirm == args.package:
            print("🗑️  正在删除包...")
            if delete_package(args.token, args.package):
                print("✅ 包已成功删除!")
            else:
                print("❌ 删除失败，请检查权限或通过 Web UI 手动删除")
                print(f"   访问: https://github.com/users/{args.username}/packages/container/{args.package}/settings")
                return 1
        else:
            print("❌ 取消删除操作")
    
    print()
    print("=" * 50)
    print("操作完成!")
    print("=" * 50)
    
    return 0


if __name__ == "__main__":
    sys.exit(main())

