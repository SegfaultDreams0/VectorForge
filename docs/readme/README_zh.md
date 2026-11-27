 <div align="center">

# VectorForge


<img width="2048" height="280" alt="GitHub 横幅横幅图" src="https://github.com/SegfaultDreams0/VectorForge/blob/main/docs/assets/vectorforge-banner.png" />

### 面向 Roblox Luau 的高级计算数学

**[English](../../README.md)** · 简体中文 · [日本語](README_ja.md) · [한국어](README_ko.md) · [Tiếng Việt](README_vi.md) · [ไทย](README_th.md) · [العربية](README_ar.md) · [MA Darija](README_darija.md)

**直接在 Roblox 中探索数值方法、几何计算与数学系统。**

VectorForge 是一个实验性的 Luau 数学库，致力于探索高级计算数学的实现方式，涵盖李群运动学、数值线性代数、贝叶斯状态估计、微分几何等领域。

<p align="center">
  <a href="https://luau.org/"><img alt="GitHub 横幅横幅图" src="https://img.shields.io/badge/Language-Luau-blue?style=flat-square"></a>
  <a href="https://www.roblox.com/"><img alt="GitHub 横幅横幅图" src="https://img.shields.io/badge/Platform-Roblox-00A2FF?style=flat-square&logo=roblox&logoColor=white"></a>
  <a href="LICENSE"><img alt="GitHub 横幅横幅图" src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square"></a>
  <a href="#project-status"><img alt="GitHub 横幅横幅图" src="https://img.shields.io/badge/Status-Experimental-orange?style=flat-square"></a>
  <br>
  <img alt="GitHub 横幅横幅图" src="https://img.shields.io/github/commit-activity/m/SegfaultDreams0/VectorForge?style=flat-square">
  <img alt="GitHub 横幅横幅图" src="https://img.shields.io/github/last-commit/SegfaultDreams0/VectorForge?style=flat-square">
  <img alt="GitHub 横幅横幅图" src="https://img.shields.io/github/contributors/SegfaultDreams0/VectorForge?style=flat-square">
  <img alt="GitHub 横幅横幅图" src="https://img.shields.io/github/issues-closed/SegfaultDreams0/VectorForge?style=flat-square">
</p>

