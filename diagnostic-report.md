---
tags: [分析, 升级, 路线图]
created: 2026-06-23
updated: 2026-06-23
---

# 🚀 MyBrain 系统升级路线图

> 基于当前状态：34 篇笔记 · 5 插件 · 1/4 定时任务 · 0 远程备份 · gbrain MCP 就绪

---

## 📊 当前状态评分

| 维度 | 现状 | 评分 |
|------|------|:--:|
| 笔记内容质量 | 60,671字，核心概念强，边缘笔记弱 | ⭐⭐⭐ |
| 语义搜索 | gbrain + Voyage 32/32 嵌入 | ⭐⭐⭐⭐⭐ |
| 链接网络 | 核心笔记互相链接良好，心理学笔记孤立 | ⭐⭐ |
| Obsidian 插件 | 仅 5 个基础插件 | ⭐⭐ |
| 自动化 | 1/4 定时任务运行 | ⭐⭐ |
| Git 备份 | 仅有本地，无远程 | ⭐⭐ |
| 领域覆盖 | 2 个（心理、机器视觉） | ⭐⭐ |

---

## 🔴 第一优先级：立即执行（10分钟）

### 1. 加载全部定时任务

当前只有 `gbrain-sync` 在运行：

```bash
launchctl load ~/Library/LaunchAgents/com.xiaoming.{daily-brief,weekly-review,paper-fetch}.plist
launchctl list | grep xiaoming
# 应显示 4 个任务
```

### 2. 配置 GitHub 远程备份

当前 Git 无 remote，一旦电脑损坏笔记全丢：

```bash
# 1. 在 github.com 创建私有仓库 MyBrain
# 2. 终端执行：
cd ~/Obsidian/MyBrain
git remote add origin git@github.com:zhuxiaoming/MyBrain.git
git push -u origin main
```

---

## 🟡 第二优先级：本周完成（30分钟）

### 3. 安装 6 个关键 Obsidian 插件

设置 → 第三方插件 → 浏览社区插件：

| # | 插件 | 解决什么问题 |
|---|------|------------|
| 1 | **Obsidian Git** | 每次保存自动 git commit + push，不用手动 `brain-sync` |
| 2 | **Tasks** | 跨所有笔记聚合 `- [ ]` 任务到统一面板 |
| 3 | **Kanban** | 把机器视觉学习路线变成拖拽看板 |
| 4 | **Spaced Repetition** | 核心概念/心理学术语自动提醒复习 |
| 5 | **Quick Add** | 一键选择模板新建笔记（比 `Cmd+N` 更灵活） |
| 6 | **Homepage** | 每次打开 Obsidian 自动显示 `home.md` 仪表盘 |

### 4. 补充 Areas 领域文件

```
Areas/
  psychology.md         ✅ 已有
  🌱 领域总览.md         ✅ 已有
  computer-vision.md    ❌ 待创建
  cross-domain.md       ❌ 待创建
```

**`Areas/computer-vision.md`** 内容框架：
- 为什么关注（职业方向，南京 8-15K 目标）
- 关键概念索引（VLA模型、VLM backbone、action head...）
- 学习路线进度（链接到 Projects/机器视觉学习路线）
- 当前瓶颈和下一步

**`Areas/cross-domain.md`** — 心理学 × 机器视觉交叉：
- 视觉感知机制 → 计算机视觉启发
- 认知偏误 → AI 系统设计陷阱
- 学习科学 → 机器学习方法论

### 5. 修复 3 篇孤立笔记

| 文件 | 出链 | 入链 | 修复方式 |
|------|:--:|:--:|---------|
| psychology.md | 6 | 0 | 无笔记链接到它——在领域总览中确保链接正确 |
| diagnostic-report.md | 2 | 0 | 从 home.md 链接过来 |
| 走向"心智成熟"的30个实用心理训练.md | 4 | 0 | 从 psychology.md 添加链接 |

---

## 🟢 第三优先级：本月完成

### 6. 创建待补充笔记

Resources 总览中标注的"待创建"：

| 笔记 | 路径 | 建议内容 |
|------|------|---------|
| Python 笔记 | `Resources/机器视觉/python-notes.md` | 与基础语法.md 和 Jupyter 联动 |
| 设计模式 | `Resources/设计模式.md` | 结合 ML 项目中常用的模式 |

### 7. 间隔复习系统

利用 Spaced Repetition 插件，复习关键概念。在核心笔记 frontmatter 中添加：

```yaml
---
tags: [核心概念, 机器视觉, VLA]
sr-due: 2026-06-26
sr-interval: 3
sr-ease: 250
---
```

每天打开 Obsidian，侧边栏自动显示待复习卡片。

### 8. 完善阅读清单

在 `Resources/Resources.md` 中维护结构化待读清单，配合 Tasks 插件创建阅读任务。

---

## 🔵 第四优先级：长期愿景

### 9. AI 增强工作流

利用已配置好的 gbrain MCP + Claude Code：

| 场景 | 实现方式 |
|------|---------|
| 论文自动筛选 | arXiv 抓取 → AI 判断相关性 → 不相关的自动归档 |
| 知识缺口检测 | "对比学习路线和当前笔记，哪些主题还没覆盖？" |
| 跨领域发现 | "心理学笔记和机器视觉笔记之间的潜在联系" |
| 周报增强 | 每周日 AI 分析本周笔记变化，生成洞察 |

### 10. 输出与可视化

- **知识库统计看板**（HTML）：笔记增长曲线、链接网络图、热门主题
- **学习周报自动生成**（已有基础，迭代优化）
- **概念地图导出**：将笔记网络可视化为 Mermaid 图

### 11. 移动端捕获

- iOS Shortcut → iCloud → Inbox
- 最简单替代：微信发给自己 → 晚上批量 `cap`

### 12. Obsidian Publish 替代方案

如果需要分享知识库的部分内容：
- 用 gbrain 的 `export` 导出精选笔记
- 或用 Quartz/Obsidian Publish 生成静态网站

---

## 📈 升级后目标

| 指标 | 当前 | 1 周后 | 1 月后 |
|------|------|--------|--------|
| 笔记数 | 34 | 38 | 50+ |
| Obsidian 插件 | 5 | 10 | 10+ |
| 定时任务运行 | 1/4 | 4/4 | 4/4 |
| Git 远程备份 | ❌ | ✅ | ✅ |
| 孤岛笔记 | ~3 | <3 | 0 |
| 领域覆盖 | 2 | 3 | 4 |
| 间隔复习卡片 | 0 | 10 | 30+ |
| 周报产出 | 0 | 1 | 4+ |

---

*分析时间: 2026-06-23 · 下次复查: 2026-06-30*
