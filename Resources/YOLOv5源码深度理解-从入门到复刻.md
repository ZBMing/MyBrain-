---
tags:
  - 深度学习
  - YOLOv5
  - 目标检测
  - 源码解析
  - 计算机视觉
created: 2026-06-24
aliases:
  - YOLOv5学习路径
  - YOLOv5源码解析
---

# YOLOv5 源码深度理解：从入门到复刻的完整思考路径

## 🎯 总体概览

先把项目想象成一辆车：

| 文件 | 作用 | 类比 |
|------|------|------|
| `models/yolov5s.yaml` | 设计图纸（定义网络结构） | 车的设计图 |
| `models/common.py` | 基础零件（卷积、瓶颈等组件） | 发动机零件 |
| `models/yolo.py` | 组装图纸→整车（解析配置、构建模型） | 总装流水线 |
| `train.py` | 训练驾驶（优化过程） | 驾校教练 |
| `detect.py` | 上路行驶（推理预测） | 开车上路 |
| `test.py` | 车检评审（评估模型mAP） | 年检站 |
| `utils/datasets.py` | 加油站（数据加载+增强） | 加油站 |
| `utils/general.py` | 工具箱（损失计算+NMS+画框等） | 工具箱 |

**整体工作流**：`数据加载(datasets.py)` → `模型构建(yolo.py+common.py)` → `训练(train.py)` → `测试(test.py)` → `部署推理(detect.py)`

---

## 🟢 第一层：新手入门——先把车开起来

### 1.1 先看 `detect.py` ——最简单的入口

`detect.py` 只有 170 行，是理解整个系统的**最佳起点**。

**先读懂命令行参数（146-161行）：**
```python
--weights yolov5s.pt  # 模型文件，相当于"大脑"
--source inference/images  # 要检测的图片/视频/摄像头
--img-size 640        # 输入尺寸，越大越精确但越慢
--conf-thres 0.4      # 置信度阈值。0.4表示：低于40%把握的框直接丢掉
--iou-thres 0.5       # NMS时的IOU阈值。两个框重叠超过50%就只保留置信度高的那个
--device ''           # GPU编号。''=自动选择，'cpu'=用CPU，'0'=第0号GPU
```

**再理解核心流程（20-143行）：**
1. `attempt_load(weights)` 加载模型 — 调用 `models/experimental.py:132`
2. `LoadImages(source, img_size=imgsz)` 加载数据 — 调用 `utils/datasets.py:109`
3. `model(img)` 模型前向传播 — 得到原始预测结果
4. `non_max_suppression(pred, ...)` — NMS筛选，去掉重叠框 — 调用 `utils/general.py:598`
5. `plot_one_box(...)` — 在图上画框 — 调用 `utils/general.py:987`

### 1.2 然后看数据加载 `utils/datasets.py`

**核心类 `LoadImages`（109-187行）**：推理时用，逐张读取图片/视频帧。

**`letterbox` 函数（718-748行）—很重要！**
```python
# 等比例缩放图片到目标尺寸，左右/上下补灰色像素(114)
# 例如 1920x1080 → 缩放 → 640x360 → 上下各补140像素 → 640x640
# 灰色值(114,114,114)是ImageNet数据集的均值
```

**核心类 `LoadImagesAndLabels`（328行起）**：训练时用
- 读取图片路径和对应的 `.txt` 标签文件
- 标签格式：`class_id x_center y_center width height`（全部归一化到0-1）

### 1.3 看一眼模型配置 `models/yolov5s.yaml`

```yaml
nc: 2                    # 类别数（这里改成2了，官方是80）
depth_multiple: 0.33     # 网络深度缩放因子（s→m→l→x依次增大）
width_multiple: 0.50     # 网络宽度缩放因子（控制每层通道数）

anchors:                 # 先验框大小，三个检测层，每层3个anchor
  - [10,13, 16,30, 33,23]     # 小尺寸特征图检测大物体(下采样8倍)
  - [30,61, 62,45, 59,119]     # 中尺寸(下采样16倍)
  - [116,90, 156,198, 373,326] # 大尺寸(下采样32倍)

backbone:   # 主干网络，相当于"眼睛"，提取特征
head:       # 检测头，相当于"大脑皮层"，根据特征做判断
```

