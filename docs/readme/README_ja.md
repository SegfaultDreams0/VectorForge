 <div align="center">

# VectorForge


<img width="2048" height="280" alt="GitHub バナー" src="https://github.com/SegfaultDreams0/VectorForge/blob/main/docs/assets/vectorforge-banner.png" />

### Roblox Luau のための高度な計算数学

**[English](../../README.md)** · [简体中文](README_zh.md) · 日本語 · [한국어](README_ko.md) · [Tiếng Việt](README_vi.md) · [ไทย](README_th.md) · [العربية](README_ar.md) · [MA Darija](README_darija.md)

**Roblox の中で数値計算法、幾何計算、数学システムを直接探究しましょう。**

VectorForge は、Lie 群運動学、数値線形代数、ベイズ状態推定、微分幾何などを含む高度な計算数学の実装を探究する、実験的な Luau ライブラリです。

<p align="center">
  <a href="https://luau.org/"><img alt="GitHub バナー" src="https://img.shields.io/badge/Language-Luau-blue?style=flat-square"></a>
  <a href="https://www.roblox.com/"><img alt="GitHub バナー" src="https://img.shields.io/badge/Platform-Roblox-00A2FF?style=flat-square&logo=roblox&logoColor=white"></a>
  <a href="LICENSE"><img alt="GitHub バナー" src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square"></a>
  <a href="#project-status"><img alt="GitHub バナー" src="https://img.shields.io/badge/Status-Experimental-orange?style=flat-square"></a>
  <br>
  <img alt="GitHub バナー" src="https://img.shields.io/github/commit-activity/m/SegfaultDreams0/VectorForge?style=flat-square">
  <img alt="GitHub バナー" src="https://img.shields.io/github/last-commit/SegfaultDreams0/VectorForge?style=flat-square">
  <img alt="GitHub バナー" src="https://img.shields.io/github/contributors/SegfaultDreams0/VectorForge?style=flat-square">
  <img alt="GitHub バナー" src="https://img.shields.io/github/issues-closed/SegfaultDreams0/VectorForge?style=flat-square">
</p>

