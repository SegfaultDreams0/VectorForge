
# VectorForge
### Roblox Luau 向け高度計算数学
**Roblox 上で数値手法、幾何計算、数学システムを探究する**

[English](../../README.md) · [简体中文](README_zh.md) · [한국어](README_ko.md) · [Tiếng Việt](README_vi.md) · [ไทย](README_th.md) · [العربية](README_ar.md)

---

## VectorForge は、Roblox 環境で高度な計算数学を実装する方法を探る実験的な Luau ライブラリです。リー群運動学、数値線形代数、ベイズ状態推定、微分幾何に加え、幅広い科学計算分野を扱います。

**高度な数学的手法を Roblox で利用しやすく、再利用可能で、実験しやすいものにすることを目指します。**

## クイックスタート

### インストール

**手動インストール**

1. Roblox Studio を開く
2. ReplicatedStorage に移動する
3. VectorForge という名前のフォルダーを作成する
4. src/VectorForge/ の ModuleScript をそのフォルダーへコピーする
5. 元の ModuleScript 名を維持する

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

VectorForge には Rojo のプロジェクト設定が含まれています。default.project.json で src/VectorForge を ReplicatedStorage/VectorForge にマッピングしてください。次に以下を実行します。

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

### 基本的な使い方

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
```

## コアモジュール

VectorForge のコア部分は、現在 8 つの数学モジュールで構成されています。

| Module | Domain | Main focus |
|---|---|---|
| `LieGroupKinematics` | リー群理論 | 回転と剛体変換 |
| `SpectralLinearAlgebra` | 線形代数 | 行列演算と数値ソルバー |
| `BayesianStateEstimation` | 確率論 | 状態推定と不確実性 |
| `DifferentialPathGeometry` | 微分幾何学 | 曲線、曲率、経路解析 |
| `AutomaticDifferentiation` | 数値微分 | 導関数の伝播 |
| `RigidBodyDynamics` | 古典力学 | 力、トルク、剛体運動 |
| `NumericalOptimization` | 最適化 | 数値最小化 |
| `TrajectoryPlanning` | 軌道計画 | 軌道の構築と評価 |

## 科学分野の拡張

リポジトリには、元のコアライブラリとは分離された実験的な科学計算拡張レイヤーも含まれています。これらのフォルダーは src/VectorForge/ の中ではなく、リポジトリのルートに配置されます。

拡張パッケージには、15 の科学分野フォルダー、300 の分野別モジュール、30 の分野別サポートモジュール、5 つの共有ユーティリティ、10 個の名前付きシミュレーション例、10 個の数値不変条件チェックが含まれ、合計 355 個の Lua ファイルがあります。

| Folder | Research area |
|---|---|
| `fluid-dynamics/` | **流体力学** — 流動モデル、運動量方程式、輸送、流体ソルバーの基礎 |
| `control-systems/` | **制御システム** — 状態空間モデル、フィードバック制御、オブザーバー、安定性解析 |
| `finite-element-methods/` | **有限要素法** — 要素定式化、材料データ、数値積分、アセンブリ |
| `signal-processing/` | **信号処理** — 離散変換、フィルタリング、畳み込み、サンプリング理論 |
| `tensor-calculus/` | **テンソル解析** — テンソル格納、縮約、計量、微分演算 |
| `differential-equations/` | **微分方程式** — 初期値積分、境界値問題、数値時間発展 |
| `computational-geometry/` | **計算幾何学** — パラメトリック曲線、曲率、幾何判定、メッシュ概念 |
| `optimization-methods/` | **最適化手法** — 勾配法、ラインサーチ、最小二乗、停止条件 |
| `quantum-mechanics/` | **量子力学** — 波動関数表現、確率密度、量子モデルの基礎 |
| `thermodynamics/` | **熱力学** — 状態方程式、熱物性、エネルギー、単位変換 |
| `electromagnetics/` | **電磁気学** — 電磁場、ローレンツ力、定数、場のサンプリング |
| `orbital-mechanics/` | **軌道力学** — 二体運動、軌道要素、天体力学定数 |
| `rigid-body-physics/` | **剛体物理** — 慣性、角運動量、接触設定、回転運動 |
| `continuum-mechanics/` | **連続体力学** — ひずみ、弾性材料データ、構成モデルの基礎 |
| `stochastic-processes/` | **確率過程** — 確率過程、確率的時間積分、確率分布 |

### フォルダー構成

```text
domain-folder/
├── analysis/
├── models/
├── solvers/
├── DomainSupportOne.lua
└── DomainSupportTwo.lua
```

### 共有ユーティリティ

| Module | Responsibility |
|---|---|
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping and safe division |
| `SimulationClock.lua` | Fixed-step simulation timing |
| `EquationCatalog.lua` | A compact catalog of governing equations |

### コアモジュールとの統合

拡張モジュールは src/VectorForge/ とは別に配置されます。shared/CoreRegistry.lua は依存性注入の仕組みを提供し、起動スクリプトから実在し公開 API を確認済みのコアモジュールを登録できます。レジストリがパスを推測したり、モジュールを自動ロードしたりすることはありません。

```lua
local CoreRegistry = require(path.to.shared.CoreRegistry)
CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
})
local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

### サンプルと検証

examples/ には、減衰振動子、連成状態の時間発展、非線形応答、エネルギー減衰、数値安定性、長時間状態発展などの個別研究スクリプトがあります。tests/ のチェックは回帰テストの出発点ですが、解析解との比較、次元チェック、収束試験、信頼できる科学データによる検証の代わりにはなりません。

### 研究および本番利用の状況

科学分野の拡張は実験的な研究用基盤です。一部のモジュールは再利用可能な数値ルーチンを提供しますが、他のモジュールは具体的な問題に合わせた離散化、境界条件、構成則、単位、ソルバー戦略を必要とします。本番利用の前に、入出力、単位、仮定、境界条件、収束性、数値安定性、実行コストを確認してください。

重要：これらの拡張は研究段階であり、すべての物理モデルが実験的に検証済みという意味ではありません。本番利用の前に、単位、境界条件、材料仮定、安定性、収束性を信頼できる基準解と照合してください。

## VectorForge の仕組み

開発者は問題や数学モデルを定義し、適切なモジュールを選択して入力を与え、返された結果を独自の Roblox システムで利用します。すべてのモジュールが自動的に接続され、固定された単一パイプラインとして動作するわけではありません。

## 実験 · シミュレーション · データセット · 可視化 · ベンチマーク

## 数学的基礎 · 研究ノート · テスト · パフォーマンス上の注意

## リポジトリ構成

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

## よくある質問

**重要：これらの拡張は研究段階であり、すべての物理モデルが実験的に検証済みという意味ではありません。本番利用の前に、単位、境界条件、材料仮定、安定性、収束性を信頼できる基準解と照合してください。**

## ドキュメント

- [API Reference](../../docs/API.md)
- [Architecture](../../docs/ARCHITECTURE.md)
- [Mathematics](../../docs/MATHEMATICS.md)
- [Numerical Validation](../../docs/NUMERICAL_VALIDATION.md)

## コントリビューション

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## 開発状況

重要：これらの拡張は研究段階であり、すべての物理モデルが実験的に検証済みという意味ではありません。本番利用の前に、単位、境界条件、材料仮定、安定性、収束性を信頼できる基準解と照合してください。

## ライセンス

MIT License — see [LICENSE](../../LICENSE).

**VectorForge**

