---
tags: [Kaggle, 竞赛, 机器视觉, 规划]
source: "[[2026年6月24日]]"
created: 2026-06-24
---

# Kaggle竞赛 · 参赛路线图

> 📅 创建日期：2026-06-24
> 🎯 目标：6个月内获得至少1枚Kaggle奖牌（🥉铜牌起步，争取🥈银牌）
> ⏱ 投入：平时周末半天，冲刺期周末全天
> 🔗 关联文档：[[机器视觉_竞争力全面提升计划]] | [[机器视觉学习路线_唯一执行版]]

---

## 一、为什么机器视觉工程师需要Kaggle？

### 面试官视角

```
简历A："熟练使用OpenCV，做过2个课程项目"
简历B："熟练使用OpenCV，Kaggle钢铁缺陷检测Top 10%，复现并改进了获奖方案"

→ 你是面试官，你会多看谁一眼？
```

### 对你来说的三大价值

| 价值 | 说明 |
|------|------|
| **转行认证** | 你不是科班出身，Kaggle奖牌是第三方给你的CV能力盖的章 |
| **面试弹药** | 每个Kaggle比赛都是一个故事：遇到了什么数据问题→试了什么方法→踩了什么坑→怎么解决的 |
| **方向对口** | 钢铁缺陷检测、工业质检、图像分割——这些Kaggle比赛和你的求职方向完美重叠 |

---

## 二、6个月竞赛路线图

### 总览

```
📅 月份1-2：打基础
├── Digit Recognizer（MNIST）→ 分类入门
├── Global Wheat Detection → 检测入门
└── Severstal Steel Defect Detection → 工业缺陷检测实战

📅 月份3-4：冲奖牌
├── Kaggle Featured 竞赛 × 1（目标🥉铜牌）
└── 赛后复盘文章 → 知乎/CSDN

📅 月份5-6：冲银牌
├── Kaggle Featured 竞赛 × 1（目标🥈银牌）
├── 建立Kaggle工具库
└── 写竞赛方法论文章
```

---

## 三、具体比赛计划

### 🥊 比赛1：Digit Recognizer（Week 3-4）

```
难度：⭐（入门级）
类型：图像分类（MNIST手写数字识别）
链接：kaggle.com/c/digit-recognizer
时间：2个周六下午（共约8小时）

Week 3（周六 3-4h）：
├── 注册Kaggle → 创建Notebook → 加载数据
├── 跑通baseline：简单CNN
├── 提交第一次成绩（baseline acc ≈ 97%）
└── 学习：数据增强（rotation/shift/zoom）

Week 4（周六 3-4h）：
├── 改进：更深网络 + Dropout + BatchNorm
├── 学习率调度：ReduceLROnPlateau
├── 模型集成：3个模型投票
├── 提交最终成绩（目标 acc > 99.5%）
└── 写好Notebook注释 → 公开分享

产出：
✅ 1个公开Kaggle Notebook
✅ 理解了完整竞赛流程（数据→训练→提交→Leaderboard）
✅ 学会基本的数据增强和模型集成
```

### 🥊 比赛2：目标检测入门（Week 5-6）

```
难度：⭐⭐（进阶级）
类型：目标检测
时间：2个周六下午 + 周日晚调试（共约12小时）

推荐比赛（二选一）：
├── A. Global Wheat Detection
│   链接：kaggle.com/c/global-wheat-detection
│   内容：从航拍图中检测小麦穗
│   为什么推荐：检测流程与工业零件检测完全相同
│
└── B. Sartorius Cell Instance Segmentation
    链接：kaggle.com/c/sartorius-cell-instance-segmentation
    内容：显微镜图像中的细胞分割
    为什么推荐：学Mask R-CNN/U-Net，分割是缺陷检测的基础

Week 5（周六 4h）：
├── 下载数据 → EDA分析（类别分布/框尺寸分布/宽高比）
├── 跑通YOLOv8 baseline
├── 理解mAP指标：mAP@0.5、mAP@0.5:0.95
└── 第一次提交

Week 6（周六 4h + 周日 2h）：
├── 数据增强：Mosaic/MixUp/Albumentations
├── 调参：学习率/batch size/epochs/img size
├── WBF（Weighted Box Fusion）后处理
├── 最终提交（目标 mAP > 0.5）
└── 写复盘笔记

产出：
✅ 掌握了目标检测竞赛的全流程
✅ YOLO调参经验
✅ 1个公开Notebook
```

