
# VectorForge
### คณิตศาสตร์เชิงคำนวณขั้นสูงสำหรับ Roblox Luau
**สำรวจวิธีเชิงตัวเลข การคำนวณเรขาคณิต และระบบคณิตศาสตร์ภายใน Roblox**

[English](../../README.md) · [简体中文](README_zh.md) · [日本語](README_ja.md) · [한국어](README_ko.md) · [Tiếng Việt](README_vi.md) · [العربية](README_ar.md)

---

## VectorForge เป็นไลบรารี Luau เชิงทดลองที่ศึกษาการนำคณิตศาสตร์เชิงคำนวณขั้นสูงมาใช้ในสภาพแวดล้อม Roblox ครอบคลุมจลนศาสตร์ของ Lie group พีชคณิตเชิงเส้นเชิงตัวเลข การประมาณสถานะแบบเบย์ เรขาคณิตเชิงอนุพันธ์ และหัวข้อการคำนวณทางวิทยาศาสตร์อื่น ๆ

**เป้าหมายคือทำให้เทคนิคคณิตศาสตร์ขั้นสูงเข้าถึงได้ นำกลับมาใช้ซ้ำได้ และเหมาะกับการทดลองภายใน Roblox**

## เริ่มต้นอย่างรวดเร็ว

### การติดตั้ง

**ติดตั้งด้วยตนเอง**

1. เปิด Roblox Studio
2. ไปที่ ReplicatedStorage
3. สร้างโฟลเดอร์ชื่อ VectorForge
4. คัดลอก ModuleScript จาก src/VectorForge/ ไปยังโฟลเดอร์นั้น
5. คงชื่อ ModuleScript เดิมไว้

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

VectorForge มีการตั้งค่าโปรเจกต์ Rojo ให้ตรวจสอบว่า default.project.json แมป src/VectorForge ไปยัง ReplicatedStorage/VectorForge จากนั้นเรียกใช้คำสั่ง:

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

