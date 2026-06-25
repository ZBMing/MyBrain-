标题：GeneralVLA-2: Geometry-Aware Reconstruction and Governed Memory for Robot Planning
GeneralVLA-2：面向机器人规划的几何感知重建与受控记忆系统
arxiv链接：[https://arxiv.org/abs/2606.17480](https://arxiv.org/abs/2606.17480)
代码仓库：[https://github.com/AIGeeksGroup/GeneralVLA-2](https://github.com/AIGeeksGroup/GeneralVLA-2)
项目主页：[https://aigeeksgroup.github.io/GeneralVLA-2](https://aigeeksgroup.github.io/GeneralVLA-2)

一句话总结
**GeneralVLA-2通过"[[多视角几何融合重建]]"和"[[带质检机制的受控记忆库]]"两大创新，系统性地解决了VLA（视觉-语言-动作）机器人在操作规划中"看走眼"和"记不住"两个核心痛点。**

## 研究动机

这篇论文直击机器人操作规划中的两个经典但长期未被系统解决的问题：

**痛点一：单目3D重建的"脑补幻觉"**  
现有[[VLA-model]]系统通常从单张RGB-D图像推断物体的三维形状，但单目视角天然存在[[位姿模糊]]性——物体的背面、侧面、底部只能靠模型"想象"，而这种想象经常出错。对于机器人来说，一个毫米级的形状偏差就可能导致抓取失败或碰撞。类比：蒙住一只眼用一根手指摸一个陌生物体的一面，然后要我描述它的完整形状——错是必然的。

**痛点二：经验记忆的"图书馆没有管理员"**  
前作GeneralVLA的知识库（KnowledgeBank）是个简单的追加式文本缓存：任务结束后总结一段自然语言存下来，下次按语义相似度检索。但"语义相似"≠“实际有用”——来自失败案例的经验可能被当作成功策略复用，针对特定尺寸的经验可能被错误迁移，随着时间推移矛盾条目越来越多却无人处理。这就像一座没有管理员的图书馆：书越堆越多，但没人审查版本、没人修正错误、没人下架过时内容。