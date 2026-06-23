# CLAUDE.md — MyBrain 个人知识库

## 架构概览

```
┌──────────────────────────────────────────────┐
│               MyBrain 知识库系统               │
├──────────────────────────────────────────────┤
│  GUI 编辑器:   Obsidian (主要交互界面)         │
│  搜索引擎:     gbrain (语义+关键词+向量)       │
│  同步:         gbrain sync (每30分钟, launchd) │
│  捕获:         `cap` CLI / Obsidian Inbox      │
│  版本控制:     Git (本地)                      │
│  AI 问答:      Claude Code + gbrain MCP       │
└──────────────────────────────────────────────┘
```

## 目录结构 (PARA)

| 目录 | 用途 |
|------|------|
| `Inbox/` | 快速捕获，想法、灵感、待整理的一切 |
| `Projects/` | 有明确截止日期的项目 |
| `Areas/` | 持续关注的领域（无截止日期） |
| `Resources/` | 参考资料、论文笔记、代码 |
| `Archives/` | 已完成/不再活跃的内容 |
| `Daily/` | 每日笔记 |
| `Templates/` | 笔记模板 |
| `Weekly/` | 每周回顾报告（自动生成） |
| `scripts/` | 自动化脚本 |

## 关键命令

```bash
# 快速捕获
cap "灵感想法"                           # 文本快抓到 Inbox
cap --link "https://..." "标题"           # 链接快抓

# 知识库同步
brain-sync                               # Git提交 + gbrain索引同步

# 学习追踪
cv                                       # 每日学习打卡仪表盘

# gbrain 搜索
gbrain query "搜索内容"                   # 语义搜索
gbrain search "关键词"                    # 关键词搜索
gbrain stats                             # 知识库统计

# 脚本
bash ~/Obsidian/MyBrain/scripts/health-check.sh    # 健康检查
bash ~/Obsidian/MyBrain/scripts/gap-analysis.sh    # 知识缺口分析
bash ~/Obsidian/MyBrain/scripts/weekly-review.sh   # 手动周报
bash ~/Obsidian/MyBrain/scripts/fetch-papers.sh    # 手动论文抓取
python3 ~/cv_learning/report.py                    # 学习报告

# AI 辅助（通过 Claude Code）
# - "搜索我的笔记：XXX"
# - "帮我分析 Inbox 里的新笔记"
# - "给我生成这周的回顾报告"
```

## 笔记规范

### 前置元数据 (Frontmatter)
```yaml
---
tags: [标签1, 标签2]
created: YYYY-MM-DD
updated: YYYY-MM-DD
source: "[[来源笔记]]"  # 可选
status: inbox | 进行中 | 已完成  # Projects 用
---
```

### 命名规范
- 索引文件: `🚀 项目总览.md` (Emoji + 中文)
- 概念笔记: `VLA 模型.md`
- 每日笔记: `YYYY年M月D日.md`
- 论文笔记: 使用论文标题

### 关键约定
- 使用 `[[双向链接]]` 连接相关笔记
- 新笔记默认存入 `Inbox/`，每周日整理入 PARA
- 不在 Templates/ 和 Daily/ 中放实质性内容

## 自动化任务

| 任务 | 频率 | 配置文件 |
|------|------|---------|
| gbrain 索引同步 | 每30分钟 | `com.xiaoming.gbrain-sync.plist` |
| 每日简报 | 工作日 9:00 | `com.xiaoming.daily-brief.plist` |
| 每周回顾 | 周日 20:00 | `com.xiaoming.weekly-review.plist` |
| arXiv论文抓取 | 每日 7:00 | `com.xiaoming.paper-fetch.plist` |

管理命令: `launchctl list | grep xiaoming`

## gbrain MCP 工具

当 Claude Code 在此目录下运行时，gbrain MCP Server 自动启动，提供以下工具：
- `search` — 关键词全文搜索
- `query` / `ask` — 混合语义搜索 (RRF + 查询扩展)
- `get` — 读取笔记全文
- `list` — 列出所有笔记
- `put` — 写入/更新笔记
