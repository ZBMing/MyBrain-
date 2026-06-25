---
tags: [调试, 工具, CV]
source: "[[2026年6月24日]]"
created: 2026-06-24
---

# CV学习系统 · 调试指南

## 一、Obsidian 显示验证

写完笔记后，逐项检查：

### 1. 嵌入是否正常渲染

打开 `home.md`，确认能看到：
- `## 🐍 今日CV任务` 标题
- 下方直接显示 Day 1 的任务清单（字典、集合等）
- **不是**显示一个蓝色链接，而是**直接看到任务内容**

如果只看到链接没看到内容：
- 检查 `![[2026年6月24日#🐍 CV打卡...]]` 中的标题是否精确匹配
- Obsidian → 设置 → 文件与链接 → 确认 `![[]]` 嵌入功能已开启

### 2. 双向链接是否生效

- 按住 `Cmd` 点击任意 `[[wikilink]]` → 应该跳转到目标笔记
- 打开右侧面板 → 反向链接 → 应该能看到哪些笔记引用了当前笔记

### 3. 看板拖拽

- 打开 `[[机器视觉学习看板]]`
- 确认显示三列：待开始 / 进行中 / 已完成
- 确认安装了 Kanban 插件（设置 → 第三方插件 → 搜索 kanban）

### 4. Dataview 查询

home.md 中的 dataview 代码块应该显示动态表格，而不是原始代码。如果不生效：安装 Dataview 插件。

### 5. 快速验证命令

```bash
# 在终端运行，检查所有关键文件存在
for f in \
  "Projects/机器视觉学习路线_唯一执行版.md" \
  "Projects/kanban/W01_打卡追踪.md" \
  "Projects/kanban/机器视觉学习看板.md" \
  "Daily/2026年6月24日.md" \
  "Templates/📅 CV每日打卡模板.md"; do
  [ -f "$HOME/Obsidian/MyBrain/$f" ] && echo "✅ $f" || echo "❌ 缺失: $f"
done
```

---

## 二、Python 代码调试（每日学习用）

### 方案A：命令行直接跑（推荐，符合计划要求）

```bash
# 1. 激活环境
conda activate cv
cd ~/cv_learning

# 2. 写代码
vim week01/dict_set_practice.py   # 或用 VS Code

# 3. 运行
python3 week01/dict_set_practice.py

# 4. 如果报错，逐行调试
python3 -i week01/dict_set_practice.py   # -i 进入交互模式，变量保留
```

### 方案B：VS Code 断点调试

```
1. 打开 VS Code → 打开 ~/cv_learning 文件夹
2. 安装 Python 扩展（已装则跳过）
3. 在代码行号左侧点击 → 出现红点（断点）
4. 按 F5 → 选择 "Python File" → 开始调试
5. 顶部工具栏：继续(F5) / 单步(F10) / 进入函数(F11)
6. 左侧面板查看变量值
```

### 方案C：ipdb 命令行调试（轻量）

```bash
pip install ipdb

# 在代码中插入断点：
# import ipdb; ipdb.set_trace()

python3 week01/dict_set_practice.py
# 停在断点处，可以：
# p variable_name    → 打印变量
# n                  → 下一行
# s                  → 进入函数
# c                  → 继续执行
# q                  → 退出
```

### 方案D：快速验证代码片段

```bash
# 不需要写完整文件，直接在终端里试
python3 -c "
d = {'a': 1, 'b': 2}
print({k: v*2 for k, v in d.items()})
"
```

---

## 三、每日工作流（推荐）

```
1. 打开 Obsidian → home.md 自动显示今日CV任务
2. 打开终端：
   conda activate cv
   cd ~/cv_learning
3. VS Code 打开 ~/cv_learning → 写今天的代码
4. 跑通后 → 在 Obsidian 日记里勾选完成
5. 收工前3分钟 → 录音自检 → 填 W01_打卡追踪 复盘
```

---

## 四、常见问题速查

| 问题 | 解决 |
|------|------|
| `import cv2` 报错 | `conda activate cv` 没执行 |
| Obsidian 嵌入不显示 | 标题文字不匹配，检查大小写和emoji |
| Kanban 看板不显示 | 安装 obsidian-kanban 插件 |
| Dataview 不渲染 | 安装 dataview 插件 |
| `python3: command not found` | 检查 `which python3` |
| `.py` 文件中文乱码 | 文件头加 `# -*- coding: utf-8 -*-` |
| VS Code 终端不是 conda 环境 | `Cmd+Shift+P` → "Python: Select Interpreter" → 选 cv 环境 |
