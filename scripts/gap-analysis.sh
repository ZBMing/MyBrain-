#!/bin/bash
# MyBrain 知识缺口分析
# 运行: bash ~/Obsidian/MyBrain/scripts/gap-analysis.sh

DATE=$(date +%Y-%m-%d)

echo "# 🔍 知识缺口分析 - $DATE"
echo ""

echo "## 📌 孤立笔记（零入链零出链）"
echo ""
if command -v gbrain &> /dev/null; then
    gbrain orphans --json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    total = sum(len(g.get('slugs',[])) for g in data.get('groups',[]))
    print(f'共 {total} 篇孤立笔记')
    for g in data.get('groups', []):
        domain = g.get('domain', '?')
        slugs = g.get('slugs', [])
        if slugs:
            print(f'')
            print(f'### {domain} ({len(slugs)} 篇)')
            for s in slugs[:10]:
                print(f'  - {s}')
except Exception as e:
    print(f'_(分析失败: {e})_')
"
else
    echo "需要安装 gbrain"
fi

echo ""
echo "## 📚 学习路线覆盖度"
echo ""
echo "基于 机器视觉学习路线 检查知识覆盖情况..."
echo ""
echo "| 主题 | 是否有笔记 | 链接数 | 状态 |"
echo "|------|----------|--------|------|"
for TOPIC in "VLA模型" "VLM" "action head" "动态路由" "CKA" "视觉感知" "图像处理" "Python基础"; do
    COUNT=$(grep -rl "$TOPIC" ~/Obsidian/MyBrain --include="*.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$COUNT" -gt 0 ]; then
        echo "| $TOPIC | ✅ $COUNT 篇 | - | 已覆盖 |"
    else
        echo "| $TOPIC | ❌ 0 | - | 待补充 |"
    fi
done

echo ""
echo "## 💡 建议优先补充"
echo ""
echo "1. 缺少笔记的主题（上表中 ❌ 行）"
echo "2. 孤立笔记 → 从中提炼概念并建立双向链接"
echo "3. Inbox 积压 → 每周日20分钟整理"