**两个核心参数理解：**

`depth_multiple: 0.33` 的含义：配置中 `BottleneckCSP` 的 `n=9` 在代码里实际执行 `max(round(9 * 0.33), 1) = 3` 次。
`s` → 0.33, `m` → 0.67, `l` → 1.0, `x` → 1.33

`width_multiple: 0.50` 的含义：配置中输出通道 `512` 实际变成 `512 * 0.50 = 256`。

**这就是YOLOv5s/m/l/x四种模型的唯一区别：同一份yaml，只改这两个参数！**

---

## 🟡 第二层：深入零件——理解每个模块的作用

### 2.1 `models/common.py`——所有基础积木

**Conv（21-33行）—最基础的卷积积木**
```python
# Conv = Conv2d + BatchNorm + Hardswish激活函数
# 这叫做"卷积三件套"，几乎每层都在用
# 参数：c1=输入通道, c2=输出通道, k=卷积核大小(1或3), s=步长
# s=2 时特征图尺寸减半（下采样）
```

**Bottleneck（36-46行）—残差模块**
```python
# 输入 → 1x1卷积降维(c2*0.5) → 3x3卷积 → 如果输入输出通道相同则加回去(shortcut)
# 公式: output = x + Conv3x3(Conv1x1(x))  或  output = Conv3x3(Conv1x1(x))
# shortcut的好处：梯度可以直接流过，防止深层网络梯度消失
```

**BottleneckCSP（49-65行）—CSP结构的瓶颈模块**
```python
# 输入分两路（split）：
#   路1: x → Conv1x1 → N个Bottleneck → Conv1x1
#   路2: x → Conv1x1 (不做BN/激活)
# 两路合并(cat) → BN+激活 → Conv1x1
# CSP = Cross Stage Partial，减少计算量同时保持精度
```

**SPP（68-79行）—空间金字塔池化**
```python
# 对同一特征图做 5x5, 9x9, 13x13 三种最大池化
# 然后和原特征图拼接在一起
# 目的：让网络看到不同尺度的感受野，提升多尺度检测能力
```

**Focus（82-89行）—切片操作**
```python
# 输入: (b, c, w, h)
# 每隔一个像素采一个点，得到4个 (b, c, w/2, h/2) 张量
# 拼接: (b, 4c, w/2, h/2) → 经1x1卷积降维
# 作用：减少计算量，代替了YOLOv3的前两层普通卷积
# 举例：3x640x640 → Focus → 12x320x320 → Conv → 64x320x320
```

### 2.2 `models/yolo.py`——把积木搭成城堡

**`parse_model` 函数（188-248行）—整个项目的核心**
```python
# 读取 yaml 配置文件中的 backbone 和 head 列表
# 每一行格式：[from, number, module, args]
# 例如: [-1, 3, BottleneckCSP, [128]]
#       ↑    ↑      ↑              ↑
#      来自 重复  用什么模块      传入参数(输出通道)
#      前一层 次数

# 关键操作：
# 1. n = max(round(n * gd), 1)  → 深度缩放
# 2. c2 = make_divisible(c2 * gw, 8)  → 宽度缩放（保证能被8整除）
# 3. eval(m) → 把字符串比如 "Focus" 变成真正的类
```

**`Detect` 类（21-60行）—检测头，最终输出**
```python
# 三个检测层：P3(80x80), P4(40x40), P5(20x20)  [对于640输入]
# 每个格子预测 na*(nc+5) 个值
# na=3个anchor, nc=类别数, 5 = [x,y,w,h,obj_conf]
# 所以80类: 3*(80+5) = 255 个输出通道
#
# 推理时关键操作（50-52行）：
# y[..., 0:2] = sigmoid(xy)*2 - 0.5 + grid  → xy坐标，限制在当前格子附近
# y[..., 2:4] = (sigmoid(wh)*2)^2 * anchor  → wh，用anchor做先验
# 注意：这里xy范围是[-0.5, 1.5]*stride，意味着检测框可以超出当前cell
```

### 2.3 `models/experimental.py`——扩展模块