**[快速开始](#quick-start) · [核心模块](#core-modules) · [科学扩展](#scientific-extensions) · [示例](#examples) · [实验](#experiments) · [仿真](#simulations) · [数据集](#datasets) · [可视化](#visualizations) · [文档](#documentation)**

</div>

---

## 项目概览

Roblox 为构建交互式体验提供了便捷的环境，但某些数学问题需要更专业的数值技术。

VectorForge 探索如何通过一组相互独立的数学模块，在 Luau 中实现这些技术。仓库还包含一个规模更大的实验研究层，涉及流体动力学、有限元方法、量子力学、电磁学、连续介质力学、轨道力学和随机过程等科学计算主题。

本项目涵盖数值分析、机器人学、计算几何、经典力学、概率论和优化领域中的常见概念。

VectorForge 并不试图取代 Roblox 内置 API，而是专注于扩展传统游戏脚本能力的数学运算。

**我们的目标是让高级数学技术能够在 Roblox 中被轻松使用、重复利用并自由实验。**

<a id="quick-start"></a>
## 快速开始

### 安装

你可以手动安装 VectorForge，也可以使用项目附带的 Rojo 项目配置。

**手动安装**

1. 打开 Roblox Studio。
2. 前往 `ReplicatedStorage`。
3. 创建一个名为 `VectorForge` 的文件夹。
4. 将 `src/VectorForge/` 中的 ModuleScripts 复制到该文件夹。
5. 创建 `ReplicatedStorage/VectorForgeShared`，并将共享工具 ModuleScripts 复制到其中。
6. 保留原始 ModuleScript 名称和文件夹结构。

你的 Explorer 层级应如下所示：

```text
ReplicatedStorage
└── VectorForge
    ├── LieGroupKinematics
    ├── SpectralLinearAlgebra
    ├── BayesianStateEstimation
    ├── DifferentialPathGeometry
    ├── AutomaticDifferentiation
    ├── RigidBodyDynamics
    ├── NumericalOptimization
    └── TrajectoryPlanning
```

### Rojo

VectorForge 附带 Rojo 项目配置。

确保 `default.project.json` 将 `src/VectorForge` 映射到 `ReplicatedStorage/VectorForge`，并将仓库根目录中的 `VectorForgeShared/` 映射到 `ReplicatedStorage/VectorForgeShared`。在依赖该映射之前，请先检查项目文件。

构建项目：

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

[Rojo 文档](https://rojo.space/)

### 基本用法

安装完成后，使用 Roblox 的 `require()` 函数加载模块。

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local VectorForgeShared = ReplicatedStorage:WaitForChild("VectorForgeShared")

local SharedConstants = require(VectorForgeShared:WaitForChild("Constants"))
local Lie = require(VectorForge.LieGroupKinematics)
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
local PathGeometry = require(VectorForge.DifferentialPathGeometry)

local AutomaticDifferentiation =
    require(VectorForge.AutomaticDifferentiation)

local RigidBodyDynamics =
    require(VectorForge.RigidBodyDynamics)

local NumericalOptimization =
    require(VectorForge.NumericalOptimization)

local TrajectoryPlanning =
    require(VectorForge.TrajectoryPlanning)
```

每个模块都提供各自的功能。有关可用操作、参数和返回值，请参阅 [API 参考](../../docs/API.md)。

---

<a id="core-modules"></a>
## 核心模块

VectorForge 目前探索八个数学领域。

| 模块 | 数学领域 | 主要方向 |
|---|---|---|
| `LieGroupKinematics` | 李理论 | 旋转与刚体变换 |
| `SpectralLinearAlgebra` | 线性代数 | 矩阵运算与数值求解器 |
| `BayesianStateEstimation` | 概率论 | 状态估计与不确定性 |
| `DifferentialPathGeometry` | 微分几何 | 曲线、曲率与路径分析 |
| `AutomaticDifferentiation` | 数值微积分 | 导数传播 |
| `RigidBodyDynamics` | 经典力学 | 力、力矩与刚体运动 |
| `NumericalOptimization` | 优化 | 数值最小化 |
| `TrajectoryPlanning` | 运动规划 | 轨迹构建与评估 |

### 1. LieGroupKinematics

**李群 · 旋转理论 · 刚体运动学**

用于表示三维空间中的旋转与刚体变换的数学方法。

探索的概念：

- 四元数代数。
- SO(3) 旋转运算。
- SE(3) 刚体变换。
- 指数映射与对数映射。
- 球面线性插值（SLERP）。
- 位姿组合与求逆。
- Twist（扭量）表示。

**可能的应用**

- 程序化动画。
- 平滑的摄像机朝向。
- 受机器人学启发的运动。
- 三维位姿插值。
- 空间仿真。

### 2. SpectralLinearAlgebra

**数值线性代数 · 矩阵计算**

用于操作矩阵、求解线性系统以及执行数学分解的数值方法。

探索的概念：

- 矩阵乘法与转置。
- LU 分解。
- 行列式计算。
- Cholesky 分解。
- Householder QR 分解。
- 对称矩阵特征值近似。
- 共轭梯度法。
- 最小二乘估计。
- 线性系统求解。

**可能的应用**

- 数值仿真。
- 多项式回归。
- 参数估计。
- 数学优化。
- 计算建模。

### 3. BayesianStateEstimation

**贝叶斯推断 · 概率论 · 状态估计**

当观测数据不完整或受到不确定性影响时，用于估计动态系统内部状态的方法。

探索的概念：

- 扩展卡尔曼滤波（EKF）。
- 状态转移模型。
- 测量模型。
- 协方差传播。
- 数值雅可比矩阵近似。
- 测量校正。
- 新息计算。
- 统计测量门限判断。

**可能的应用**

- 带噪声的物体位置跟踪。
- 运动预测。
- 传感器仿真。
- 轨迹估计。
- 动态系统建模。

### 4. DifferentialPathGeometry

**微分几何 · 曲线分析**

对参数化曲线及其几何属性进行数学分析。

探索的概念：

- Hermite 曲线插值。
- 一阶及高阶导数。
- 曲率与挠率。
- 数值弧长积分。
- 弧长参数化。
- Frenet 标架。
- 平行移动标架。
- 最近点估计。
- 最小 jerk 轨迹生成。

**可能的应用**

- 程序化路径生成。
- 平滑的 NPC 轨迹。
- 摄像机轨道系统。
- 车辆轨迹建模。
- 三维运动分析。

### 5. AutomaticDifferentiation

**自动微分 · 数值微积分**

通过在算术运算和受支持的计算表达式中传播导数信息，探索导数计算。

探索的概念：

- 前向模式导数传播。
- 计算表达式求值。
- 导数跟踪。
- 灵敏度分析。

**可能的应用**

- 基于梯度的优化。
- 参数拟合。
- 灵敏度分析。
- 可微数学实验。

### 6. RigidBodyDynamics

**经典力学 · 物理仿真**

探索在外力、力矩和惯性属性作用下描述刚体运动的数学方法。

探索的概念：

- 线运动与角运动。
- 质量与惯性表示。
- 力与力矩关系。
- 刚体状态演化。
- 平动与转动动力学。

**可能的应用**

- 物理实验。
- 机械系统建模。
- 受机器人学启发的仿真。
- 运动分析。

### 7. NumericalOptimization

**数值优化 · 迭代最小化**

探索在给定支持假设和约束条件下，使目标函数最小化的数值求解技术。

探索的概念：

- 目标函数求值。
- 迭代参数更新。
- 基于梯度的优化概念。
- 收敛准则。
- 数值最小化。

**可能的应用**

- 参数估计。
- 曲线拟合。
- 数学标定。
- 优化实验。

### 8. TrajectoryPlanning

**运动规划 · 轨迹生成**

专注于构建和评估状态之间或空间目标之间的路径与随时间变化的运动曲线。

探索的概念：

- 轨迹构建。
- 运动曲线评估。
- 边界条件处理。
- 平滑运动规划。
- 与几何及运动学表示集成。

**可能的应用**

- NPC 移动。
- 受机器人学启发的路径规划。
- 摄像机与物体运动。
- 程序化动画。

---

<a id="scientific-extensions"></a>
## 科学扩展

仓库在原有八个核心模块之外，还包含一个独立的实验性扩展层。这些新增内容按科学领域组织在仓库根目录中，并未放入 `src/VectorForge/`，因此原始核心库与更广泛的研究模块保持分离。

当前扩展包包含：

- **15 个科学领域文件夹**
- **300 个领域模块**，每个领域包含 20 个模块
- **30 个领域支持模块**，每个领域文件夹根目录另有两个文件
- **7 个共享工具模块**，位于 `VectorForgeShared/`
- **10 个具名仿真示例**
- **10 个数值不变量与验证示例**

扩展包共包含 **357 个 Lua 文件**，不包括本 README。这是仓库文件清单统计，并不表示每个模块都已成为经过完整验证的科学求解器。

### 科学领域

| 领域文件夹 | 主要研究方向 |
|---|---|
| `fluid-dynamics/` | 流动模型、动量方程、输运与流体求解器基础 |
| `control-systems/` | 状态空间模型、反馈控制、观测器与稳定性分析 |
| `finite-element-methods/` | 单元公式、材料数据、数值积分与组装概念 |
| `signal-processing/` | 离散变换、滤波、卷积与采样理论 |
| `tensor-calculus/` | 张量存储、缩并、度量与微分运算 |
| `differential-equations/` | 初值积分、边值问题与数值步进 |
| `computational-geometry/` | 参数曲线、曲率、几何谓词与网格概念 |
| `optimization-methods/` | 梯度方法、线搜索、最小二乘目标与停止准则 |
| `quantum-mechanics/` | 波函数表示、概率密度与量子模型基础 |
| `thermodynamics/` | 状态方程、热物性、能量与热力学换算 |
| `electromagnetics/` | 电磁场、洛伦兹力、常数与场采样 |
| `orbital-mechanics/` | 二体运动、轨道参数与天体动力学常数 |
| `rigid-body-physics/` | 惯性、角动量、接触设置与转动动力学 |
| `continuum-mechanics/` | 应变度量、弹性材料数据与本构模型基础 |
| `stochastic-processes/` | 随机过程、随机步进与概率分布 |

### 文件夹布局

每个科学领域都包含三个子文件夹：

- `analysis/` — 面向分析的模块与计算
- `models/` — 模型与状态表示
- `solvers/` — 数值过程与求解器模块

每个领域文件夹的根目录还直接包含两个支持模块，用于提供领域专属配置、材料数据、常数、采样规则或辅助函数。

共享工具统一放在根目录的 `VectorForgeShared/` 文件夹中。在 Roblox Studio 中，该文件夹应位于 `ReplicatedStorage/VectorForgeShared` 下：

| 模块 | 职责 |
|---|---|
| `Constants.lua` | 共享物理常数与数学常数 |
| `CoreRegistry.lua` | 显式注册和查找现有 VectorForge 核心模块 |
| `EquationCatalog.lua` | 用作参考的控制方程简明目录 |
| `LinearAlgebra.lua` | 基础行数组矩阵运算 |
| `NumericalGuards.lua` | 有限值检查、限幅与安全除法 |
| `NumericalKernels.lua` | 共享底层数值内核 |
| `SimulationClock.lua` | 固定步长仿真计时 |

### 与核心模块集成

扩展模块与 `src/VectorForge/` 分开保存。`VectorForgeShared/CoreRegistry.lua` 提供依赖注入机制，使引导脚本能够注册实际的核心模块实例。

注册表不会猜测模块路径，也不会自动加载核心模块。只注册项目中确实存在且其公共 API 已经过检查的模块。

**重要：** 统一使用一个名为 `VectorForgeShared` 的共享文件夹。不要在 `shared`、`Shared` 和 `VectorForgeShared` 下保留多份并行副本。领域模块与引导脚本应解析到同一个 `ReplicatedStorage/VectorForgeShared` 实例。

示例：

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("VectorForgeShared")
local CoreRegistry = require(Shared:WaitForChild("CoreRegistry"))

CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
    BayesianStateEstimation = require(path.to.src.VectorForge.BayesianStateEstimation),
})

local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

扩展源码使用数值数组表示数学状态，不直接依赖 Roblox 空间数据类型。但这并不意味着每个算法都是完整的物理求解器，也不意味着每个模块都已经通过参考实现验证。

### 示例与验证文件

`examples/` 文件夹包含按名称区分的数值研究示例，包括阻尼振荡器响应、耦合状态演化、非线性响应、能量衰减、积分稳定性和长时间范围状态演化。

`tests/` 中新增的扩展测试包含一些数值不变量检查。它们可作为回归测试的起点，但不能替代解析基准、量纲检查、收敛研究或与可信科学数据的验证。

### 研究与生产状态

科学扩展目前属于实验性研究基础设施。一些模块提供可复用的数值例程和领域计算；另一些模块仍需要针对具体问题定义离散化方法、边界条件、本构定律、单位和求解策略。

在生产体验中使用扩展模块之前：

1. 检查模块的输入、输出、维度和单位。
2. 验证其假设与边界条件。
3. 将结果与解析解或可信参考数据进行比较。
4. 在有代表性的输入范围内测试收敛性与数值稳定性。
5. 在 Roblox Studio 中分析执行开销。
6. 根据实际公共 API 验证任何核心模块集成。

这些新增内容扩大了仓库的研究范围，但不会改变原有八个核心模块的安装步骤。

---

## VectorForge 的工作方式

VectorForge 提供一组可在 Roblox 体验中使用的独立数学模块。你可以定义问题或数学模型，选择相关模块，提供所需输入，并在自己的系统中使用返回结果。

下图概述了这一工作流程。它是开发者如何使用该库的概念说明，并不表示所有模块都会自动连接，也不表示 VectorForge 会运行单一固定流程。

![How VectorForge works — computation flow and module overview](../../docs/assets/how-vectorforge-works.png)

## VectorForge 如何协同组织

这些模块围绕不同的数学职责进行组织。

![How VectorForge works — computation flow and module overview](../../docs/assets/How-VectorForge-Fits-Together.png)

这种模块化结构旨在支持：

- 独立的数学组件。
- 可重复使用的实现。
- 清晰的职责划分。
- 更轻松的测试与维护。
- 未来的数学扩展。

更多信息请参阅 [ARCHITECTURE.md](../../docs/ARCHITECTURE.md)。

---

<a id="examples"></a>
## 示例

`examples/` 目录包含独立演示，展示如何在 Roblox 中使用选定的 VectorForge 模块。

| 示例 | 描述 |
|---|---|
| 位姿插值 | 刚体位姿之间的插值 |
| 微分路径 | 沿几何路径进行曲线采样与移动 |
| 贝叶斯运动跟踪 | 使用带噪声的位置观测进行估计 |
| 最小二乘回归 | 使用数值线性代数进行多项式拟合 |
| 积分演示 | 涉及扩展模块集的演示 |

每个示例都力求能够独立理解，并为进一步实验提供起点。

参阅 [examples/README.md](../../examples/README.md)。

<a id="experiments"></a>
## 实验

`experiments/` 目录包含用于可视化数学概念和研究潜在应用的探索性脚本。

| 实验 | 描述 |
|---|---|
| 天体力学 | 简化引力运动的教学可视化 |
| 轨道仿真 | 使用简化力学探索轨道轨迹 |
| 卡尔曼可视化 | 对带噪声观测与平滑估计进行可视化 |
| 轨迹实验室 | 实验性轨迹构建 |
| 数值稳定性实验室 | 比较不同数值求和方法 |

这些实验用于探索，不应视为可直接投入生产的仿真。

部分演示使用简化的参考计算或可视化适配器。例如，天体与轨道演示使用简化牛顿模型，而非广义相对论。卡尔曼可视化是简化的平滑演示，并非完整的 EKF 实现。

参阅 [experiments/README.md](../../experiments/README.md)。


<a id="simulations"></a>
## 仿真

项目在 `simulations/` 文件夹中保存几个独立数值模型。它们适用于测试系统随时间的变化，而无需将计算绑定到 Roblox 场景。

当前脚本涵盖两个不同的问题：

| 脚本 | 模拟内容 |
|---|---|
| `TwoBodyOrbit.lua` | 简化牛顿引力模型下的相对运动 |
| `DampedOscillator.lua` | 带线性阻尼的弹簧连接质量块 |

两者都使用四阶 Runge–Kutta 步进。调用方提供初始状态和时间步长，因此仿真时钟与停止条件仍由调用方控制。

轨道示例使用 SI 单位：米、米每秒、秒，以及单位为立方米每平方秒的引力参数。振荡器使用米、千克、秒、牛顿每米和牛顿秒每米。

这些模型刻意保持精简。轨道脚本未考虑其他天体、大气阻力、碰撞或相对论效应。振荡器假设线性弹簧和线性黏性阻尼。两者都不应被视为生产级物理引擎。

有关每个脚本的设置、参数和限制，请参阅 [simulations/README.md](../../simulations/README.md)。

<a id="datasets"></a>
## 数据集

`datasets/` 文件夹保存项目脚本与实验使用的参考值和示例数据。将数据与算法分离，可以更方便地重复使用相同输入，并清楚了解演示所使用的数据。

| 文件 | 内容 |
|---|---|
| `PhysicalConstants.lua` | 一组以 SI 单位表示的物理常数 |
| `SolarSystem.lua` | 部分行星的近似质量、平均半长轴、轨道周期及推导出的引力参数 |
| `MotionSamples.lua` | 一小段带时间戳的合成二维位置观测序列 |

行星数值经过取整，并非高精度星历。运动样本是生成的示例，不是真实传感器测量值。在数值比较或状态估计实验中，这些区别非常重要。

添加更多数据时，请注明单位，并说明数据是实测值、合成数据还是近似值。这样可以避免后续产生很多混淆。

有关数据约定和使用示例，请参阅 [datasets/README.md](../../datasets/README.md)。

<a id="visualizations"></a>
## 可视化

`visualizations/` 文件夹包含小型 Roblox 辅助模块，用于在 3D 场景中显示计算结果。其设计理念是将数学计算与绘制分离：仿真或算法生成数值，渲染器再将这些数值转换为可供检查的可视内容。

| 模块 | 显示内容 |
|---|---|
| `TrajectoryRenderer.lua` | 由锚定线段连接的一系列 `Vector3` 点 |
| `VectorFieldRenderer.lua` | 以方向指示器形式显示的向量采样 |

这两个模块都会在你提供的父级对象下创建一个 `Model`。其中的部件均已锚定且不可碰撞。完成可视化后，请销毁返回的模型，以清理生成的实例。

这些辅助模块适用于调试和小型演示，而非密集的科学绘图。大量部件可能带来较高开销，尤其是在频繁复制或重建时。请合理控制采样数量，并在 Studio 中分析性能。

有关示例和渲染器选项，请参阅 [visualizations/README.md](../../visualizations/README.md)。

## 基准测试

`benchmarks/` 目录包含面向工作负载的脚本，用于研究选定数学运算的性能。

当前基准测试领域包括：

- 矩阵计算。
- 数值优化。
- 微分几何。
- 状态估计。
- 共享基准测试工具。

基准测试结果可能因硬件、运行时环境、输入维度和实现细节而异。

部分脚本需要适配器，才能将工作负载回调连接到经过验证的公共 API。存在这些脚本并不意味着已经完成全面的性能测量。

文档：

- [基准测试指南](../../docs/BENCHMARKING.md)
- [基准测试脚本](../../benchmarks/README.md)

## 数学基础

VectorForge 涉及多个数学学科。

| 领域 | 概念 |
|---|---|
| 线性代数 | 矩阵运算、分解、特征值 |
| 微分几何 | 曲率、挠率、切向与法向标架 |
| 李理论 | SO(3)、SE(3)、指数映射与对数映射 |
| 数值分析 | 近似、积分、迭代求解器 |
| 概率论 | 贝叶斯估计与不确定性 |
| 优化 | 最小二乘估计与迭代最小化 |
| 信号处理 | 频域分析与数值变换 |

更多说明请参阅 [MATHEMATICS.md](../../docs/MATHEMATICS.md)。

## 研究笔记

`research/` 目录包含辅助数学笔记和探索性材料。

当前主题包括：

- 李群数学与空间变换。
- 数值方法与计算稳定性。
- 贝叶斯状态估计。
- 潜在的未来算法与数学扩展。

这些笔记记录开发过程中的理论考虑和可能方案。它们属于补充材料，并非正式的数学验证。

参阅 [research/README.md](../../research/README.md)。

---

## 测试

VectorForge 包含回归测试和综合测试脚本，用于覆盖各模块中的重要操作。

当前测试领域包括：

- 四元数运算与刚体变换。
- 矩阵乘法与分解。
- 线性系统求解。
- 特征值计算。
- 数值优化。
- 扩展卡尔曼滤波操作。
- 曲线求值与微分属性。
- 弧长计算。
- 轨迹边界条件。
- 自动微分。
- 刚体动力学与轨迹规划。

### 运行测试

1. 将 VectorForge 模块安装到 `ReplicatedStorage/VectorForge`。
2. 将测试运行器放入 `ServerScriptService`。
3. 在 Roblox Studio 中启动 Play 会话。
4. 打开 Output 窗口。
5. 检查测试结果。

该测试套件提供初步的回归测试基础，但并不构成正式的数学验证，也不能保证数值稳定性。

参阅 [tests/README.md](../../tests/README.md)。

## 性能注意事项

数值算法的开销可能随输入维度、迭代次数和执行频率而显著增加。

使用 VectorForge 时，请考虑：

- 避免不必要的矩阵分解。
- 当输入未变化时，重复使用已计算的结果。
- 限制在依赖帧频的循环中执行高开销操作。
- 选择合适的求解器容差与迭代次数上限。
- 使用具有代表性的工作负载进行性能分析。
- 在适当情况下，将权威服务器计算与客户端可视化计算分离。

当前实现尚未经过全面的基准测试。

## 仓库结构

```text
VectorForge/
├── benchmarks/
├── computational-research/
├── datasets/
├── docs/
├── examples/
│   └── server/
├── experiments/
├── research/
├── simulations/
├── visualizations/
│
├── fluid-dynamics/
│   ├── analysis/
│   ├── models/
│   ├── solvers/
│   └── domain support modules
├── control-systems/
│   ├── analysis/
│   ├── models/
│   ├── solvers/
│   └── domain support modules
├── finite-element-methods/
├── signal-processing/
├── tensor-calculus/
├── differential-equations/
├── computational-geometry/
├── optimization-methods/
├── quantum-mechanics/
├── thermodynamics/
├── electromagnetics/
├── orbital-mechanics/
├── rigid-body-physics/
├── continuum-mechanics/
├── stochastic-processes/
├── VectorForgeShared/
│   ├── Constants.lua
│   ├── CoreRegistry.lua
│   ├── EquationCatalog.lua
│   ├── LinearAlgebra.lua
│   ├── NumericalGuards.lua
│   ├── NumericalKernels.lua
│   └── SimulationClock.lua
│
├── src/
│   └── VectorForge/
│       ├── LieGroupKinematics
│       ├── SpectralLinearAlgebra
│       ├── BayesianStateEstimation
│       ├── DifferentialPathGeometry
│       ├── AutomaticDifferentiation
│       ├── RigidBodyDynamics
│       ├── NumericalOptimization
│       └── TrajectoryPlanning
├── tests/
├── .gitignore
├── CHANGELOG.md
├── CONTRIBUTING.md
├── default.project.json
├── LICENSE
├── package.json
├── package-lock.json
└── README.md
```

| 目录 | 职责 |
|---|---|
| `src/` | Roblox Luau 的 VectorForge 核心模块 |
| `docs/` | 技术文档与数学说明 |
| `examples/` | 核心模块的实用演示 |
| `tests/` | 回归测试与数值检查 |
| `benchmarks/` | 基于工作负载的性能测量 |
| `experiments/` | 探索性脚本与演示 |
| `research/` | 研究中的数学笔记与想法 |
| `computational-research/` | 独立的高级数学与科学脚本 |
| `simulations/` | 随时间步进的数值模型 |
| `datasets/` | 参考常数与示例输入 |
| `visualizations/` | 用于显示数值结果的 Roblox 辅助模块 |
| 科学领域文件夹 | 用于物理、工程、几何、优化和科学计算的实验模块 |
| `VectorForgeShared/` | 统一的共享工具层与显式核心模块注册 |

---

## 常见问题

<details>
<summary><strong>VectorForge 是 Roblox Vector3 或 CFrame 的替代品吗？</strong></summary>

不是。VectorForge 探索超越常规向量与变换工具的数学运算。Roblox 内置 API 对许多日常开发任务仍然有用且合适。

</details>

<details>
<summary><strong>VectorForge 已经可以用于生产环境了吗？</strong></summary>

目前还不是。这是一个实验性项目。API、数值行为、性能和实现细节都可能发生变化。

</details>

<details>
<summary><strong>我可以单独使用各个模块吗？</strong></summary>

该库由多个独立数学模块组成，在可行时旨在单独运行。请查看 API 文档，了解可用功能及其依赖关系。

</details>

<details>
<summary><strong>simulations、datasets 和 visualizations 文件夹有什么用途？</strong></summary>

这些文件夹与核心库并列。`simulations/` 包含小型时间步进模型，`datasets/` 保存参考数据和示例输入，而 `visualizations/` 则包含用于显示结果的 Roblox 辅助模块。它们属于支持材料，不会改变核心模块的安装方式。

</details>

<details>
<summary><strong>VectorForge 是否包含性能基准测试？</strong></summary>

项目包含针对部分工作负载的基准测试脚本。其中一些需要适配器，目前尚未建立全面的基准测试结果。

</details>

<details>
<summary><strong>在哪里可以找到使用示例？</strong></summary>

请查看 `examples/` 目录和 [examples/README.md](../../examples/README.md)。`simulations/` 与 `visualizations/` 文件夹也包含针对特定主题的演示。

</details>

<details>
<summary><strong>我可以参与贡献吗？</strong></summary>

欢迎提交技术反馈、错误报告、建议和贡献。提交更改前，请先阅读贡献指南。

</details>

---


<details>
<summary><strong>科学领域文件夹属于原始核心模块吗？</strong></summary>

这些目录是位于仓库根目录的独立实验扩展层。原有八个核心模块仍位于 `src/VectorForge/` 下。扩展模块可以独立开发和测试，并可通过 `VectorForgeShared/CoreRegistry.lua` 注册可选的核心模块依赖。

</details>

<details>
<summary><strong>所有科学扩展模块都是完整且经过验证的求解器吗？</strong></summary>

不是。扩展模块属于研究基础框架。在投入生产之前，必须检查每个模块的数学假设、单位、边界条件、收敛性、数值稳定性，以及与实际核心模块 API 的兼容性。

</details>

<a id="documentation"></a>
## 文档

`docs/` 目录包含 VectorForge 的技术参考资料。

- [API 参考](../../docs/API.md) — 可用操作与模块接口。
- [架构](../../docs/ARCHITECTURE.md) — 模块组织与设计。
- [数学](../../docs/MATHEMATICS.md) — 数学概念与基础。
- [数值验证](../../docs/NUMERICAL_VALIDATION.md) — 验证注意事项。
- [基准测试](../../docs/BENCHMARKING.md) — 基准测试方法与指南。
- [设计决策](../../docs/DESIGN_DECISIONS.md) — 项目设计考量。
- [术语表](../../docs/GLOSSARY.md) — 数学与技术术语。
- [仿真](../../simulations/README.md) — 数值模型与积分细节。
- [数据集](../../datasets/README.md) — 参考值、单位与示例数据。
- [可视化](../../visualizations/README.md) — 场景渲染辅助模块与用法。

目前，科学扩展文件夹通过源码级说明和本仓库概览介绍模块意图。随着模块逐步得到验证，应补充领域专属 API 参考和验证报告。

## 参与贡献

欢迎提交贡献、技术反馈、错误报告和建议。

如果你发现问题，请提供：

- 受影响的模块。
- 最小可复现示例。
- 预期的数学行为。
- 实际观察到的行为。
- 相关的 Roblox Studio Output 错误。

提交 Pull Request 前，请阅读 [CONTRIBUTING.md](../../CONTRIBUTING.md)。

## 开发状态

VectorForge 目前仍处于积极实验阶段。未来可能开展的方向包括：

**数值改进**
- 更多矩阵分解方法。
- 提升数值稳定性。
- 更好地处理退化输入。
- 增加迭代求解器。
- 改进收敛诊断。

**数学扩展**
- 更多概率与估计技术。
- 更多几何变换工具。
- 数值积分方法。
- 更多微分几何运算。

**开发者体验**
- 扩展 API 文档。
- 提供更多实用示例。
- 增加自动化测试。
- 性能基准测试。
- 改进错误处理与验证。

这些是开发方向，并非保证会按计划发布的承诺。

## 许可证

VectorForge 根据 MIT 许可证发布。

完整许可证文本请参阅 [LICENSE](../../LICENSE)。

---

<div align="center">

**VectorForge**

*在 Roblox Luau 中探索计算数学。*

</div>
