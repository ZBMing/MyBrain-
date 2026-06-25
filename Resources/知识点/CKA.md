---
tags: [核心概念, 机器视觉, VLA, 模型分析, 工具]
sr-due: 2026-06-26
sr-interval: 3
sr-ease: 250
created: 2026-06-23
source: "[[2026年6月23日]] 论文精读"
---

CKA（Centered Kernel Alignment）是衡量两个表示空间相似度的经典指标——值越接近 1，说明两层输出高度冗余。

### 在 VLA 论文中的应用
- 只需对模型做**一次前向传播**，计算每对层之间的 CKA 相似度
- 找到 CKA → 1 的相邻层对（"孪生层"），将其移除
- 完全训练无关（training-free），不需要任何训练或学习

## 🔗 相关
- [[VLA-model]] — CKA 被用来诊断 VLA 架构的层间冗余
- [[VLM backbone]] — CKA 可同时评估 VLM backbone 和 action head
- [[action head]] — Action Head 同样存在 CKA 检测到的层间冗余

---
## 🃏 闪卡

CKA 全称是什么？用于什么场景？::Centered Kernel Alignment，用于衡量两个神经网络层表示空间的相似度，在 VLA 中用于检测层间冗余


## 相关

- [[instruction-following 的泛化能力]]
- [[零样本学习（Zero-shot Learning）]]
- [[reward信号]]
- [[CoorDex（隐空间先验 + 协调残差）]]
- [[zero-shot 泛化的架构]]
- [[动态权重]]
- [[基于搜索的规划器]]
- [[基于采样的规划器]]
