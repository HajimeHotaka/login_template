#!/usr/bin/env bash
# ファイル: add_or_update_header.sh
set -euo pipefail

ROOT_DIR="lib"
MODE="${1:-full}"  # full or name
echo "🔧 MODE=$MODE (full=libからのパス / name=ファイル名のみ)"

while IFS= read -r -d '' file; do
  filename=$(basename "$file")
  rel_path="${file#lib/}"

  if [[ "$MODE" == "name" ]]; then
    NEW_HEADER="// $filename"
    OLD_PATTERN="^// lib/"
  else
    NEW_HEADER="// lib/$rel_path"
    OLD_PATTERN="^// [^/]+\.dart$"
  fi

  # 1行目取得
  FIRST_LINE=$(head -n 1 "$file" || echo "")

  # すでに同じヘッダ → 何もしない
  if [[ "$FIRST_LINE" == "$NEW_HEADER" ]]; then
    echo "✅ Skip (same): $file"
    continue
  fi

  # 古い形式（パターン一致）なら置き換え
  if [[ "$FIRST_LINE" =~ $OLD_PATTERN ]]; then
    echo "🔄 Update: $file"
    tail -n +2 "$file" | (echo "$NEW_HEADER" && cat) > "$file.tmp"
    mv "$file.tmp" "$file"
    continue
  fi

  # どちらもなければ追加
  echo "🪶 Add: $file"
  tmp=$(mktemp)
  {
    echo "$NEW_HEADER"
    cat "$file"
  } > "$tmp"
  mv "$tmp" "$file"

done < <(find "$ROOT_DIR" -type f -name "*.dart" -print0)