**[クイックスタート](#quick-start) · [コアモジュール](#core-modules) · [科学分野の拡張](#scientific-extensions) · [サンプル](#examples) · [実験](#experiments) · [シミュレーション](#simulations) · [データセット](#datasets) · [可視化](#visualizations) · [ドキュメント](#documentation)**

</div>

---

## 概要

Roblox はインタラクティブな体験を構築するための便利な環境を提供しますが、数学的な問題によっては、より専門的な数値技法が必要になります。

VectorForge は、独立した数学モジュール群を通じて、こうした技法を Luau でどのように実装できるかを探究します。リポジトリには、流体力学、有限要素法、量子力学、電磁気学、連続体力学、軌道力学、確率過程などの科学計算分野を扱う、より大規模な実験的研究レイヤーも含まれています。

このプロジェクトでは、数値解析、ロボティクス、計算幾何学、古典力学、確率論、最適化などで一般的に扱われる概念を取り上げています。

Roblox の組み込み API を置き換えることを目的とするのではなく、VectorForge は従来のゲームスクリプトの範囲を超える数学演算に重点を置いています。

**高度な数学技法を Roblox で利用しやすく、再利用可能で、実験に開かれたものにすることが目標です。**

<a id="quick-start"></a>
## クイックスタート

### インストール

VectorForge は手動でインストールすることも、付属の Rojo プロジェクト設定を使用することもできます。

**手動インストール**

1. Roblox Studio を開きます。
2. `ReplicatedStorage` に移動します。
3. `VectorForge` という名前のフォルダーを作成します。
4. `src/VectorForge/` 内の ModuleScript をそのフォルダーにコピーします。
5. `ReplicatedStorage/VectorForgeShared` を作成し、共有ユーティリティの ModuleScript をその中にコピーします。
6. 元の ModuleScript 名とフォルダー構成を維持してください。

Explorer の階層は次のようになります。

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

VectorForge には Rojo プロジェクト設定が含まれています。

`default.project.json` が `src/VectorForge` を `ReplicatedStorage/VectorForge` に、リポジトリルートの `VectorForgeShared/` を `ReplicatedStorage/VectorForgeShared` にマッピングしていることを確認してください。このマッピングを前提にする前に、プロジェクトファイルを確認してください。

プロジェクトをビルドします。

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

[Rojo ドキュメント](https://rojo.space/)

### 基本的な使い方

インストール後、Roblox の `require()` 関数を使ってモジュールを読み込みます。

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

各モジュールはそれぞれ独自の機能を提供します。利用可能な操作、パラメーター、戻り値については [API リファレンス](../../docs/API.md) を参照してください。

---

<a id="core-modules"></a>
## コアモジュール

VectorForge では現在、8 つの数学分野を探究しています。

| モジュール | 数学分野 | 主な用途 |
|---|---|---|
| `LieGroupKinematics` | Lie 理論 | 回転と剛体変換 |
| `SpectralLinearAlgebra` | 線形代数 | 行列演算と数値ソルバー |
| `BayesianStateEstimation` | 確率論 | 状態推定と不確実性 |
| `DifferentialPathGeometry` | 微分幾何学 | 曲線、曲率、経路解析 |
| `AutomaticDifferentiation` | 数値微積分 | 導関数の伝播 |
| `RigidBodyDynamics` | 古典力学 | 力、トルク、剛体運動 |
| `NumericalOptimization` | 最適化 | 数値的最小化 |
| `TrajectoryPlanning` | モーションプランニング | 軌道の構築と評価 |

### 1. LieGroupKinematics

**Lie 群 · 回転理論 · 剛体運動学**

三次元空間における回転と剛体変換を表現するための数学的手法です。

扱う概念：

- クォータニオン代数。
- SO(3) の回転演算。
- SE(3) の剛体変換。
- 指数写像と対数写像。
- 球面線形補間（SLERP）。
- 姿勢の合成と逆変換。
- ツイスト表現。

**想定される用途**

- プロシージャルアニメーション。
- 滑らかなカメラの向き制御。
- ロボティクスに着想を得た移動。
- 三次元姿勢の補間。
- 空間シミュレーション。

### 2. SpectralLinearAlgebra

**数値線形代数 · 行列計算**

行列の操作、線形システムの求解、数学的分解を行うための数値手法です。

扱う概念：

- 行列の乗算と転置。
- LU 分解。
- 行列式の計算。
- Cholesky 分解。
- Householder QR 分解。
- 対称行列の固有値近似。
- 共役勾配法。
- 最小二乗推定。
- 線形システムの求解。

**想定される用途**

- 数値シミュレーション。
- 多項式回帰。
- パラメーター推定。
- 数学的最適化。
- 計算モデルの構築。

### 3. BayesianStateEstimation

**ベイズ推論 · 確率論 · 状態推定**

観測が不完全である場合や不確実性の影響を受ける場合に、動的システムの内部状態を推定する手法です。

扱う概念：

- 拡張カルマンフィルター（EKF）。
- 状態遷移モデル。
- 観測モデル。
- 共分散の伝播。
- 数値ヤコビアン近似。
- 観測補正。
- イノベーションの計算。
- 統計的な観測ゲーティング。

**想定される用途**

- ノイズを含む物体位置の追跡。
- 運動予測。
- センサーシミュレーション。
- 軌道推定。
- 動的システムのモデリング。

### 4. DifferentialPathGeometry

**微分幾何学 · 曲線解析**

パラメーター化された曲線と、その幾何学的特性を数学的に解析します。

扱う概念：

- Hermite 曲線補間。
- 一階および高階導関数。
- 曲率と捩率。
- 数値的な弧長積分。
- 弧長パラメーター化。
- Frenet フレーム。
- 平行移動フレーム。
- 最近接点の推定。
- 最小ジャーク軌道の生成。

**想定される用途**

- プロシージャルな経路生成。
- 滑らかな NPC の軌道。
- カメラレールシステム。
- 車両軌道のモデリング。
- 三次元運動の解析。

### 5. AutomaticDifferentiation

**自動微分 · 数値微積分**

算術演算やサポート対象の計算式を通じて導関数情報を伝播させ、導関数の計算を探究します。

扱う概念：

- フォワードモードの導関数伝播。
- 計算式の評価。
- 導関数の追跡。
- 感度解析。

**想定される用途**

- 勾配ベースの最適化。
- パラメーター fitting。
- 感度解析。
- 微分可能な数学実験。

### 6. RigidBodyDynamics

**古典力学 · 物理シミュレーション**

加えられた力、トルク、慣性特性のもとでの剛体運動を数学的に記述する方法を探究します。

扱う概念：

- 並進運動と角運動。
- 質量と慣性の表現。
- 力とトルクの関係。
- 剛体状態の時間発展。
- 並進・回転ダイナミクス。

**想定される用途**

- 物理実験。
- 機械システムのモデリング。
- ロボティクスに着想を得たシミュレーション。
- 運動解析。

### 7. NumericalOptimization

**数値最適化 · 反復的な最小化**

サポートされる仮定と制約のもとで、目的関数を最小化する解を見つける数値技法を探究します。

扱う概念：

- 目的関数の評価。
- 反復的なパラメーター更新。
- 勾配ベース最適化の概念。
- 収束判定基準。
- 数値的最小化。

**想定される用途**

- パラメーター推定。
- 曲線フィッティング。
- 数学的キャリブレーション。
- 最適化実験。

### 8. TrajectoryPlanning

**モーションプランニング · 軌道生成**

状態間または空間目標間の経路や、時間依存の運動プロファイルを構築・評価します。

扱う概念：

- 軌道の構築。
- 運動プロファイルの評価。
- 境界条件の処理。
- 滑らかな移動計画。
- 幾何学表現および運動学表現との統合。

**想定される用途**

- NPC の移動。
- ロボティクスに着想を得た経路計画。
- カメラとオブジェクトの動き。
- プロシージャルアニメーション。

---

<a id="scientific-extensions"></a>
## 科学分野の拡張

リポジトリには、元の 8 つのコアモジュールに加えて、独立した実験的拡張レイヤーが含まれています。これらの追加要素はリポジトリのルートに科学分野ごとに整理されており、`src/VectorForge/` の中には配置されていません。そのため、元のコアライブラリと広範な研究モジュールは分離されています。

現在の拡張パッケージの構成：

- **15 個の科学分野フォルダー**
- **300 個の分野別モジュール**（各分野に 20 個）
- **30 個の分野サポートモジュール**（各分野フォルダーのルートに追加で 2 ファイル）
- `VectorForgeShared/` にある **7 個の共有ユーティリティモジュール**
- **名前付きシミュレーション例 10 個**
- **数値的不変条件と検証の例 10 個**

拡張パッケージには、この README を除いて **357 個の Lua ファイル**があります。これはリポジトリ内のファイル数であり、すべてのモジュールが完全に検証済みの科学ソルバーであることを意味するものではありません。

### 科学分野

| 分野フォルダー | 主な研究領域 |
|---|---|
| `fluid-dynamics/` | 流れモデル、運動量方程式、輸送、流体ソルバーの基礎 |
| `control-systems/` | 状態空間モデル、フィードバック制御、オブザーバー、安定性解析 |
| `finite-element-methods/` | 要素定式化、材料データ、数値積分、組み立ての概念 |
| `signal-processing/` | 離散変換、フィルタリング、畳み込み、サンプリング理論 |
| `tensor-calculus/` | テンソルの格納、縮約、計量、微分演算 |
| `differential-equations/` | 初期値積分、境界値問題、数値ステップ計算 |
| `computational-geometry/` | パラメーター曲線、曲率、幾何述語、メッシュの概念 |
| `optimization-methods/` | 勾配法、ラインサーチ、最小二乗目的関数、停止規則 |
| `quantum-mechanics/` | 波動関数表現、確率密度、量子モデルの基礎 |
| `thermodynamics/` | 状態方程式、熱的性質、エネルギー、熱力学的換算 |
| `electromagnetics/` | 電磁場、ローレンツ力、定数、場のサンプリング |
| `orbital-mechanics/` | 二体運動、軌道パラメーター、宇宙航行力学の定数 |
| `rigid-body-physics/` | 慣性、角運動量、接触設定、回転ダイナミクス |
| `continuum-mechanics/` | ひずみ尺度、弾性材料データ、構成モデルの基礎 |
| `stochastic-processes/` | 確率過程、確率的ステップ計算、確率分布 |

### フォルダー構成

各科学分野には 3 つのサブフォルダーがあります。

- `analysis/` — 解析向けのモジュールと計算
- `models/` — モデルと状態の表現
- `solvers/` — 数値手順とソルバー関連モジュール

各分野フォルダーのルートには、さらに 2 つのサポートモジュールがあります。これらは分野固有の設定、材料データ、定数、サンプリング規則、またはヘルパー関数を提供します。

共有ユーティリティは、ルートにある単一の `VectorForgeShared/` フォルダーにまとめられています。Roblox Studio では、このフォルダーを `ReplicatedStorage/VectorForgeShared` の下に配置します。

| モジュール | 役割 |
|---|---|
| `Constants.lua` | 共有の物理定数および数学定数 |
| `CoreRegistry.lua` | 既存の VectorForge コアモジュールの明示的な登録と検索 |
| `EquationCatalog.lua` | 参照用の支配方程式カタログ |
| `LinearAlgebra.lua` | 基本的な行配列行列演算 |
| `NumericalGuards.lua` | 有限値チェック、クランプ、安全な除算 |
| `NumericalKernels.lua` | 共有の低レベル数値カーネル |
| `SimulationClock.lua` | 固定ステップのシミュレーション時刻管理 |

### コアモジュールとの統合

拡張モジュールは `src/VectorForge/` とは分けて管理されます。`VectorForgeShared/CoreRegistry.lua` は依存性注入の仕組みを提供し、ブートストラップスクリプトから実際のコアモジュールインスタンスを登録できます。

レジストリはモジュールパスを推測したり、コアモジュールを自動ロードしたりしません。プロジェクトに存在し、公開 API が確認済みのモジュールのみを登録してください。

**重要：** 共有フォルダー名は `VectorForgeShared` に統一してください。`shared`、`Shared`、`VectorForgeShared` の下に複数のコピーを置かないでください。分野モジュールとブートストラップスクリプトは、同じ `ReplicatedStorage/VectorForgeShared` インスタンスを参照する必要があります。

例：

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

拡張ソースでは数値配列を使って数学的状態を表現し、Roblox の空間データ型には直接依存しません。ただし、すべてのアルゴリズムが完全な物理ソルバーである、あるいはすべてのモジュールが参照実装で検証済みであるという意味ではありません。

### サンプルと検証ファイル

`examples/` フォルダーには、減衰振動応答、連成状態の時間発展、非線形応答、エネルギー減衰、積分安定性、長時間にわたる状態の時間発展など、名前付きの数値研究が含まれています。

`tests/` に追加された拡張テストには、小規模な数値的不変条件チェックが含まれています。回帰テストの出発点として役立ちますが、解析ベンチマーク、次元チェック、収束研究、信頼できる科学データとの照合の代わりにはなりません。

### 研究および本番利用の状況

科学分野の拡張は実験的な研究基盤です。一部のモジュールは再利用可能な数値ルーチンや分野固有の計算を提供しますが、別のモジュールは、問題に応じた離散化、境界条件、構成則、単位、ソルバー戦略をまだ必要とする基盤です。

本番環境の体験で拡張モジュールを使用する前に：

1. モジュールの入力、出力、次元、単位を確認します。
2. 仮定と境界条件を検証します。
3. 結果を解析解または信頼できる参照データと比較します。
4. 代表的な入力範囲で収束性と数値安定性をテストします。
5. Roblox Studio で実行コストをプロファイルします。
6. コアモジュールとの統合を、実際の公開 API に照らして検証します。

これらの追加要素はリポジトリの研究範囲を広げますが、元の 8 つのコアモジュールのインストール手順は変更しません。

---

## VectorForge の仕組み

VectorForge は Roblox 体験内で使用できる独立した数学モジュール群を提供します。問題や数学モデルを定義し、関連するモジュールを選び、必要な入力を渡して、返された結果を自分のシステムで利用します。

以下の図は、このワークフローの概要を示しています。これは開発者によるライブラリの利用方法を概念的に説明したものであり、すべてのモジュールが自動的に接続されることや、VectorForge が単一の固定パイプラインを実行することを示すものではありません。

![How VectorForge works — computation flow and module overview](../../docs/assets/how-vectorforge-works.png)

## VectorForge の構成

各モジュールは、それぞれ異なる数学的な役割を中心に整理されています。

![How VectorForge works — computation flow and module overview](../../docs/assets/How-VectorForge-Fits-Together.png)

このモジュール構成は、次の点を支援することを目的としています。

- 独立した数学コンポーネント。
- 再利用可能な実装。
- 明確な責務の分離。
- テストと保守の容易さ。
- 将来の数学的拡張。

詳細は [ARCHITECTURE.md](../../docs/ARCHITECTURE.md) を参照してください。

---

<a id="examples"></a>
## サンプル

`examples/` ディレクトリには、選択した VectorForge モジュールを Roblox 内で使用する方法を示す独立したデモが含まれています。

| サンプル | 説明 |
|---|---|
| 姿勢補間 | 剛体姿勢間の補間 |
| 微分経路 | 幾何学的経路に沿った曲線サンプリングと移動 |
| ベイズ運動追跡 | ノイズを含む位置観測を使った推定 |
| 最小二乗回帰 | 数値線形代数による多項式フィッティング |
| 積分デモ | 拡張モジュール群を利用するデモ |

各サンプルは単独で理解できることを目指しており、さらなる実験の出発点となります。

[examples/README.md](../../examples/README.md) を参照してください。

<a id="experiments"></a>
## 実験

`experiments/` ディレクトリには、数学的概念を可視化し、応用の可能性を調べるための探索的スクリプトが含まれています。

| 実験 | 説明 |
|---|---|
| 天体力学 | 単純化した重力運動の教育用可視化 |
| 軌道シミュレーション | 単純化した力学による軌道の探究 |
| カルマン可視化 | ノイズを含む観測と平滑化推定の可視化 |
| 軌道ラボ | 実験的な軌道構築 |
| 数値安定性ラボ | 数値加算手法の比較 |

これらの実験は探究を目的としており、本番向けシミュレーションではありません。

一部のデモでは、単純化した参照計算や可視化アダプターを使用します。たとえば、天体および軌道のデモは一般相対性理論ではなく、単純化したニュートン力学モデルを使います。カルマン可視化は簡略化された平滑化デモであり、完全な EKF 実装ではありません。

[experiments/README.md](../../experiments/README.md) を参照してください。


<a id="simulations"></a>
## シミュレーション

`simulations/` フォルダーには、独立した数値モデルがいくつか保存されています。Roblox シーンに計算を結び付けずに、システムが時間とともにどのように変化するかを試す際に便利です。

現在のスクリプトは 2 つの異なる問題を扱います。

| スクリプト | モデルの内容 |
|---|---|
| `TwoBodyOrbit.lua` | 単純化したニュートン重力モデルにおける相対運動 |
| `DampedOscillator.lua` | 線形減衰を持つばねに接続された質量 |

どちらも 4 次の Runge–Kutta ステップを使用します。初期状態と時間刻みは呼び出し側が指定するため、シミュレーションクロックと停止条件も呼び出し側が管理します。

軌道の例では SI 単位、すなわちメートル、メートル毎秒、秒、および立方メートル毎平方秒の重力パラメーターを使用します。振動子ではメートル、キログラム、秒、ニュートン毎メートル、ニュートン秒毎メートルを使用します。

これらは意図的に小規模なモデルです。軌道スクリプトは、他の天体、大気抵抗、衝突、相対論的効果を考慮しません。振動子は線形ばねと線形粘性減衰を仮定します。どちらも本番向け物理エンジンとして扱うべきではありません。

各スクリプトのセットアップ、パラメーター、制限については [simulations/README.md](../../simulations/README.md) を参照してください。

<a id="datasets"></a>
## データセット

`datasets/` フォルダーには、プロジェクトのスクリプトや実験で使う参照値とサンプルデータが保存されています。データをアルゴリズムから分離することで、同じ入力を再利用しやすくなり、デモが扱っている内容も明確になります。

| ファイル | 内容 |
|---|---|
| `PhysicalConstants.lua` | SI 単位による物理定数の小さなコレクション |
| `SolarSystem.lua` | 選択した惑星の近似質量、平均軌道長半径、公転周期、導出された重力パラメーター |
| `MotionSamples.lua` | タイムスタンプ付きの合成 2D 位置観測の短い系列 |

惑星データは丸められた参照値であり、高精度の暦表ではありません。運動サンプルは生成された例であり、実センサーの測定値ではありません。数値比較や状態推定の実験では、この違いが重要です。

データを追加する場合は、単位を記載し、実測値、合成データ、近似値のいずれであるかを明示してください。後々の混乱を減らせます。

データの規約と使用例については [datasets/README.md](../../datasets/README.md) を参照してください。

<a id="visualizations"></a>
## 可視化

`visualizations/` フォルダーには、計算結果を 3D シーンに表示するための小規模な Roblox ヘルパーが含まれています。数学と描画を分離することが目的です。シミュレーションやアルゴリズムが値を生成し、レンダラーがそれを確認可能な形に変換します。

| モジュール | 表示内容 |
|---|---|
| `TrajectoryRenderer.lua` | アンカーされたセグメントで接続された `Vector3` 点の列 |
| `VectorFieldRenderer.lua` | 方向インジケーターとして表示されるベクトルサンプル |

どちらのモジュールも、指定した親の下に `Model` を作成します。各パーツはアンカーされ、衝突しません。可視化が終わったら、返されたモデルを破棄して生成されたインスタンスをクリーンアップしてください。

これらのヘルパーはデバッグや小規模なデモ向けであり、高密度の科学的プロットを目的としていません。パーツ数が多いと、特に頻繁に複製または再構築される場合に負荷が高くなります。サンプル数を適切に保ち、Studio でプロファイルしてください。

使用例とレンダラーのオプションは [visualizations/README.md](../../visualizations/README.md) を参照してください。

## ベンチマーク

`benchmarks/` ディレクトリには、選択した数学演算の性能を調査するためのワークロード指向スクリプトが含まれています。

現在のベンチマーク領域：

- 行列計算。
- 数値最適化。
- 微分幾何学。
- 状態推定。
- 共有ベンチマークユーティリティ。

ベンチマーク結果は、ハードウェア、実行時環境、入力次元、実装の詳細によって変わる場合があります。

一部のスクリプトでは、ワークロードのコールバックを検証済みの公開 API に接続するアダプターが必要です。スクリプトが存在するからといって、包括的な性能測定が完了しているわけではありません。

ドキュメント：

- [ベンチマークガイド](../../docs/BENCHMARKING.md)
- [ベンチマークスクリプト](../../benchmarks/README.md)

## 数学的基礎

VectorForge は複数の数学分野を基盤としています。

| 分野 | 概念 |
|---|---|
| 線形代数 | 行列演算、分解、固有値 |
| 微分幾何学 | 曲率、捩率、接線・法線フレーム |
| Lie 理論 | SO(3)、SE(3)、指数写像と対数写像 |
| 数値解析 | 近似、積分、反復ソルバー |
| 確率論 | ベイズ推定と不確実性 |
| 最適化 | 最小二乗推定と反復的最小化 |
| 信号処理 | 周波数領域解析と数値変換 |

詳しい説明は [MATHEMATICS.md](../../docs/MATHEMATICS.md) を参照してください。

## 研究ノート

`research/` ディレクトリには、補足的な数学ノートと探索資料が含まれています。

現在のトピック：

- Lie 群の数学と空間変換。
- 数値手法と計算安定性。
- ベイズ状態推定。
- 将来のアルゴリズムと数学的拡張の候補。

これらのノートは、開発中の理論的検討や可能なアプローチを記録したものです。補足資料であり、正式な数学的検証ではありません。

[research/README.md](../../research/README.md) を参照してください。

---

## テスト

VectorForge には、各モジュールの重要な操作を対象とする回帰テストおよび包括的なテストスクリプトが含まれています。

現在のテスト領域：

- クォータニオン演算と剛体変換。
- 行列の乗算と分解。
- 線形システムの求解。
- 固有値計算。
- 数値最適化。
- 拡張カルマンフィルターの操作。
- 曲線評価と微分特性。
- 弧長計算。
- 軌道の境界条件。
- 自動微分。
- 剛体ダイナミクスと軌道計画。

### テストの実行

1. VectorForge モジュールを `ReplicatedStorage/VectorForge` にインストールします。
2. テストランナーを `ServerScriptService` に配置します。
3. Roblox Studio で Play セッションを開始します。
4. Output ウィンドウを開きます。
5. テスト結果を確認します。

このテストスイートは初期的な回帰テスト基盤を提供しますが、正式な数学的検証を構成するものではなく、数値安定性を保証するものでもありません。

[tests/README.md](../../tests/README.md) を参照してください。

## パフォーマンスに関する考慮事項

数値アルゴリズムのコストは、入力次元、反復回数、実行頻度によって大きくなる場合があります。

VectorForge を使用する際は、次の点を考慮してください。

- 不要な行列分解を避ける。
- 入力が変わらない場合は計算済みの結果を再利用する。
- フレーム依存ループ内で高コストの処理を実行しすぎない。
- 適切なソルバー許容誤差と反復上限を選択する。
- 代表的なワークロードでプロファイルする。
- 必要に応じて、サーバー側の権威ある計算とクライアント側の表示計算を分離する。

現在の実装は、まだ包括的なベンチマークを受けていません。

## リポジトリ構成

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

| ディレクトリ | 役割 |
|---|---|
| `src/` | Roblox Luau 向け VectorForge コアモジュール |
| `docs/` | 技術ドキュメントと数学的解説 |
| `examples/` | コアモジュールの実用デモ |
| `tests/` | 回帰テストと数値チェック |
| `benchmarks/` | ワークロードベースの性能測定 |
| `experiments/` | 探索的スクリプトとデモ |
| `research/` | 検討中の数学的ノートとアイデア |
| `computational-research/` | 独立した高度な数学・科学スクリプト |
| `simulations/` | 時間ステップで進む数値モデル |
| `datasets/` | 参照定数とサンプル入力 |
| `visualizations/` | 数値結果を表示する Roblox ヘルパー |
| 科学分野フォルダー | 物理、工学、幾何学、最適化、科学計算の実験モジュール |
| `VectorForgeShared/` | 共有ユーティリティ層と明示的なコアモジュール登録 |

---

## よくある質問

<details>
<summary><strong>VectorForge は Roblox の Vector3 や CFrame の代替ですか？</strong></summary>

いいえ。VectorForge は従来のベクトルや変換ユーティリティを超える数学演算を探究します。Roblox の組み込み API は、日常的な開発タスクの多くで引き続き有用かつ適切です。

</details>

<details>
<summary><strong>VectorForge は本番環境で使用できますか？</strong></summary>

まだです。これは実験的なプロジェクトです。API、数値的な挙動、性能、実装の詳細は変更される可能性があります。

</details>

<details>
<summary><strong>個々のモジュールを別々に使用できますか？</strong></summary>

このライブラリは個別の数学モジュールで構成されており、実用上可能な範囲で独立して動作することを意図しています。利用可能な機能と依存関係については API ドキュメントを確認してください。

</details>

<details>
<summary><strong>simulations、datasets、visualizations フォルダーは何のためのものですか？</strong></summary>

これらのフォルダーはコアライブラリと並列に配置されています。`simulations/` には小規模な時間ステップモデル、`datasets/` には参照データとサンプル入力、`visualizations/` には結果を表示する Roblox ヘルパーが含まれています。これらは補助資料であり、コアモジュールのインストール方法は変わりません。

</details>

<details>
<summary><strong>VectorForge には性能ベンチマークが含まれていますか？</strong></summary>

選択したワークロード向けのベンチマークスクリプトが含まれています。一部にはアダプターが必要であり、包括的なベンチマーク結果はまだ確立されていません。

</details>

<details>
<summary><strong>使用例はどこで確認できますか？</strong></summary>

`examples/` ディレクトリと [examples/README.md](../../examples/README.md) を確認してください。`simulations/` と `visualizations/` にも、テーマを絞ったデモがあります。

</details>

<details>
<summary><strong>貢献できますか？</strong></summary>

技術的なフィードバック、バグ報告、提案、貢献を歓迎します。変更を送信する前に、コントリビューションガイドラインを確認してください。

</details>

---


<details>
<summary><strong>科学分野のフォルダーは元のコアモジュールの一部ですか？</strong></summary>

これらはリポジトリルートにある独立した実験的拡張レイヤーです。元の 8 つのコアモジュールは引き続き `src/VectorForge/` にあります。拡張は独立して開発・テストでき、オプションのコアモジュール依存関係は `VectorForgeShared/CoreRegistry.lua` を通じて登録できます。

</details>

<details>
<summary><strong>科学拡張モジュールはすべて完成済みで検証済みのソルバーですか？</strong></summary>

いいえ。拡張は研究用の基盤です。本番利用の前に、各モジュールの数学的仮定、単位、境界条件、収束性、数値安定性、および実際のコアモジュール API との互換性を確認する必要があります。

</details>

<a id="documentation"></a>
## ドキュメント

`docs/` ディレクトリには VectorForge の技術資料が含まれています。

- [API リファレンス](../../docs/API.md) — 利用可能な操作とモジュールインターフェース。
- [アーキテクチャ](../../docs/ARCHITECTURE.md) — モジュール構成と設計。
- [数学](../../docs/MATHEMATICS.md) — 数学的概念と基礎。
- [数値検証](../../docs/NUMERICAL_VALIDATION.md) — 検証に関する考慮事項。
- [ベンチマーク](../../docs/BENCHMARKING.md) — ベンチマーク方法とガイド。
- [設計上の決定](../../docs/DESIGN_DECISIONS.md) — プロジェクトの設計判断。
- [用語集](../../docs/GLOSSARY.md) — 数学・技術用語。
- [シミュレーション](../../simulations/README.md) — 数値モデルと積分の詳細。
- [データセット](../../datasets/README.md) — 参照値、単位、サンプルデータ。
- [可視化](../../visualizations/README.md) — シーン描画ヘルパーと使用方法。

科学分野の拡張フォルダーでは、現在、ソース内の説明とこのリポジトリ概要を通じて各モジュールの意図を説明しています。モジュールの検証が進むにつれて、分野別 API リファレンスと検証レポートを追加する必要があります。

## コントリビューション

貢献、技術的なフィードバック、バグ報告、提案を歓迎します。

問題を見つけた場合は、次の情報を含めてください。

- 影響を受けるモジュール。
- 最小限の再現可能な例。
- 期待される数学的な挙動。
- 実際に観測された挙動。
- 関連する Roblox Studio Output のエラー。

プルリクエストを送信する前に [CONTRIBUTING.md](../../CONTRIBUTING.md) を参照してください。

## 開発状況

VectorForge は現在も活発な実験段階にあります。今後の開発候補には次のものがあります。

**数値面の改善**
- 追加の行列分解手法。
- 数値安定性の向上。
- 退化した入力への対応改善。
- 追加の反復ソルバー。
- 収束診断の改善。

**数学的な拡張**
- 確率および推定技法の追加。
- 幾何変換ユーティリティの拡充。
- 数値積分手法。
- 微分幾何演算の追加。

**開発者体験**
- API ドキュメントの拡充。
- 実用的なサンプルの追加。
- 自動テストの追加。
- パフォーマンスベンチマーク。
- エラー処理と検証の改善。

これらは開発の方向性であり、リリースを保証する約束ではありません。

## ライセンス

VectorForge は MIT License のもとで配布されています。

ライセンス全文は [LICENSE](../../LICENSE) を参照してください。

---

<div align="center">

**VectorForge**

*Roblox Luau で計算数学を探究する。*

</div>
