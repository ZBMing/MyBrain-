---
tags: [指南, 索引]
created: 2026-06-20
updated: 2026-06-23
---

# 📖 MyBrain 知识库 · 完整使用指南

> 版本：v2.0 | 插件：11个 | 笔记：39篇 | 状态：✅ 全部就绪

---

## 🏗️ 系统架构

```
┌─────────────────────────────────────────────────────────┐
│                    MyBrain 知识库系统                      │
│                                                         │
│  📝 Obsidian  ←──→  🧠 gbrain  ←──→  🤖 Claude Code     │
│  (笔记编辑+11插件)   (语义搜索+向量)    (AI对话+搜索)      │
│       │                   │                  │           │
│       ▼                   ▼                  ▼           │
│  📥 cap命令          ⏰ 4个定时任务       🔍 MCP Server    │
│  ⚡ Quick Add        🔄 30分钟同步         自然语言搜索    │
│  🃏 SR复习           📊 每日简报                          │
│                      📋 每周回顾                          │
│                      📄 论文抓取                          │
│                                                         │
│  🔒 备份：Obsidian Git → 10分钟自动 → GitHub 远程        │
└─────────────────────────────────────────────────────────┘
```

---

## ⚡ 命令速查

| 命令 | 作用 | 示例 |
|------|------|------|
| `ci "Day" ⭐ "备注"` | 每日学习打卡 | `ci "Day 5" 3 "学完OpenCV"` |
| `cv` | 学习仪表盘（打卡状态+热力图） | `cv` |
| `cap "内容"` | 终端快速捕获到 Inbox | `cap "VLA中动态路由是核心创新"` |
| `cap --link "URL" "标题"` | 捕获链接 | `cap --link "https://arxiv.org/..." "新论文"` |
| `brain-sync` | Git提交 + gbrain索引同步 | `brain-sync` |
| `brain-health` | 系统健康检查 | `brain-health` |
| `brain-stats` | 知识库统计 | `brain-stats` |
| `gbrain query "问题"` | 语义搜索笔记 | `gbrain query "VLA模型架构"` |
| `gbrain search "关键词"` | 全文关键词搜索 | `gbrain search "视觉感知"` |

---

## 📝 学习打卡

### 每天打卡

```bash
# 新终端中执行（或 source ~/.zshrc 后）
ci "Day 5" 3 "备注（可选）"
```

| 参数 | 说明 | 示例 |
|------|------|------|
| Day 标签 | 学习路线的第几天 | `Day 5` |
| ⭐ 数 | 今日学习评分 | `3` |
| 备注 | 学了什么（可选） | `学完了OpenCV阈值处理` |

### ⭐ 评分参考

| ⭐ | 含义 |
|----|------|
| ⭐ | 不到30分钟 |
| ⭐⭐ | 1小时左右 |
| ⭐⭐⭐ | 2小时+，完成计划 |
| ⭐⭐⭐⭐+ | 超额完成，有额外收获 |

### 查看进度

```bash
cv                              # 仪表盘：连续天数+热力图+累计星星
python3 ~/cv_learning/tracker.py week   # 本周小结
python3 ~/cv_learning/tracker.py status # 简要状态
```

### 打卡效果

成功打卡后会显示：
```
✅ 打卡成功！  Day 5  |  ⭐+3  |  🔥🔥🔥 连续3天  |  累计⭐12
   💪 已经坚持 3 天，继续保持！
```

- 连续 3 天 → 💪 鼓励
- 连续 7 天 → 🏆 肌肉记忆
- 连续 30 天 → 👑 已经是习惯

---

## 🏠 Obsidian 内操作

### 启动时

打开 Obsidian → 自动显示 `home.md` 仪表盘（Homepage 插件）

仪表盘包含：

| 面板 | 数据来源 | 刷新方式 |
|------|---------|---------|
| 📥 Inbox 积压 | Dataview | 实时 |
| 🏝️ 孤岛笔记 | Dataview | 实时 |
| 🔥 链接度 Top 10 | Dataview | 实时 |
| 📂 PARA 统计 | Dataview | 实时 |
| 🔄 待复习卡片 | Dataview + SR | 实时 |
| ✅ 本周任务 | Tasks 插件 | 实时 |
| 🔍 最近更新 | Dataview | 实时 |

