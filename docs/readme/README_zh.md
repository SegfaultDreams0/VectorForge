
# VectorForge
### 面向 Roblox Luau 的高级计算数学
**在 Roblox 中探索数值方法、几何计算与数学系统**

[English](../../README.md) · [日本語](README_ja.md) · [한국어](README_ko.md) · [Tiếng Việt](README_vi.md) · [ไทย](README_th.md) · [العربية](README_ar.md)

---

## VectorForge 是一个实验性的 Luau 数学库，旨在 Roblox 环境中探索高级计算数学的实现。项目涵盖李群运动学、数值线性代数、贝叶斯状态估计、微分几何，以及更广泛的科学计算主题。

**本项目旨在让高级数学方法在 Roblox 中变得易于使用、可复用并适合持续实验。**

## 快速开始

### 安装

**手动安装**

1. 打开 Roblox Studio
2. 进入 ReplicatedStorage
3. 创建名为 VectorForge 的文件夹
4. 将 src/VectorForge/ 中的 ModuleScripts 复制到该文件夹
5. 保留原始 ModuleScript 名称

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
    ├── TrajectoryPlanning
```

### Rojo

VectorForge 包含 Rojo 项目配置。确保 default.project.json 将 src/VectorForge 映射到 ReplicatedStorage/VectorForge。然后运行：

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

### 基本用法

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
```

## 核心模块

VectorForge 的核心部分目前包含八个数学模块。

| Module | Domain | Main focus |
|---|---|---|
| `LieGroupKinematics` | 李群理论 | 旋转与刚体变换 |
| `SpectralLinearAlgebra` | 线性代数 | 矩阵运算与数值求解器 |
| `BayesianStateEstimation` | 概率论 | 状态估计与不确定性 |
| `DifferentialPathGeometry` | 微分几何 | 曲线、曲率与路径分析 |
| `AutomaticDifferentiation` | 数值微积分 | 导数传播 |
| `RigidBodyDynamics` | 经典力学 | 力、力矩与刚体运动 |
| `NumericalOptimization` | 优化 | 数值最小化 |
| `TrajectoryPlanning` | 运动规划 | 轨迹构建与评估 |

## 科学扩展

仓库还包含独立于原始核心库的实验性科学扩展层。这些目录位于仓库根目录，而不是 src/VectorForge/ 中。

扩展包包含 15 个科学领域目录、300 个领域模块、30 个领域支持模块、5 个共享工具模块、10 个命名模拟示例和 10 个数值不变量检查脚本，共计 355 个 Lua 文件。

| Folder | Research area |
|---|---|
| `fluid-dynamics/` | **流体动力学** — 流动模型、动量方程、输运与流体求解器基础 |
| `control-systems/` | **控制系统** — 状态空间模型、反馈控制、观测器与稳定性分析 |
| `finite-element-methods/` | **有限元方法** — 单元公式、材料数据、高斯积分与组装 |
| `signal-processing/` | **信号处理** — 离散变换、滤波、卷积与采样理论 |
| `tensor-calculus/` | **张量微积分** — 张量存储、缩并、度量与微分运算 |
| `differential-equations/` | **微分方程** — 初值积分、边值问题与数值步进 |
| `computational-geometry/` | **计算几何** — 参数曲线、曲率、几何判定与网格概念 |
| `optimization-methods/` | **优化方法** — 梯度方法、线搜索、最小二乘与停止准则 |
| `quantum-mechanics/` | **量子力学** — 波函数表示、概率密度与量子模型基础 |
| `thermodynamics/` | **热力学** — 状态方程、热属性、能量与热力学换算 |
| `electromagnetics/` | **电磁学** — 电磁场、洛伦兹力、常数与场采样 |
| `orbital-mechanics/` | **轨道力学** — 二体运动、轨道参数与天体动力学常数 |
| `rigid-body-physics/` | **刚体物理** — 惯性、角动量、接触设置与转动动力学 |
| `continuum-mechanics/` | **连续介质力学** — 应变度量、弹性材料数据与本构模型基础 |
| `stochastic-processes/` | **随机过程** — 随机过程、随机步进与概率分布 |

### 目录结构

```text
domain-folder/
├── analysis/
├── models/
├── solvers/
├── DomainSupportOne.lua
└── DomainSupportTwo.lua
```

### 共享工具

| Module | Responsibility |
|---|---|
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping and safe division |
| `SimulationClock.lua` | Fixed-step simulation timing |
| `EquationCatalog.lua` | A compact catalog of governing equations |

### 与核心模块集成

扩展模块与 src/VectorForge/ 分开存放。shared/CoreRegistry.lua 提供显式依赖注入机制，允许启动脚本注册实际存在且 API 已核实的核心模块。注册表不会猜测路径，也不会自动加载模块。

```lua
local CoreRegistry = require(path.to.shared.CoreRegistry)
CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
})
local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

### 示例与验证

examples/ 包含阻尼振子响应、耦合状态演化、非线性响应、能量衰减、数值稳定性和长时间状态演化等独立研究脚本。tests/ 中的检查可作为回归测试起点，但不能替代解析基准、量纲检查、收敛研究或可信科学数据验证。

### 研究与生产状态

科学扩展属于实验性研究框架。部分模块提供可复用数值例程，其他模块仍需针对具体问题补充离散化、边界条件、材料本构关系、单位和求解策略。投入生产前，应检查输入输出、量纲、假设、边界条件、收敛性、数值稳定性和性能。

重要说明：这些扩展仍处于研究阶段，并不意味着每个物理模型都已通过实验验证。正式使用前，必须根据可信参考解验证单位、边界条件、材料假设、稳定性和收敛性。

## VectorForge 的工作方式

开发者定义问题或数学模型，选择相应模块，提供输入，并在自己的 Roblox 系统中使用返回结果。模块并不会自动连接成单一固定流程。

## 实验 · 模拟 · 数据集 · 可视化 · 基准测试

## 数学基础 · 研究笔记 · 测试 · 性能注意事项

## 仓库结构

```text
VectorForge/
├── benchmarks/
├── docs/
├── examples/
├── experiments/
├── research/
├── simulations/
├── datasets/
├── visualizations/
├── fluid-dynamics/
├── control-systems/
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
├── shared/
└── src/VectorForge/
```

## 常见问题

**重要说明：这些扩展仍处于研究阶段，并不意味着每个物理模型都已通过实验验证。正式使用前，必须根据可信参考解验证单位、边界条件、材料假设、稳定性和收敛性。**

## 文档

- [API Reference](../../docs/API.md)
- [Architecture](../../docs/ARCHITECTURE.md)
- [Mathematics](../../docs/MATHEMATICS.md)
- [Numerical Validation](../../docs/NUMERICAL_VALIDATION.md)

## 贡献

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## 开发状态

重要说明：这些扩展仍处于研究阶段，并不意味着每个物理模型都已通过实验验证。正式使用前，必须根据可信参考解验证单位、边界条件、材料假设、稳定性和收敛性。

## 许可证

MIT License — see [LICENSE](../../LICENSE).

**VectorForge**