### การใช้งานพื้นฐาน

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
```

## โมดูลหลัก

ส่วนหลักของ VectorForge ประกอบด้วยโมดูลคณิตศาสตร์ 8 โมดูลในปัจจุบัน

| Module | Domain | Main focus |
|---|---|---|
| `LieGroupKinematics` | ทฤษฎี Lie group | การหมุนและการแปลงวัตถุแข็งเกร็ง |
| `SpectralLinearAlgebra` | พีชคณิตเชิงเส้น | การดำเนินการเมทริกซ์และ numerical solver |
| `BayesianStateEstimation` | ความน่าจะเป็น | การประมาณสถานะและความไม่แน่นอน |
| `DifferentialPathGeometry` | เรขาคณิตเชิงอนุพันธ์ | เส้นโค้ง ความโค้ง และการวิเคราะห์เส้นทาง |
| `AutomaticDifferentiation` | แคลคูลัสเชิงตัวเลข | การส่งผ่านอนุพันธ์ |
| `RigidBodyDynamics` | กลศาสตร์คลาสสิก | แรง แรงบิด และการเคลื่อนที่วัตถุแข็งเกร็ง |
| `NumericalOptimization` | การหาค่าเหมาะที่สุด | การหาค่าต่ำสุดเชิงตัวเลข |
| `TrajectoryPlanning` | การวางแผนวิถี | การสร้างและประเมินวิถี |

## ส่วนขยายทางวิทยาศาสตร์

ที่เก็บนี้ยังมีชั้นส่วนขยายด้านการวิจัยทางวิทยาศาสตร์เชิงทดลอง ซึ่งแยกจากไลบรารีหลักเดิม โฟลเดอร์เหล่านี้อยู่ที่รากของที่เก็บ ไม่ได้อยู่ภายใน src/VectorForge/

แพ็กเกจส่วนขยายประกอบด้วยโฟลเดอร์สาขาวิทยาศาสตร์ 15 โฟลเดอร์ โมดูลเฉพาะสาขา 300 โมดูล ไฟล์สนับสนุนเฉพาะสาขา 30 ไฟล์ ยูทิลิตีส่วนกลาง 5 ไฟล์ ตัวอย่างการจำลองที่ตั้งชื่อเฉพาะ 10 ไฟล์ และสคริปต์ตรวจสอบค่าคงตัวเชิงตัวเลข 10 ไฟล์ รวมทั้งหมด 355 ไฟล์ Lua

| Folder | Research area |
|---|---|
| `fluid-dynamics/` | **พลศาสตร์ของไหล** — แบบจำลองการไหล สมการโมเมนตัม การขนส่ง และพื้นฐาน solver ของไหล |
| `control-systems/` | **ระบบควบคุม** — แบบจำลอง state-space การควบคุมป้อนกลับ ตัวสังเกตการณ์ และการวิเคราะห์เสถียรภาพ |
| `finite-element-methods/` | **วิธีไฟไนต์เอลิเมนต์** — สูตรของเอลิเมนต์ ข้อมูลวัสดุ การอินทิเกรตแบบเกาส์ และการประกอบเมทริกซ์ |
| `signal-processing/` | **การประมวลผลสัญญาณ** — การแปลงแบบไม่ต่อเนื่อง การกรอง คอนโวลูชัน และทฤษฎีการสุ่มตัวอย่าง |
| `tensor-calculus/` | **แคลคูลัสเทนเซอร์** — การจัดเก็บเทนเซอร์ การหดดัชนี เมตริก และการดำเนินการเชิงอนุพันธ์ |
| `differential-equations/` | **สมการเชิงอนุพันธ์** — การอินทิเกรตปัญหาค่าเริ่มต้น ปัญหาค่าขอบเขต และการก้าวเวลาเชิงตัวเลข |
| `computational-geometry/` | **เรขาคณิตเชิงคำนวณ** — เส้นโค้งพาราเมตริก ความโค้ง การทดสอบเรขาคณิต และแนวคิด mesh |
| `optimization-methods/` | **วิธีการหาค่าเหมาะที่สุด** — วิธี gradient การค้นหาเส้นทาง least squares และเกณฑ์หยุด |
| `quantum-mechanics/` | **กลศาสตร์ควอนตัม** — การแทน wavefunction ความหนาแน่นความน่าจะเป็น และพื้นฐานแบบจำลองควอนตัม |
| `thermodynamics/` | **อุณหพลศาสตร์** — สมการสถานะ คุณสมบัติความร้อน พลังงาน และการแปลงหน่วย |
| `electromagnetics/` | **แม่เหล็กไฟฟ้า** — สนามแม่เหล็กไฟฟ้า แรงลอเรนซ์ ค่าคงที่ และการสุ่มตัวอย่างสนาม |
| `orbital-mechanics/` | **กลศาสตร์วงโคจร** — การเคลื่อนที่สองวัตถุ องค์ประกอบวงโคจร และค่าคงที่ดาราศาสตร์ |
| `rigid-body-physics/` | **ฟิสิกส์วัตถุแข็งเกร็ง** — ความเฉื่อย โมเมนตัมเชิงมุม การตั้งค่าการสัมผัส และพลศาสตร์การหมุน |
| `continuum-mechanics/` | **กลศาสตร์ต่อเนื่อง** — มาตรวัดความเครียด ข้อมูลวัสดุยืดหยุ่น และพื้นฐานแบบจำลอง constitutive |
| `stochastic-processes/` | **กระบวนการสุ่ม** — กระบวนการสุ่ม การก้าวเวลาแบบสุ่ม และการแจกแจงความน่าจะเป็น |

### โครงสร้างโฟลเดอร์

```text
domain-folder/
├── analysis/
├── models/
├── solvers/
├── DomainSupportOne.lua
└── DomainSupportTwo.lua
```

### ยูทิลิตีส่วนกลาง

| Module | Responsibility |
|---|---|
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping and safe division |
| `SimulationClock.lua` | Fixed-step simulation timing |
| `EquationCatalog.lua` | A compact catalog of governing equations |

### การเชื่อมต่อกับโมดูลหลัก

โมดูลส่วนขยายแยกจาก src/VectorForge/ โดย shared/CoreRegistry.lua มีกลไก dependency injection เพื่อให้สคริปต์เริ่มต้นลงทะเบียนโมดูลหลักที่มีอยู่จริงและตรวจสอบ public API แล้ว Registry จะไม่เดาเส้นทางหรือโหลดโมดูลโดยอัตโนมัติ

```lua
local CoreRegistry = require(path.to.shared.CoreRegistry)
CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
})
local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

### ตัวอย่างและการตรวจสอบ