**`attempt_load` 函数（132-145行）**：加载模型的关键
```python
# 1. 从网上下载权重（如果本地没有）
# 2. torch.load 加载 .pt 文件
# 3. model.float().fuse().eval()  → 融合BN到卷积层，设为评估模式
# 4. 支持多模型集成（Ensemble）
```

---

## 🟠 第三层：训练引擎——理解学习过程

### 3.1 `train.py` 整体架构

**核心函数 `train(hyp, opt, device, tb_writer)`（35-386行）**

```
准备工作：
  save_run_settings()          保存这次训练的所有参数
  check_dataset()              检查数据集
  Model(cfg).to(device)        创建模型
  optimizer = SGD/Adam()       创建优化器
  scheduler = LambdaLR()       创建学习率调度器

训练循环 for epoch in epochs:
  for batch in dataloader:      # 遍历每个batch
    imgs = imgs / 255           归一化到[0,1]
    if warmup:                  预热阶段调整学习率
    pred = model(imgs)          前向传播
    loss = compute_loss()       计算损失
    loss.backward()             反向传播
    if ni%accumulate == 0:     梯度累积N次才更新
        optimizer.step()        更新参数
        ema.update()            更新滑动平均模型
  scheduler.step()              更新学习率
  test()                        验证集上测试mAP
  save_checkpoint()             保存模型
```

### 3.2 关键训练细节逐一击破

**梯度累积（91行）：**
```python
nbs = 64  # 名义batch size
accumulate = max(round(64 / total_batch_size), 1)
# 比如你的GPU只能 batch_size=16
# 那么 accumulate = 4，即每4个batch才更新一次参数
# 效果等同于 batch_size=64 的训练，但内存占用只有1/4
```

**优化器参数分组（94-112行）：**
```python
pg0:  .bn层权重和其他参数  → 不加weight_decay 
pg1:  .weight（卷积层权重）  → 加weight_decay（防止过拟合）
pg2:  .bias（偏置）          → 不加weight_decay，warmup时lr从0.1开始
# 为什么bias的warmup lr是0.1而不是0？因为bias不需要预热
```

**学习率调度（116-117行）：**
```python
# 余弦退火：lr从 lr0=0.01 降到 lr0*lrf=0.002
# 公式：lr = (1+cos(epoch*π/epochs))/2 * lr0*(1-lrf) + lr0*lrf
# 趋势：先保持不变 → 中间慢慢下降 → 末尾平缓 → 0.002
```

**Warmup 预热（255-264行）：**
```python
# 前 nw 个batch内，学习率从很小线性增长到正常值
# bias的lr: 0.1 → lr0
# 其他参数的lr: 0 → lr0
# momentum: 0.8 → 0.937
# 作用：模型刚初始化时不稳定，用小lr先"热热身"防止发散
```

**混合精度训练 amp（215行+275行）：**
```python
scaler = amp.GradScaler()  # 梯度缩放器
with amp.autocast(enabled=cuda):  # 自动混合FP32和FP16
    pred = model(imgs)
scaler.scale(loss).backward()  # 放大loss防止FP16下溢
# FP16比FP32快约2-3倍，省一半显存
```

**EMA 指数移动平均（161行+196-201行 in torch_utils.py）：**
```python
# 维护一份参数的平滑副本
# ema_weight = decay * ema_weight + (1-decay) * current_weight
# decay = 0.9999 * (1 - e^(-updates/2000))
# 前期decay小，快速更新；后期decay接近0.9999，极度平滑
# 用 ema.ema 做测试，比直接用模型参数效果更好
```

### 3.3 数据增强——让模型看到更多花样

**Mosaic 马赛克增强（datasets.py:643-698）：**
```python
# 把4张图拼成1张大图（2x2网格）
# 随机选择一个拼接中心点(xc, yc)
# 4张图分别裁剪出需要的部分贴到对应位置
# 作用：丰富小目标、减少GPU显存（4张变1张）、batch不需要太大
```

**MixUp 混合增强（datasets.py:526-530）：**
```python
# 把两张mosaic图按照 beta分布 的比例混合
# img = r * img1 + (1-r) * img2
# r ~ Beta(8, 8)，通常集中在0.5附近
```

