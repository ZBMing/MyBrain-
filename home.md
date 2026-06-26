---
tags: [主页]
created: 2026-06-20
updated: 2026-06-24
---

# 🏠 我的第二大脑

> *知识不是用来收藏的，是用来连接的。*

>
> ⚡ **每日第一步：** 打开今天的日记 → [[2026年6月24日]] | 📋 [[W01_打卡追踪]] | 🗂️ [[机器视觉学习看板]]

---

## 🐍 今日CV任务

> 👉 **[[机器视觉学习路线|打开学习计划]]** → 找到今日任务 → 勾选 `[x]` → 终端 `cv` 看进度

📋 [[机器视觉学习看板|看板]] | 🏆 [[Kaggle竞赛_参赛路线图|Kaggle]] | 🎯 [[机器视觉_竞争力全面提升计划|竞争力总纲]]

---

## 📊 系统仪表盘

### 📥 Inbox 积压

```dataview
TABLE file.cday AS "创建", file.mtime AS "最后修改"
FROM "Inbox"
WHERE file.name != "📥 收件箱"
SORT file.mtime DESC
```

### 🆕 本周新增笔记

```dataview
TABLE file.cday AS "创建日期", file.folder AS "位置"
FROM -"Templates" AND -"Daily" AND -#索引 AND -#主页 AND -".obsidian"
WHERE file.cday >= date(today) - dur(7 days)
SORT file.cday DESC
```

### 🏝️ 孤岛笔记（0入链 0出链）

```dataview
TABLE file.folder AS "位置", file.mtime AS "最后修改"
FROM -"Templates" AND -"Daily" AND -#索引 AND -#主页
WHERE length(file.inlinks) = 0 AND length(file.outlinks) = 0
SORT file.mtime DESC
```

### 🔥 链接度 Top 10

```dataview
TABLE length(file.inlinks) AS "被引用", length(file.outlinks) AS "引用", length(file.inlinks) + length(file.outlinks) AS "总链接"
FROM -"Templates" AND -"Daily" AND -#索引 AND -#主页
SORT length(file.inlinks) + length(file.outlinks) DESC
LIMIT 10
```

### 📂 PARA 各层统计

```dataview
TABLE length(rows) AS "笔记数", sum(rows.file.size) AS "总大小"
FROM ""
WHERE file.folder != ".obsidian"
FLATTEN file.folder AS layer
GROUP BY layer
SORT rows.length DESC
```

### 🏷️ 标签分布

```dataview
LIST file.tags
FROM ""
WHERE file.tags
FLATTEN file.tags AS tag
GROUP BY tag
SORT rows.length DESC
LIMIT 15
```

---

## 🔥 最近更新

```dataview
TABLE file.mtime as "最后修改", file.folder as "位置"
FROM -"Templates" AND -"Daily" AND -#索引 AND -#主页 AND -".obsidian"
SORT file.mtime DESC
LIMIT 10
```

---

## 🗺️ 快速入口

| 层级 | 入口 | 说明 |
|------|------|------|
| 📥 | [[📥 收件箱\|Inbox]] | 想法、灵感、待整理的一切 |
| 🚀 | [[🚀 项目总览\|项目]] | 有截止日期的事 |
| 📋 | [[机器视觉学习看板\|学习看板]] | 12周拖拽式进度 |
| 🌱 | [[🌱 领域总览\|领域]] | 持续关注的领域 |
| 📚 | [[📚 资源总览\|资源]] | 主题参考和阅读笔记 |
| 📖 | [[五年阅读人生计划\|五年阅读]] | 128本精选·5年蜕变·从觉醒到表达 |
| 📦 | [[📦 归档总览\|归档]] | 不再活跃的内容 |
| 📘 | [[📘 源码文档\|源码文档]] | CLI、脚本、MCP 工具说明 |
| 🔍 | [[diagnostic-report\|系统诊断]] | 知识库健康报告与升级路线图 |

### 📋 本周待复习（Spaced Repetition）

```dataview
TABLE sr-due AS "到期日", file.folder AS "位置"
FROM -"Templates" AND -"Daily" AND -".obsidian"
WHERE sr-due AND date(sr-due) <= date(today) + dur(3 days)
SORT sr-due ASC
```

### 🎮 趣味工具箱

| 命令 | 说明 |
|------|------|
| `bp today` | ☀️ 今日全局面板 |
| `bp question` | 💡 每日跨领域思考题 |
| `bp wander` | 🎲 随机发现一个知识点 |
| `bp blindspot` | 🔍 知识盲区检测 |
| `bp inspire` | ✍️ 写作灵感生成 |
| `bp vs "A" "B"` | ⚔️ 两个概念对决 |
| `bp path "A" "B"` | 🕸️ 六度分隔 |
| `bp heatmap` | 📊 学习热力图 |
| `bp annual` | 📊 年度报告 |
| `bp wordcloud` | 📝 本周词云 |
| `bp review` | 📅 每周回顾 |

> 💡 终端输入 `bp` 查看完整帮助

### ✅ 本周任务（Tasks 插件）

```tasks
not done
path does not include Templates
path does not include Daily
path does not include .obsidian
group by heading
limit 20
```

### 📋 全部未完成（Dataview）

```dataview
TASK
FROM -"Templates" AND -"Daily" AND -".obsidian" AND -".git"
WHERE !completed
LIMIT 10
GROUP BY file.link
```

---

## 工作流

```
捕捉 → Inbox → 每周整理 → PARA 四层 → 定期回顾
```

1. **随时捕捉**：想到什么，往 Inbox 扔
2. **每周整理**（周日 20 分钟）：Inbox 清空，分到 P/A/R/A
3. **每月回顾**：Archives 里有没有能重新激活的？

---

*Last updated: `= date(today)`*
