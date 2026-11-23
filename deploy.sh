#!/usr/bin/env bash
# 用法：bash deploy.sh  （在 deploy 目录里执行，或双击终端里跑）
set -e
cd "$(dirname "$0")"

echo "→ 1/3 构建 Vue 项目"
(cd ../plan-site && npm run build)

echo "→ 2/3 同步构建产物"
cp ../plan-site/dist/index.html ./index.html

echo "→ 3/3 提交并推送"
git add -A
git commit -m "deploy: $(date '+%Y-%m-%d %H:%M')" || echo "（无变更，跳过提交）"
git push
echo "✅ 已推送，约 1 分钟后 GitHub Pages 自动更新"