**HSV增强（datasets.py:624-635）：**
```python
# 色调(H) ±1.5%, 饱和度(S) ±70%, 亮度(V) ±40%
# 用查表法(LUT)实现，速度极快
# 目的：让模型对光照/颜色变化鲁棒
```

**随机仿射变换（datasets.py:751-835）——如果不用mosaic才生效：**
```python
# 旋转 ±degree, 平移 ±translate, 缩放 ±scale, 剪切 ±shear
# 所有这些变换合并成一个3x3仿射矩阵M一次性完成
# 变换后还要同步更新标注框的位置
```

---

## 🔴 第四层：核心算法——损失函数与NMS

### 4.1 YOLOv5的标签分配 `build_targets`（general.py:541-595）

这是YOLO系列**最核心的逻辑**：

```python
# 步骤1: 将真实标签映射到三个检测层
# targets格式: [batch_id, class_id, x_center, y_center, width, height]（归一化到0-1）

# 步骤2: 为每个gt框找最匹配的anchor
r = gt_wh / anchor_wh  # 宽高比
# 如果 max(r, 1/r) < anchor_t(默认4.0) 说明这个anchor形状匹配
# anchor_t越大，正样本越多；越小，正样本越严格

# 步骤3: 跨网格策略（增加正样本）
# gt中心点 (x, y)，如果 x的小数部分 < 0.5，x会同时匹配左边一个格子
# 同样如果 x距离右边界 < 0.5，也匹配右边一个格子
# 同理y方向。所以一个gt框最多匹配 1 + 2 + 2 = 3个相邻格子 × 3个尺度 = 最多9个正样本！
# 这是YOLOv5相比v3/v4的重大改进
```

### 4.2 `compute_loss` 损失计算（general.py:478-538）

```python
总损失 = box_loss * box_gain + obj_loss * obj_gain + cls_loss * cls_gain

box_loss:  CIOU损失  
# CIoU = IoU - (中心距²/对角线²) - (α*v)
# CIOU不仅考虑重叠面积，还考虑中心点距离和长宽比一致性
# 1 - CIoU 越小说明预测框越准

obj_loss:  BCE损失，判断每个格子是否有目标
# 正样本的obj标签: model.gr + (1-gr)*iou
# 其中gr=1.0（训练后期是纯粹的iou值）

cls_loss:  BCE损失，做分类
# 支持 Focal Loss（gamma>0时）
# Focal Loss让模型更关注难分类的样本

# 三层检测头有不同的权重 balance = [4.0, 1.0, 0.4]
# 小特征图(P5)权重小，大特征图(P3)权重大
# 因为小图格子少，每个格子贡献应该更大
```

### 4.3 NMS 非极大值抑制（general.py:598-677）

```python
# 输入：模型原始输出 [batch, num_preds, (x,y,w,h,obj_conf, cls1_conf, cls2_conf...)]
# 
# 处理流程：
# 1. 过滤 obj_conf < conf_thres 的预测框
# 2. 每类的置信度 × 目标置信度 = 最终得分
#    cls_conf_final = cls_conf * obj_conf
# 3. 把x,y,w,h转换成x1,y1,x2,y2
# 4. 按类别调用 torchvision.ops.nms()
#    - 对所有框按置信度排序
#    - 取置信度最高的框，删掉和它IOU>iou_thres的框
#    - 重复直到没有框剩余
# 5. 每张图最多保留 max_det=300 个框
```

---

## 🟣 第五层：超参数深度解析

### 5.1 `hyp.scratch.yaml` ——从零训练的参数（每个都重要！）