### 🥊 比赛3：工业缺陷检测（Week 7-8）⭐ 关键比赛

```
难度：⭐⭐⭐（工业级）
类型：语义分割 + 多标签分类
链接：kaggle.com/c/severstal-steel-defect-detection
为什么关键：直接对口你的求职方向！
时间：2个完整周末（共约16小时）

Week 7（周六 4h + 周日 2h）：
├── 理解问题：钢铁表面的4种缺陷类型
├── 数据分析：
│   ├── 类别分布（严重不平衡！某些缺陷很少出现）
│   ├── 缺陷面积分布
│   └── 多标签共存情况（同一位置可能有多种缺陷）
├── 跑通baseline：U-Net语义分割
├── 处理类别不平衡：加权Loss / Focal Loss
└── 第一次提交

Week 8（周六 4h + 周日 4h）：
├── 改进模型：
│   ├── U-Net → DeepLabV3+ / FPN
│   ├── 不同backbone对比（ResNet50/101, EfficientNet）
│   └── 数据增强策略
├── 后处理：
│   ├── 小区域过滤（去除噪声预测）
│   ├── CRF后处理
│   └── 多尺度测试（TTA）
├── 模型集成（至少2个不同模型投票）
├── 最终提交
└── 写详细复盘文章 → 发知乎/CSDN

产出：
✅ 1个完整的缺陷检测竞赛方案
✅ 1篇知乎复盘文章（"钢铁缺陷检测Kaggle竞赛：从数据到提交"）
✅ 简历上写："Kaggle钢铁缺陷检测 Top X%"
✅ 面试直接讲这个案例
```

### 🥊 比赛4：Featured竞赛冲刺（Week 9-12）

```
难度：⭐⭐⭐⭐（竞技级）
类型：选择正在进行的Featured比赛（优先图像分割/检测/分类）
时间：4个完整周末（共约32小时）

选择策略：
├── 打开 kaggle.com/competitions
├── 筛选：Featured + 图像相关 + 还剩4周以上
├── 优选：工业/医学/遥感（这些和机器视觉最相关）
└── 避坑：NLP/表格数据/Tabular（和你的方向无关）

Week 9：建立基线
├── 阅读比赛描述 → 理解评价指标
├── 浏览Discussion Top帖子
├── 下载数据 → EDA
├── 找公开Notebook → 跑通Top方案
└── 建立自己的baseline

Week 10：模型优化
├── 改进数据预处理/增强
├── 换更强的backbone
├── 调参（学习率/优化器/损失函数）
└── 每次改进都提交一次，记录LB变化

Week 11：冲刺提升
├── 模型集成（交叉验证 + 多模型投票）
├── TTA（Test Time Augmentation）
├── 伪标签（用模型预测测试集→再训练）
├── 后处理优化
└── 每天至少提交1次

Week 12：最终冲刺
├── 选择最佳提交时机（比赛截止前）
├── 最终ensemble提交
├── 目标：🥉 铜牌（Top 40%）→ 争取 🥈 银牌（Top 20%）
└── 写详细复盘文章

赛后必做（比赛结束后48h内）：
├── 写复盘文章：方法→实验→踩坑→结果→改进方向
├── 清理代码→上传GitHub
├── 在Discussion区感谢帮助过的人
└── 更新简历：加上Kaggle成绩
```

### 🥊 比赛5：第二次Featured冲刺（Week 13-16）

```
同比赛4流程，但目标升级：
├── 🥈 银牌（Top 20%）
├── 尝试更高级技巧：Knowledge Distillation / Self-supervised Pretrain
└── 如果比赛对口，考虑写成论文格式的技术报告
```

---

## 四、Kaggle工具包

### 你的竞赛代码模板

