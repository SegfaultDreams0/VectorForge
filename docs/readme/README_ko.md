<div align="center">

# VectorForge

### Roblox Luau를 위한 고급 계산 수학

**Roblox에서 수치 기법, 기하 계산 및 수학 시스템을 탐구합니다**

[English](../../README.md) · [简体中文](README_zh.md) · [日本語](README_ja.md) · **한국어** · [Tiếng Việt](README_vi.md) · [ไทย](README_th.md) · [العربية](README_ar.md) · [MA Darija (9rombo idea)](docs/readme/README_darija.md)

[![Language](https://img.shields.io/badge/Language-Luau-blue?style=flat-square)](https://luau.org/)
[![Platform](https://img.shields.io/badge/Platform-Roblox-00A2FF?style=flat-square&logo=roblox&logoColor=white)](https://www.roblox.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](../../LICENSE)
[![Status](https://img.shields.io/badge/Status-Experimental-orange?style=flat-square)](../../README.md#project-status)

**[Quick Start](../../README.md#quick-start) · [Core Modules](../../README.md#core-modules) · [Scientific Extensions](../../README.md#scientific-extensions) · [Examples](../../README.md#examples) · [Experiments](../../README.md#experiments) · [Simulations](../../README.md#simulations) · [Datasets](../../README.md#datasets) · [Visualizations](../../README.md#visualizations) · [Documentation](../../README.md#documentation)**

</div>

---

## VectorForge는 Roblox 환경에서 고급 계산 수학을 Luau로 구현하는 방법을 탐구하는 실험적 라이브러리입니다. 리 군 운동학, 수치 선형대수, 베이지안 상태 추정, 미분기하학과 다양한 과학 계산 분야를 다룹니다.

**고급 수학 기법을 Roblox에서 접근 가능하고 재사용 가능하며 실험하기 쉽게 만드는 것이 목표입니다.**

## 빠른 시작

### 설치

**수동 설치**

1. Roblox Studio를 엽니다
2. ReplicatedStorage로 이동합니다
3. VectorForge라는 폴더를 만듭니다
4. src/VectorForge/의 ModuleScript를 해당 폴더에 복사합니다
5. 기존 ModuleScript 이름을 유지합니다

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

VectorForge에는 Rojo 프로젝트 설정이 포함되어 있습니다. default.project.json에서 src/VectorForge를 ReplicatedStorage/VectorForge에 매핑한 뒤 다음 명령을 실행하세요.

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

### 기본 사용법

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
```

## 핵심 모듈

VectorForge의 핵심 라이브러리는 현재 8개의 수학 모듈로 구성됩니다.

| Module | Domain | Main focus |
|---|---|---|
| `LieGroupKinematics` | 리 군 이론 | 회전 및 강체 변환 |
| `SpectralLinearAlgebra` | 선형대수 | 행렬 연산 및 수치 솔버 |
| `BayesianStateEstimation` | 확률 | 상태 추정 및 불확실성 |
| `DifferentialPathGeometry` | 미분기하학 | 곡선, 곡률 및 경로 분석 |
| `AutomaticDifferentiation` | 수치 미적분 | 미분 정보 전파 |
| `RigidBodyDynamics` | 고전 역학 | 힘, 토크 및 강체 운동 |
| `NumericalOptimization` | 최적화 | 수치 최소화 |
| `TrajectoryPlanning` | 운동 계획 | 궤적 구성 및 평가 |

## 과학 분야 확장

저장소에는 기존 핵심 라이브러리와 분리된 실험적 과학 계산 확장 계층도 포함되어 있습니다. 이 폴더들은 src/VectorForge/ 내부가 아니라 저장소 루트에 배치됩니다.

확장 패키지에는 15개의 과학 분야 폴더, 300개의 분야 모듈, 30개의 분야 지원 모듈, 5개의 공유 유틸리티, 이름이 지정된 시뮬레이션 예제 10개, 수치 불변성 검사 10개가 포함되어 총 355개의 Lua 파일을 제공합니다.

| Folder | Research area |
|---|---|
| `fluid-dynamics/` | **유체 역학** — 유동 모델, 운동량 방정식, 수송 및 유체 솔버 기초 |
| `control-systems/` | **제어 시스템** — 상태 공간 모델, 피드백 제어, 관측기 및 안정성 분석 |
| `finite-element-methods/` | **유한 요소법** — 요소 정식화, 재료 데이터, 수치 적분 및 조립 |
| `signal-processing/` | **신호 처리** — 이산 변환, 필터링, 컨볼루션 및 샘플링 이론 |
| `tensor-calculus/` | **텐서 미적분** — 텐서 저장, 축약, 계량 및 미분 연산 |
| `differential-equations/` | **미분 방정식** — 초기값 적분, 경계값 문제 및 수치 시간 적분 |
| `computational-geometry/` | **계산 기하학** — 매개변수 곡선, 곡률, 기하 판정 및 메시 개념 |
| `optimization-methods/` | **최적화 방법** — 기울기 방법, 선 탐색, 최소제곱 및 종료 기준 |
| `quantum-mechanics/` | **양자 역학** — 파동함수 표현, 확률 밀도 및 양자 모델 기초 |
| `thermodynamics/` | **열역학** — 상태 방정식, 열 물성, 에너지 및 단위 변환 |
| `electromagnetics/` | **전자기학** — 전자기장, 로렌츠 힘, 상수 및 장 샘플링 |
| `orbital-mechanics/` | **궤도 역학** — 이체 운동, 궤도 요소 및 천체역학 상수 |
| `rigid-body-physics/` | **강체 물리** — 관성, 각운동량, 접촉 설정 및 회전 역학 |
| `continuum-mechanics/` | **연속체 역학** — 변형률 측도, 탄성 재료 데이터 및 구성 모델 기초 |
| `stochastic-processes/` | **확률 과정** — 확률 과정, 확률적 시간 적분 및 확률 분포 |

### 폴더 구조

```text
domain-folder/
├── analysis/
├── models/
├── solvers/
├── DomainSupportOne.lua
└── DomainSupportTwo.lua
```

### 공유 유틸리티

| Module | Responsibility |
|---|---|
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping and safe division |
| `SimulationClock.lua` | Fixed-step simulation timing |
| `EquationCatalog.lua` | A compact catalog of governing equations |

### 핵심 모듈과의 통합

확장 모듈은 src/VectorForge/와 별도로 유지됩니다. shared/CoreRegistry.lua는 의존성 주입 기능을 제공하여 부트스트랩 스크립트가 실제로 존재하고 공개 API가 확인된 핵심 모듈을 등록하도록 합니다. 레지스트리는 경로를 추측하거나 모듈을 자동으로 불러오지 않습니다.

```lua
local CoreRegistry = require(path.to.shared.CoreRegistry)
CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
})
local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

### 예제 및 검증

examples/에는 감쇠 진동자 응답, 결합 상태 진화, 비선형 응답, 에너지 감쇠, 수치 안정성, 장시간 상태 진화 등의 개별 연구 스크립트가 있습니다. tests/의 검사는 회귀 테스트의 출발점이며 해석해 비교, 차원 검사, 수렴 연구 또는 신뢰할 수 있는 과학 데이터 검증을 대체하지 않습니다.

### 연구 및 프로덕션 상태

과학 확장은 실험적인 연구용 기반입니다. 일부 모듈은 재사용 가능한 수치 루틴을 제공하지만, 다른 모듈은 구체적인 문제에 맞는 이산화, 경계 조건, 구성 방정식, 단위 및 솔버 전략이 필요합니다. 프로덕션에서 사용하기 전에 입출력, 단위, 가정, 경계 조건, 수렴성, 수치 안정성 및 실행 비용을 확인하세요.

중요: 이 확장 모듈은 연구용 기반이며 모든 물리 모델이 실험적으로 검증되었다는 의미는 아닙니다. 프로덕션에 사용하기 전에 신뢰할 수 있는 기준 해와 비교하여 단위, 경계 조건, 재료 가정, 안정성 및 수렴성을 검증해야 합니다.

## VectorForge 작동 방식

개발자는 문제나 수학 모델을 정의하고 적절한 모듈을 선택한 뒤 입력을 제공하고 반환된 결과를 자신의 Roblox 시스템에서 사용합니다. 모든 모듈이 자동으로 연결되어 하나의 고정된 파이프라인으로 실행되는 것은 아닙니다.

## 실험 · 시뮬레이션 · 데이터셋 · 시각화 · 벤치마크

## 수학적 기초 · 연구 노트 · 테스트 · 성능 고려 사항

## 저장소 구조

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

## 자주 묻는 질문

**중요: 이 확장 모듈은 연구용 기반이며 모든 물리 모델이 실험적으로 검증되었다는 의미는 아닙니다. 프로덕션에 사용하기 전에 신뢰할 수 있는 기준 해와 비교하여 단위, 경계 조건, 재료 가정, 안정성 및 수렴성을 검증해야 합니다.**

## 문서

- [API Reference](../../docs/API.md)
- [Architecture](../../docs/ARCHITECTURE.md)
- [Mathematics](../../docs/MATHEMATICS.md)
- [Numerical Validation](../../docs/NUMERICAL_VALIDATION.md)

## 기여

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## 개발 상태

중요: 이 확장 모듈은 연구용 기반이며 모든 물리 모델이 실험적으로 검증되었다는 의미는 아닙니다. 프로덕션에 사용하기 전에 신뢰할 수 있는 기준 해와 비교하여 단위, 경계 조건, 재료 가정, 안정성 및 수렴성을 검증해야 합니다.

## 라이선스

MIT License — see [LICENSE](../../LICENSE).

**VectorForge**

