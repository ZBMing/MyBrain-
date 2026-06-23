---
tags: [核心概念, 机器视觉, VLA, 模型分析, 工具]
created: 2026-06-23
source: "[[2026年6月23日]] 论文精读"
---

CKA（Centered Kernel Alignment）是衡量两个表示空间相似度的经典指标——值越接近 1，说明两层输出高度冗余。

### 在 VLA 论文中的应用
- 只需对模型做**一次前向传播**，计算每对层之间的 CKA 相似度
- 找到 CKA → 1 的相邻层对（"孪生层"），将其移除
- 完全训练无关（training-free），不需要任何训练或学习

## 🔗 相关
- [[VLA 模型]] — CKA 被用来诊断 VLA 架构的层间冗余
- [[VLM backbone]] — CKA 可同时评估 VLM backbone 和 action head
- [[action head]] — Action Head 同样存在 CKA 检测到的层间冗余
