#!/bin/bash
# Jupyter Notebook 转 Markdown
# 用法: bash nb-to-md.sh <notebook.ipynb>
# 输出: 同名 .md 文件放在同目录下

if [ -z "$1" ]; then
    echo "用法: nb-to-md.sh <notebook.ipynb>"
    exit 1
fi

INPUT="$1"
BASEDIR=$(dirname "$INPUT")
BASENAME=$(basename "$INPUT" .ipynb)
OUTPUT="$BASEDIR/$BASENAME.md"

if ! command -v jupyter &> /dev/null; then
    echo "❌ jupyter 未安装。请在 cv conda 环境中运行:"
    echo "   conda activate cv && jupyter nbconvert --to markdown '$INPUT'"
    exit 1
fi

echo "🔄 转换: $INPUT → $OUTPUT"
jupyter nbconvert --to markdown "$INPUT" --output "$BASENAME" --output-dir "$BASEDIR"

if [ -f "$OUTPUT" ]; then
    # 添加 frontmatter
    DATE=$(date +%Y-%m-%d)
    TITLE=$(head -1 "$OUTPUT" | sed 's/^# //')
    sed -i '' "1s/^/---\ncreated: $DATE\ntags: [代码, 机器视觉]\nsource: $BASENAME.ipynb\n---\n\n/" "$OUTPUT"
    echo "✅ 转换完成: $OUTPUT"
else
    echo "❌ 转换失败"
    exit 1
fi