```python
# kaggle_template/
# ├── config.py          # 所有参数
# ├── dataset.py         # 数据加载+增强
# ├── model.py           # 模型定义
# ├── train.py           # 训练循环
# ├── inference.py       # 推理
# ├── postprocess.py     # 后处理
# └── ensemble.py        # 模型集成
```

### 常用库清单

```bash
pip install \
  ultralytics \           # YOLO全家桶
  albumentations \        # 数据增强
  segmentation-models-pytorch \  # 语义分割模型
  timm \                  # 预训练模型库
  wandb \                 # 实验追踪
  optuna \                # 超参搜索
  ensemble-boxes          # WBF/融合
```

### 常用技巧速查

| 技巧 | 适用场景 | 提升幅度 |
|------|---------|---------|
| 数据增强(Albumentations) | 所有图像赛 | +1-3% |
| 交叉验证(5-fold) | 小数据集 | +1-5% |
| 模型集成(3-5个模型) | 所有比赛 | +1-3% |
| TTA（Test Time Augmentation） | 分类/分割 | +0.5-2% |
| 伪标签 | 测试集>训练集 | +1-5% |
| 混合精度训练(AMP) | 加速训练 | 2x速度 |
| 渐进式学习率 | 大模型训练 | 更稳定 |
| SWA（Stochastic Weight Averaging） | 模型泛化 | +0.5-1% |

---

## 五、Kaggle Profile建设

### 目标画像（6个月后）

```
✅ Competitions：5+ entered, 1-2 medals
✅ Notebooks：10+ public, 100+ upvotes
✅ Discussions：50+ comments, 10+ topics
✅ Datasets：1-2 published datasets
✅ Rank：Competitions Expert
```

### 每周KPI

```
Week 1-8：
├── 完成2个入门赛
├── 发布3个Notebook
└── 在Discussion回答5个问题

Week 9-16：
├── 参加1个Featured比赛
├── 冲刺1枚奖牌
├── 发布5个Notebook
└── 建立自己在钢铁/缺陷检测赛道的影响力

Week 17-24：
├── 参加1-2个比赛
├── 冲刺第2枚奖牌
├── 发布自己的数据集（如果有独特数据）
└── 成为Kaggle Discussions的活跃贡献者
```

---

## 六、竞赛时间投入总预算

| 阶段 | 周次 | 比赛 | 时间/周 | 总计 |
|------|------|------|---------|------|
| 入门 | W3-W4 | MNIST | 4h | 8h |
| 入门 | W5-W6 | 目标检测 | 4-6h | 10h |
| 实战 | W7-W8 | 钢铁缺陷 | 6-8h | 14h |
| 冲刺 | W9-W12 | Featured #1 | 8h | 32h |
| 冲刺 | W13-W16 | Featured #2 | 8h | 32h |
| **合计** | **14周** | **5场比赛** | | **约96h** |

> 96小时分布在14周 = 平均每周7小时。大部分在周末，不影响工作日学习。

---

## 七、常见问题

**Q：第一次参赛成绩很差怎么办？**
A：完全正常！Kaggle不是考试——第一次目标是"跑通流程"而非"拿高分"。MNIST你大概率能进Top 50%。

**Q：需要GPU吗？**
A：Kaggle Notebook提供免费GPU（P100，每周30小时）。Colab也有免费GPU。前期学习完全够用。只在冲刺阶段可能需要额外租云GPU（AutoDL约2元/小时）。

**Q：我不是科班出身，能拿到奖牌吗？**
A：能。Kaggle奖牌和学历无关，只看你的模型效果。很多Top选手不是CS专业。

**Q：如果比赛成绩不好，还写复盘文章吗？**
A：写！Top 50%的复盘文章比Top 10%的炫耀文更有价值——因为更多人能从中学习。

**Q：应该一个人做还是组队？**
A：前2个比赛自己一个人做（学习为主）。Featured比赛可以组队（1-2人），分工协作效率更高。

---

> 🔗 返回：[[机器视觉_竞争力全面提升计划]]
> ⚡ **现在就做：打开 kaggle.com → 注册账号 → 搜索"Digit Recognizer" → 点"Join Competition"**
