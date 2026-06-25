**Claude 3.7 Sonnet** 是由 Anthropic 公司开发的一款前沿 AI 大模型。它的独特之处在于，它是**全球首个“混合推理”模型**，将快速响应的能力与深度、可视化的推理能力整合在了同一个模型中。

我们可以从几个层面来理解它：

### 🧠 核心特性：一个模型，两种“思考”模式

Claude 3.7 Sonnet 的设计理念是模拟人类大脑的工作方式——既能快速反应，也能深度思考。用户可以根据任务需求在两种模式间切换：

*   **标准模式**：作为 Claude 3.5 Sonnet 的升级版，它可以对常规问题进行**近乎实时**的回答，追求速度和效率。
*   **扩展思考模式**：在处理复杂问题（如数学、物理、编程）时，模型会进行**深入的“自我反思”**，并展示其详细的**推理过程（思维链）**。API 用户还可以通过控制“思考预算”（token 数）来精确管理模型在速度、性能和成本之间的平衡。

### 💻 核心能力：顶级的编程与推理表现

在与你正在阅读的论文相关的 SWE-bench（真实软件工程任务评估）等基准测试中，Claude 3.7 Sonnet 表现非常突出：

*   **SWE-bench Verified 基准**：在评估解决真实 GitHub 问题的能力时，Claude 3.7 Sonnet 的准确率达到了 **62.3%**，显著超过了 OpenAI o1、o3-mini 以及 DeepSeek R1 等模型。在另一个软件调试基准测试中，它的表现也优于同类模型。
*   **实际应用工具**：Anthropic 还同步推出了 **Claude Code**，这是一个专门用于辅助编程的命令行工具，开发者可以直接将大量工程任务委托给它。

### 🔗 与《GeneralVLA-2》论文的连接点

这完美地连接了《GeneralVLA-2》论文中提到的 **SWE-bench Verified** 和 **OpenHands** 等概念。作为在当时该基准上表现顶尖的模型之一，Claude 3.7 Sonnet 常被用作评估前沿 AI 编程智能体（如基于 OpenHands 构建的智能体）能力的“大脑”或核心引擎。论文中提及的性能提升，正是建立在这些先进模型驱动智能体的基础之上。



## 相关

- [[SWE-bench-Live]]
- [[Terminal-Bench Challenges]]
- [[OpenHands Software Agent SDK]]
- [[Governed KnowledgeBank——受控长期记忆系统]]
- [[Terminal-Bench]]