| 参数 | 默认值 | 含义 | 调大效果 | 调小效果 |
|------|--------|------|----------|----------|
| **lr0** | 0.01 | 初始学习率 | 收敛快但可能不收敛 | 收敛慢但更稳定 |
| **lrf** | 0.2 | 最终lr = lr0*lrf | 末尾lr更大 | 末尾lr更小 |
| **momentum** | 0.937 | SGD动量 | 更快冲出局部最优 | 更稳定 |
| **weight_decay** | 0.0005 | L2正则化 | 防止过拟合加强 | 减轻正则化 |
| **warmup_epochs** | 3.0 | 预热轮数 | 对大数据集需要更长 | 小数据集可以短 |
| **box** | 0.05 | 定位损失权重 | 位置更准，但可能影响分类 | 分类优先 |
| **cls** | 0.5 | 分类损失权重 | 分类更准 | 定位优先 |
| **obj** | 1.0 | 目标置信度损失权重 | 检测更多框（可能误检） | 减少误检 |
| **cls_pw** | 1.0 | 正样本分类权重 | 对正样本分类要求更严 | — |
| **obj_pw** | 1.0 | 正样本obj权重 | 减少漏检 | — |
| **iou_t** | 0.20 | IoU训练阈值 | 更多正样本 | 正样本更严格 |
| **anchor_t** | 4.0 | anchor匹配宽高比阈值 | 更多正样本(简单) | 更严格匹配(难) |
| **fl_gamma** | 0.0 | Focal Loss gamma | (设为1.5)关注难样本 | 关闭Focal Loss |

**图像增强参数：**

| 参数 | 默认值 | 含义 |
|------|--------|------|
| **hsv_h** | 0.015 | 色调随机变化 ±1.5% |
| **hsv_s** | 0.7 | 饱和度随机变化 ±70% |
| **hsv_v** | 0.4 | 亮度随机变化 ±40% |
| **degrees** | 0.0 | 旋转角度（scratch训练为0） |
| **translate** | 0.1 | 平移量 ±10% |
| **scale** | 0.5 | 缩放范围 ±50% |
| **shear** | 0.0 | 剪切角度 |
| **fliplr** | 0.5 | 50%概率左右翻转 |
| **mosaic** | 1.0 | 100%概率使用马赛克增强 |
| **mixup** | 0.0 | 混合概率（scratch训练为0） |

### 5.2 `hyp.finetune.yaml` vs `hyp.scratch.yaml`

| 参数 | scratch | finetune | 说明 |
|------|---------|----------|------|
| lr0 | 0.01 | 0.0032 | 微调用更小的学习率 |
| momentum | 0.937 | 0.843 | 减少动量，更稳定 |
| warmup_epochs | 3.0 | 2.0 | 微调热身更快 |
| box | 0.05 | 0.0296 | 定位要求降低 |
| cls | 0.5 | 0.243 | 分类要求降低 |
| mosaic | 1.0 | 1.0 | 仍旧用mosaic |
| mixup | 0.0 | 0.243 | 微调开启mixup |

**微调场景**：你已经有一个在COCO上训练好的模型，想迁移到自己的数据集上。

---

## 🔵 第六层：完整工作流——从零到复刻

### 阶段1：准备数据

```
数据集目录结构：
datasets/
  custom_data/
    images/
      train/   (训练图)
      val/     (验证图)
    labels/
      train/   (标签 .txt 每行: class_id x y w h)
      val/
    custom.yaml  (描述文件)
```

**custom.yaml 示例：**
```yaml
train: datasets/custom_data/images/train/
val: datasets/custom_data/images/val/
nc: 3  # 类别数
names: ['cat', 'dog', 'bird']  # 类名
```

### 阶段2：训练命令

```bash
# 从头训练（小模型）
python train.py --img 640 --batch 16 --epochs 300 \
    --data custom.yaml --cfg yolov5s.yaml --weights '' \
    --hyp data/hyp.scratch.yaml

# 微调（从预训练模型开始）
python train.py --img 640 --batch 16 --epochs 50 \
    --data custom.yaml --weights yolov5s.pt \
    --hyp data/hyp.finetune.yaml
```

### 阶段3：调参顺序（重要！）

**如果训练效果不好，按这个顺序调整：**

1. **先看损失曲线** → `results.png` 三根线(box/obj/cls)都下降了没？
2. **调整 --img-size** → 小目标用 640→1280，大目标用 320→640
3. **调整 --batch-size** → 越大越稳定，但受显存限制
4. **调整学习率 lr0** → loss不下降就减小到0.003，收敛太慢就加大到0.03
5. **调整 anchor_t** → 漏检多就调大(5→6)，误检多就调小(4→3)
6. **调整损失权重 box/cls/obj** → 哪项loss太高就加大对应权重
7. **调整增强参数** → 过拟合就加大增强，欠拟合就减小

