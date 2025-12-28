#!/bin/bash

echo "🔒 安全模式：保护 main 分支（不会删除任何源码）"

# 强制切回 main —— 防止停留在 gh-pages 误删
git checkout main

echo "🧹 清理旧 public（只是 Hugo 输出目录，不含源码）"
rm -rf public

cp CNAME /tmp/CNAME_backup 2>/dev/null

echo "🚀 构建 Hugo 静态网站..."
hugo --minify

echo "📦 准备部署到 gh-pages 分支..."
# 进入 public（这里是静态文件，重新生成的，不会影响源码）
cd public

cp /tmp/CNAME_backup CNAME 2>/dev/null

# 初始化一个完全独立的临时 git（与 main 无关，不会污染）
git init
git add .
git commit -m "Edited Articles date: $(date +"%Y-%m-%d %H:%M:%S")"

# 覆盖 gh-pages 分支（这是正确行为）
git branch -M gh-pages
git remote add origin https://github.com/Toby-top/Toby-top.github.io.git
git push --force origin gh-pages

echo "🎉 部署完成：https://tobysneko.com"