### 核心快捷键

| 操作 | 快捷键 |
|------|--------|
| 新建笔记（自动存入 Inbox） | `Cmd+N` |
| 快速跳转笔记 | `Cmd+O` |
| 创建双向链接 | `[[笔记名]]` |
| 今日日记 | 点左侧日历 📅 |
| 命令面板 | `Cmd+P` |
| 知识图谱 | `Cmd+G` |

### Quick Add 一键操作（`Cmd+P`）

| 命令 | 效果 |
|------|------|
| 📥 快速捕获 | 想法直接追加到收件箱 |
| 💡 新概念笔记 | 用资源模板创建笔记 |
| 📅 今日笔记 | 自动以 `YYYY年M月D日` 格式创建 |
| 🚀 新项目 | 用项目模板创建项目 |

### 侧边栏

| 图标 | 插件 | 功能 |
|------|------|------|
| 📅 | Calendar | 每日笔记日历视图 |
| 🧠 | Spaced Repetition | 闪卡复习（7篇核心概念已就绪） |
| ✅ | Tasks | 全局任务聚合面板 |
| 🔀 | Git | 变更文件数 + 手动提交 |

---

## 🧠 Spaced Repetition 复习

### 已配置的闪卡（7篇，76张卡片）

| 笔记 | 核心问答 |
|------|---------|
| VLA-model | VLA全称？与VLM区别？ |
| action head | Action Head作用？ |
| CKA | CKA全称？应用场景？ |
| dynamic-routing | 动态路由 vs 固定Action Head？ |
| visual-perception | 人类视觉对CV的启发？ |
| VLM backbone | Backbone组成部分？ |
| 图像处理基础 | OpenCV默认颜色空间？ |

### 使用流程

1. 点击侧边栏 🧠 图标
2. 看到问题 → 心里回答 → 点击"显示答案"
3. 根据记忆程度选择：**困难 / 正常 / 简单**
4. 算法自动调整下次复习间隔

> 首次复习日：2026年6月26日。每天打开 Obsidian 自动提示当天待复习卡片。

---

## 📋 任务管理

### Tasks 插件

所有笔记中的 `- [ ]` 待办自动聚合到侧边栏 Tasks 面板。

主页 `home.md` 中的 ` ```tasks ` 查询块显示本周待办（按标题分组）。

### Kanban 看板

`Cmd+O` → 搜索"看板" → 打开 `Projects/kanban/机器视觉学习看板.md`

- 拖拽 Week 卡片在不同列之间移动
- 三列：📥 待开始 / 🔄 进行中 / ✅ 已完成

---

## 🤖 AI 搜索（Claude Code + gbrain）

在 `~/Obsidian/MyBrain/` 目录下启动 Claude Code，直接对话：

| 场景 | 提问方式 |
|------|---------|
| 概念回顾 | "搜索我的笔记：什么是CKA？" |
| 知识关联 | "VLA模型和action head之间有什么关系？" |
| 学习回顾 | "我上周学了哪些内容？" |
| 闪卡生成 | "帮我把这篇笔记做成问答闪卡" |
| 交叉分析 | "心理学笔记和机器视觉笔记有什么联系？" |

---

## 📂 PARA 工作流

```
📥 Inbox（随时捕获）
    │  每周日整理（20分钟）
    ↓
