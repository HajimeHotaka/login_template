#!/usr/bin/env bash
set -euo pipefail

# ===== 設定（必要なら変えてOK）=====
REMOTE_NAME="${REMOTE_NAME:-github}"   # GitHub リモート名
GITHUB_BRANCH="${GITHUB_BRANCH:-main}" # GitHub 側の公開ブランチ名（main 推奨）
# ====================================

TOP=$(git rev-parse --show-toplevel 2>/dev/null || true)
[ -n "${TOP}" ] || { echo "❌ Gitリポ内で実行してください。"; exit 1; }

CUR_BRANCH="$(git -C "$TOP" symbolic-ref --short -q HEAD || true)"
SRC_LABEL="${CUR_BRANCH:-snapshot}"

REMOTE_URL=$(git -C "$TOP" remote get-url "$REMOTE_NAME" 2>/dev/null || true)
[ -n "$REMOTE_URL" ] || { echo "❌ リモート $REMOTE_NAME が未設定です。先に 'git remote add github <URL>' を実行"; exit 1; }

echo "🗂  Source     : $TOP  (branch: ${SRC_LABEL})"
echo "🔗  Remote     : $REMOTE_NAME -> $REMOTE_URL"
echo "🎯  Publish To : $GITHUB_BRANCH (1コミットで強制更新)"
read -r -p "続行しますか？ [y/N]: " ans
[[ "${ans:-}" =~ ^[Yy]$ ]] || { echo "キャンセル"; exit 0; }

TMP_DIR="$(mktemp -d -t onepush.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "📦 rsync コピー中（.git は除外）..."
rsync -a --delete --exclude='.git' --exclude='.git/**' "$TOP"/ "$TMP_DIR"/

echo "🧾 単発コミット作成中..."
cd "$TMP_DIR"
git init -q
git checkout -b "$GITHUB_BRANCH" >/dev/null
git config user.name  "OnePush Bot"
git config user.email "onepush@example.invalid"
git add .
git commit -qm "One-commit snapshot from '${SRC_LABEL}' @ $(date '+%Y-%m-%d %H:%M:%S %Z')"

echo "⬆️  push --force → $GITHUB_BRANCH"
git remote add "$REMOTE_NAME" "$REMOTE_URL" 2>/dev/null || true
git push --force "$REMOTE_NAME" "$GITHUB_BRANCH"

REMOTE_HEAD=$(git ls-remote --heads "$REMOTE_URL" "$GITHUB_BRANCH" | awk '{print $1}' | cut -c1-7 || true)
echo "🌐 GitHub HEAD : ${REMOTE_HEAD:-<unknown>}"
echo "✅ 完了：$GITHUB_BRANCH を 1コミットで更新しました。"