โฟลเดอร์ examples/ มีสคริปต์ศึกษาที่ตั้งชื่อแยกกัน เช่น การตอบสนองของออสซิลเลเตอร์ที่มีแรงหน่วง วิวัฒนาการของสถานะที่เชื่อมโยง การตอบสนองไม่เชิงเส้น การลดลงของพลังงาน เสถียรภาพเชิงตัวเลข และการจำลองสถานะระยะยาว การตรวจสอบใน tests/ เป็นจุดเริ่มต้นของ regression test แต่ไม่สามารถแทนคำตอบเชิงวิเคราะห์ การตรวจสอบมิติ การศึกษาการลู่เข้า หรือข้อมูลวิทยาศาสตร์อ้างอิงที่เชื่อถือได้

### สถานะการวิจัยและการใช้งานจริง

ส่วนขยายทางวิทยาศาสตร์เป็นโครงสร้างพื้นฐานสำหรับการวิจัยเชิงทดลอง บางโมดูลมีขั้นตอนเชิงตัวเลขที่นำกลับมาใช้ซ้ำได้ ส่วนโมดูลอื่นยังต้องกำหนด discretization เงื่อนไขขอบเขต กฎวัสดุ หน่วย และกลยุทธ์ solver ให้ตรงกับปัญหา ก่อนใช้งานจริงควรตรวจสอบอินพุต เอาต์พุต หน่วย สมมติฐาน เงื่อนไขขอบเขต การลู่เข้า เสถียรภาพเชิงตัวเลข และต้นทุนการทำงาน

ข้อสำคัญ: ส่วนขยายเหล่านี้เป็นโครงสร้างสำหรับการวิจัยเชิงทดลอง ไม่ได้หมายความว่าแบบจำลองทางฟิสิกส์ทุกแบบผ่านการตรวจสอบเชิงทดลองแล้ว ก่อนใช้งานจริงต้องตรวจสอบหน่วย เงื่อนไขขอบเขต สมมติฐานวัสดุ เสถียรภาพ และการลู่เข้ากับคำตอบอ้างอิงที่เชื่อถือได้

## VectorForge ทำงานอย่างไร

ผู้พัฒนากำหนดปัญหาหรือแบบจำลองทางคณิตศาสตร์ เลือกโมดูลที่เหมาะสม ป้อนข้อมูล และนำผลลัพธ์ไปใช้ในระบบ Roblox ของตนเอง โมดูลทั้งหมดไม่ได้เชื่อมต่อกันโดยอัตโนมัติเป็น pipeline เดียวที่ตายตัว

## การทดลอง · การจำลอง · ชุดข้อมูล · การแสดงผล · การทดสอบประสิทธิภาพ

## พื้นฐานทางคณิตศาสตร์ · บันทึกการวิจัย · การทดสอบ · ข้อควรพิจารณาด้านประสิทธิภาพ

## โครงสร้างที่เก็บ

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

## คำถามที่พบบ่อย

**ข้อสำคัญ: ส่วนขยายเหล่านี้เป็นโครงสร้างสำหรับการวิจัยเชิงทดลอง ไม่ได้หมายความว่าแบบจำลองทางฟิสิกส์ทุกแบบผ่านการตรวจสอบเชิงทดลองแล้ว ก่อนใช้งานจริงต้องตรวจสอบหน่วย เงื่อนไขขอบเขต สมมติฐานวัสดุ เสถียรภาพ และการลู่เข้ากับคำตอบอ้างอิงที่เชื่อถือได้**

## เอกสาร

- [API Reference](../../docs/API.md)
- [Architecture](../../docs/ARCHITECTURE.md)
- [Mathematics](../../docs/MATHEMATICS.md)
- [Numerical Validation](../../docs/NUMERICAL_VALIDATION.md)

## การมีส่วนร่วม

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## สถานะการพัฒนา

ข้อสำคัญ: ส่วนขยายเหล่านี้เป็นโครงสร้างสำหรับการวิจัยเชิงทดลอง ไม่ได้หมายความว่าแบบจำลองทางฟิสิกส์ทุกแบบผ่านการตรวจสอบเชิงทดลองแล้ว ก่อนใช้งานจริงต้องตรวจสอบหน่วย เงื่อนไขขอบเขต สมมติฐานวัสดุ เสถียรภาพ และการลู่เข้ากับคำตอบอ้างอิงที่เชื่อถือได้

## ใบอนุญาต

MIT License — see [LICENSE](../../LICENSE).

**VectorForge**