┌─────────────────────────────────────┐
│ 🚀 Projects   → 有截止日期的事       │
│ 🌱 Areas      → 持续关注的领域       │
│ 📚 Resources  → 参考资料和笔记       │
│ 📦 Archives   → 已完成/不再活跃      │
└─────────────────────────────────────┘
```

### 整理决策

```
这条笔记是？
├─ 有截止日期、需要行动？ → 🚀 Projects
├─ 长期关注、没有终点？   → 🌱 Areas
├─ 纯参考资料？           → 📚 Resources
├─ 已经不用了？           → 📦 Archives
└─ 还不确定？             → 📥 留在 Inbox
```

---

## 📊 自动化任务

| 任务 | 时间 | 说明 |
|------|------|------|
| gbrain 索引同步 | 每30分钟 | Obsidian 变更 → gbrain 搜索引擎 |
| 每日简报 | 工作日 9:00 | 学习仪表盘 + 知识库状态 |
| arXiv 论文抓取 | 每日 7:00 | 最新 CV 论文 → Inbox |
| 每周回顾 | 周日 20:00 | 生成周报 → Weekly/ |

管理命令：

```bash
launchctl list | grep xiaoming          # 查看所有定时任务
launchctl unload ~/Library/LaunchAgents/com.xiaoming.xxx.plist   # 暂停
launchctl load ~/Library/LaunchAgents/com.xiaoming.xxx.plist     # 恢复
```

---

## 🔒 备份系统

### 自动备份链

```
编辑笔记 → Obsidian Git 每10分钟 → git commit → git push → GitHub
```

### 手动备份

```bash
brain-sync   # 一键：git add + commit + gbrain reindex
```

或点 Obsidian 左侧边栏 Git 图标 → 手动提交。

---

## 🗂️ 目录结构

```
~/Obsidian/MyBrain/
  📥 Inbox/              ← 快速捕获（1篇待处理）
  🚀 Projects/           ← 活跃项目 + Kanban看板
  🌱 Areas/              ← 4个领域（心理学/机器视觉/跨领域/总览）
  📚 Resources/          ← 文献/心理学/机器视觉/Python
  📦 Archives/           ← 历史路线 + 心理学资料
  📅 Daily/              ← 每日笔记
  📋 Templates/          ← 4个模板（日记/项目/资源/领域）
  📊 Weekly/             ← 自动生成的周报
  🔧 scripts/            ← 自动化脚本
  🏠 home.md             ← 仪表盘主页
  📖 usage-guide.md      ← 本指南
  🔍 diagnostic-report.md ← 系统诊断报告
```

---

## 🧩 11个插件一览

| 插件 | 类型 | 功能 |
|------|------|------|
| Homepage | 导航 | 启动自动打开仪表盘 |
| Calendar | 导航 | 每日笔记日历 |
| Dataview | 数据 | 笔记数据库查询 |
| Tasks | 任务 | 全局任务聚合 |
| Kanban | 任务 | 拖拽式看板 |
| Spaced Repetition | 学习 | 间隔复习闪卡 |
| Quick Add | 效率 | 一键捕获/模板 |
| Obsidian Git | 备份 | 自动提交推送 |
| Tag Wrangler | 管理 | 标签批量管理 |
| Excalidraw | 创作 | 手绘图表 |
| Paste URL | 效率 | 智能链接粘贴 |

---

## 🎯 每日流程（参考）

| 时间 | 动作 | 工具 | 用时 |
|------|------|------|------|
| 🌅 9:00 | 查看打卡 + 今日笔记 | `cv` + Quick Add | 2分钟 |
| ☀️ 上午 | 深度学习 + 记概念笔记 | Obsidian | 90分钟 |
| ☕ 随时 | 灵感快速捕获 | `cap` 或 Quick Add | 10秒 |
| 🕑 下午 | 搜索笔记辅助编程 | `gbrain query` | 随时 |
| 🌆 傍晚 | AI辅助整理新笔记 | Claude Code | 5分钟 |
| 🌙 晚上 | 备份 + 回顾 | `brain-sync` | 1分钟 |
| 🧠 随时 | 闪卡复习 | Spaced Repetition | 5分钟 |

---

## 🚨 故障排查

| 问题 | 解决 |
|------|------|
| 搜索不到新笔记 | 运行 `brain-sync` |
| 仪表盘查询不更新 | 重启 Obsidian 或 `Cmd+R` |
| Git 推送失败 | 检查网络，手动 `git push` |
| gbrain 连接失败 | 运行 `brain-health` |
| 插件异常 | 设置 → 第三方插件 → 关闭再开启 |

---

*最后更新：2026-06-23*
