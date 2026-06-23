#!/bin/bash
# MyBrain 每周回顾报告
# 运行: bash ~/Obsidian/MyBrain/scripts/weekly-review.sh

WEEK=$(date +%Y-W%V)
OUTDIR="$HOME/Obsidian/MyBrain/Weekly"
OUTFILE="$OUTDIR/${WEEK}.md"
DATE=$(date +%Y-%m-%d)

mkdir -p "$OUTDIR"

echo "---" > "$OUTFILE"
echo "created: $DATE" >> "$OUTFILE"
echo "tags: [回顾, 周报]" >> "$OUTFILE"
echo "---" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "# 📋 每周回顾 $WEEK" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "> 生成时间: $(date '+%Y-%m-%d %H:%M')" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "## 📊 知识库统计" >> "$OUTFILE"
echo "" >> "$OUTFILE"

if command -v gbrain &> /dev/null; then
    echo '```' >> "$OUTFILE"
    gbrain stats 2>/dev/null >> "$OUTFILE"
    echo '```' >> "$OUTFILE"
fi

echo "" >> "$OUTFILE"
echo "## 📝 本周笔记" >> "$OUTFILE"
echo "" >> "$OUTFILE"

# 列出最近7天修改的笔记
cd ~/Obsidian/MyBrain
if [ -d .git ]; then
    echo "### 最近变更" >> "$OUTFILE"
    echo "" >> "$OUTFILE"
    git log --since="7 days ago" --name-only --pretty=format:"- **%ad** %s" --date=short -- '*.md' | head -50 >> "$OUTFILE"
fi

echo "" >> "$OUTFILE"
echo "## 🔍 链接度分析" >> "$OUTFILE"
echo "" >> "$OUTFILE"

if command -v gbrain &> /dev/null; then
    echo "### 孤立笔记（零链接）" >> "$OUTFILE"
    echo "" >> "$OUTFILE"
    gbrain orphans --json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for g in data.get('groups', [])[:5]:
        print(f'- **{g.get(\"domain\",\"?\")}**: {len(g.get(\"slugs\",[]))} 篇')
except: print('_(暂无数据)_')
" >> "$OUTFILE"
fi

echo "" >> "$OUTFILE"
echo "## 🎯 下周重点" >> "$OUTFILE"
echo "" >> "$OUTFILE"
echo "- [ ] 清空 Inbox" >> "$OUTFILE"
echo "- [ ] 回顾学习路线进度" >> "$OUTFILE"
echo "- [ ] 整理本周论文笔记" >> "$OUTFILE"
echo "- [ ] 更新领域索引" >> "$OUTFILE"

echo "✅ 周报已生成: $OUTFILE"