### 阶段4：评估模型

```bash
python test.py --weights runs/exp0/weights/best.pt --data custom.yaml --img 640
```

观察指标：**P(精确率)**、**R(召回率)**、**mAP@0.5**、**mAP@0.5:0.95**

---

## ⚫ 第七层：深入细节——思维导图式速查

### 数据流向全景图

```
磁盘图片 (1920x1080)
    │
    ▼ LoadImagesAndLabels.__getitem__
Mosaic拼接 → MixUp混合 → 随机旋转/缩放/剪切 → HSV颜色增强 → 翻转
    │
    ▼ letterbox
(3, 640, 640) 归一化 [0,1]
    │
    ▼ Model.forward
Focus → Conv → BottleneckCSP×3 → Conv → BottleneckCSP×9 → Conv → BottleneckCSP×9 → Conv → SPP → BottleneckCSP×3
    │                                      ↓ P3(80×80×128)   ↓ P4(40×40×256)    ↓ P5(20×20×512)
    │                                      └──────────────────┬──────────────────┘
    │                                             FPN+PAN 特征融合
    │                                      ┌──────────────────┼──────────────────┐
    │                                      ▼                  ▼                  ▼
    │                                   Detect(P3)         Detect(P4)         Detect(P5)
    │                                   (bs,3,80,80,85)    (bs,3,40,40,85)   (bs,3,20,20,85)
    │
    ▼ compute_loss
build_targets(标签分配) → CIoU定位损失 + BCE置信度损失 + BCE分类损失
    │
    ▼ 反向传播
SGD + 余弦退火 + 梯度累积 + EMA + 混合精度
    │
    ▼ 推理时
Detect输出 → 合并 → NMS过滤 → 画框输出
```

### 关键数字速记

| 概念 | 数值 | 来源 |
|------|------|------|
| 最大下采样倍数 | 32 | `model.stride.max()` |
| P3特征图尺寸 | 80×80 (640/8) | 检测小目标 |
| P4特征图尺寸 | 40×40 (640/16) | 检测中目标 |
| P5特征图尺寸 | 20×20 (640/32) | 检测大目标 |
| 每层anchor数 | 3 | 三组宽高比 |
| 每格输出通道 | 3×(5+nc) | no = na×(5+nc) |
| letterbox填充色 | (114,114,114) | ImageNet均值灰度 |
| 默认置信度阈值 | 0.4 (推理) / 0.001 (测试) | — |
| 默认NMS的IoU阈值 | 0.5 (推理) / 0.65 (测试) | — |

---

### 如果要复刻YOLOv5，你需要写这些

**最小可运行版本的文件清单：**

1. **`models/common.py`** — 定义 Conv, Bottleneck, BottleneckCSP, SPP, Focus, Concat, Detect 这几个类
2. **`models/yolo.py`** — 定义 Model 类和 parse_model 函数（读取yaml构建网络）
3. **`models/yolov5s.yaml`** — 模型结构配置文件
4. **`utils/general.py`** — 核心：`compute_loss`, `build_targets`, `non_max_suppression`, `bbox_iou`(CIoU)
5. **`utils/datasets.py`** — 核心：`LoadImagesAndLabels`, `load_mosaic`, `letterbox`, `augment_hsv`
6. **`utils/torch_utils.py`** — `ModelEMA`, `select_device`, `initialize_weights`
7. **`train.py`** — 训练主循环
8. **`detect.py`** — 推理脚本

---

## 相关资源链接

- 项目路径：`GuPao/Chapter 6  object detection algorithm/6-8  YOLO V5/YOLO5/yolov5-master/`
- 官方仓库：[https://github.com/ultralytics/yolov5](https://github.com/ultralytics/yolov5)
- 关键论文：
  - YOLOv4: [https://arxiv.org/abs/2004.10934](https://arxiv.org/abs/2004.10934)
  - CSPNet: [https://arxiv.org/abs/1911.11929](https://arxiv.org/abs/1911.11929)
  - CIOU Loss: [https://arxiv.org/abs/1911.08287](https://arxiv.org/abs/1911.08287)
  - Focal Loss: [https://arxiv.org/abs/1708.02002](https://arxiv.org/abs/1708.02002)
