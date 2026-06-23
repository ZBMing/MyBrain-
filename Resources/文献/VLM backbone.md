---
tags: [核心概念, 机器视觉, VLA, 概念]
sr-due: 2026-06-26
sr-interval: 3
sr-ease: 250
created: 2026-06-23
source: "[[2026年6月23日]] 论文精读"
---

在视觉语言模型（VLM）及具身智能（VLA）领域，**Backbone** 通常指负责提取视觉特征和/或处理语言序列的核心神经网络架构。

### 1. 主流架构组成
现代 VLM Backbone 通常由以下三个核心模块串联而成：
	1、Vision Encoder（视觉编码器）：将图像或视频帧转换为视觉 Token（Visual Tokens）。常见基座包括 ViT (Vision Transformer) 或 SigLIP。
	2、Projection Layer（投影层）：将视觉 Token 映射到语言模型的隐藏空间维度，使其能与文本 Token 对齐。
	3、LLM Decoder（语言模型解码器）：基于 Transformer 架构，联合处理视觉和文本 Token，进行语义理解、推理或动作预测。

## 🔗 相关
- [[VLA-model]] — Backbone 是 VLA 的核心组成部分
- [[action head]] — Backbone 输出的特征向量送入 Action Head
- [[CKA]] — 用 CKA 检测 Backbone 各层冗余度
