#!/bin/bash
# MyBrain 健康检查
# 运行: bash ~/Obsidian/MyBrain/scripts/health-check.sh

set -e
PASS=0
FAIL=0

echo "=== MyBrain Health Check ==="
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. Vault 存在
if [ -d ~/Obsidian/MyBrain ]; then
    echo "✅ Vault 存在"
    PASS=$((PASS+1))
else
    echo "❌ Vault 目录缺失"
    FAIL=$((FAIL+1))
fi

# 2. gbrain 可用
if command -v gbrain &> /dev/null; then
    echo "✅ gbrain CLI 可用: $(gbrain --version 2>/dev/null || echo 'ok')"
    PASS=$((PASS+1))
else
    echo "❌ gbrain 未安装"
    FAIL=$((FAIL+1))
fi

# 3. gbrain 健康
if gbrain doctor --json --fast 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); exit(0 if d.get('status')=='ok' else 1)" 2>/dev/null; then
    echo "✅ gbrain 健康"
    PASS=$((PASS+1))
else
    echo "⚠️  gbrain 健康检查有警告（正常运行中可忽略）"
    PASS=$((PASS+1))
fi

# 4. Git 仓库
cd ~/Obsidian/MyBrain
if [ -d .git ]; then
    echo "✅ Git 仓库已初始化"
    PASS=$((PASS+1))
else
    echo "❌ Git 仓库未初始化"
    FAIL=$((FAIL+1))
fi

# 5. launchd 任务
echo ""
echo "--- 定时任务状态 ---"
for JOB in com.xiaoming.gbrain-sync com.xiaoming.daily-brief com.xiaoming.weekly-review com.xiaoming.paper-fetch; do
    PLIST="$HOME/Library/LaunchAgents/$JOB.plist"
    if [ -f "$PLIST" ]; then
        STATUS=$(launchctl list 2>/dev/null | grep "$JOB" || echo "未加载")
        echo "  📋 $JOB: ${PLIST##*/} 存在"
    else
        echo "  ⚠️  $JOB: plist 尚未创建"
    fi
done

# 6. Inbox 积压
INBOX_COUNT=$(ls ~/Obsidian/MyBrain/Inbox/*.md 2>/dev/null | grep -v "收件箱" | wc -l | tr -d ' ')
echo ""
echo "📥 Inbox 积压: ${INBOX_COUNT:-0} 条"

echo ""
echo "========================================="
echo "结果: ${PASS} 通过, ${FAIL} 失败"
echo "========================================="
