---
tags: [Python, 机器视觉, 基础]
created: 2026-06-23
---

# 🐍 Python 笔记

> 机器视觉学习过程中的 Python 工具链记录

## 环境配置

- Conda 环境: `cv` (Python 3.10.20)
- 核心包: OpenCV 4.13, NumPy, PyTorch 2.12 (MPS), ONNX Runtime
- 详见: `~/cv_learning/SYSTEM_SETUP.md`

## 常用模式

### 图像处理 (OpenCV)

```python
import cv2
import numpy as np

img = cv2.imread('image.jpg')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
```

### 数组操作 (NumPy)

```python
import numpy as np

arr = np.array([1, 2, 3])
```

### 深度学习 (PyTorch)

```python
import torch

device = torch.device('mps' if torch.backends.mps.is_available() else 'cpu')
```

## 学习进度

- [x] 基础语法（变量、循环、函数）
- [x] NumPy 数组操作
- [ ] OpenCV 常用函数
- [ ] PyTorch 数据加载
- [ ] 模型训练循环

## 相关

- [[基础语法]]
- [[图像处理基础]]
- Jupyter Notebooks: `Python数据类型.ipynb`, `计算机基础知识.ipynb`
- [[机器视觉学习路线_唯一执行版]] — 12 周学习计划
