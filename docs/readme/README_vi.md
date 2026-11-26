<div align="center">

# VectorForge

### Toán học tính toán nâng cao cho Roblox Luau

**Khám phá phương pháp số, tính toán hình học và hệ thống toán học ngay trong Roblox**

[English](../../README.md) · [简体中文](README_zh.md) · [日本語](README_ja.md) · [한국어](README_ko.md) · **Tiếng Việt** · [ไทย](README_th.md) · [العربية](README_ar.md)

[![Language](https://img.shields.io/badge/Language-Luau-blue?style=flat-square)](https://luau.org/)
[![Platform](https://img.shields.io/badge/Platform-Roblox-00A2FF?style=flat-square&logo=roblox&logoColor=white)](https://www.roblox.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](../../LICENSE)
[![Status](https://img.shields.io/badge/Status-Experimental-orange?style=flat-square)](../../README.md#project-status)

**[Quick Start](../../README.md#quick-start) · [Core Modules](../../README.md#core-modules) · [Scientific Extensions](../../README.md#scientific-extensions) · [Examples](../../README.md#examples) · [Experiments](../../README.md#experiments) · [Simulations](../../README.md#simulations) · [Datasets](../../README.md#datasets) · [Visualizations](../../README.md#visualizations) · [Documentation](../../README.md#documentation)**

</div>

---

## VectorForge là thư viện Luau mang tính thử nghiệm, nghiên cứu cách triển khai toán học tính toán nâng cao trong môi trường Roblox. Dự án bao gồm động học nhóm Lie, đại số tuyến tính số, ước lượng trạng thái Bayes, hình học vi phân và nhiều lĩnh vực tính toán khoa học khác.

**Mục tiêu là giúp các kỹ thuật toán học nâng cao dễ tiếp cận, có thể tái sử dụng và thuận tiện cho việc thử nghiệm trong Roblox.**

## Bắt đầu nhanh

### Cài đặt

**Cài đặt thủ công**

1. Mở Roblox Studio
2. Đi tới ReplicatedStorage
3. Tạo thư mục có tên VectorForge
4. Sao chép các ModuleScript từ src/VectorForge/ vào thư mục đó
5. Giữ nguyên tên ModuleScript ban đầu

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

VectorForge có cấu hình dự án Rojo. Hãy bảo đảm default.project.json ánh xạ src/VectorForge tới ReplicatedStorage/VectorForge, sau đó chạy:

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

### Cách sử dụng cơ bản

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
```

## Các mô-đun lõi

Phần lõi của VectorForge hiện gồm tám mô-đun toán học.

| Module | Domain | Main focus |
|---|---|---|
| `LieGroupKinematics` | Lý thuyết nhóm Lie | Phép quay và biến đổi vật rắn |
| `SpectralLinearAlgebra` | Đại số tuyến tính | Phép toán ma trận và bộ giải số |
| `BayesianStateEstimation` | Xác suất | Ước lượng trạng thái và độ bất định |
| `DifferentialPathGeometry` | Hình học vi phân | Đường cong, độ cong và phân tích đường đi |
| `AutomaticDifferentiation` | Giải tích số | Lan truyền đạo hàm |
| `RigidBodyDynamics` | Cơ học cổ điển | Lực, mô-men và chuyển động vật rắn |
| `NumericalOptimization` | Tối ưu hóa | Tối thiểu hóa số |
| `TrajectoryPlanning` | Lập kế hoạch quỹ đạo | Xây dựng và đánh giá quỹ đạo |

## Các phần mở rộng khoa học

Kho mã nguồn cũng có một lớp mở rộng nghiên cứu khoa học mang tính thử nghiệm, tách biệt với thư viện lõi ban đầu. Các thư mục này nằm ở thư mục gốc của kho, không nằm trong src/VectorForge/.

Gói mở rộng hiện có 15 thư mục lĩnh vực khoa học, 300 mô-đun theo lĩnh vực, 30 mô-đun hỗ trợ theo lĩnh vực, 5 tiện ích dùng chung, 10 ví dụ mô phỏng có tên riêng và 10 tập lệnh kiểm tra bất biến số học — tổng cộng 355 tệp Lua.

| Folder | Research area |
|---|---|
| `fluid-dynamics/` | **Động lực học chất lưu** — Mô hình dòng chảy, phương trình động lượng, vận chuyển và nền tảng bộ giải chất lưu |
| `control-systems/` | **Hệ thống điều khiển** — Mô hình không gian trạng thái, điều khiển phản hồi, bộ quan sát và phân tích ổn định |
| `finite-element-methods/` | **Phương pháp phần tử hữu hạn** — Công thức phần tử, dữ liệu vật liệu, tích phân Gauss và lắp ráp |
| `signal-processing/` | **Xử lý tín hiệu** — Biến đổi rời rạc, lọc, tích chập và lý thuyết lấy mẫu |
| `tensor-calculus/` | **Giải tích tensor** — Lưu trữ tensor, phép co, metric và phép vi phân |
| `differential-equations/` | **Phương trình vi phân** — Tích phân bài toán giá trị đầu, bài toán biên và bước thời gian số |
| `computational-geometry/` | **Hình học tính toán** — Đường cong tham số, độ cong, phép kiểm tra hình học và lưới |
| `optimization-methods/` | **Phương pháp tối ưu hóa** — Phương pháp gradient, tìm kiếm đường, bình phương tối thiểu và tiêu chí dừng |
| `quantum-mechanics/` | **Cơ học lượng tử** — Biểu diễn hàm sóng, mật độ xác suất và nền tảng mô hình lượng tử |
| `thermodynamics/` | **Nhiệt động lực học** — Phương trình trạng thái, tính chất nhiệt, năng lượng và chuyển đổi đơn vị |
| `electromagnetics/` | **Điện từ học** — Trường điện từ, lực Lorentz, hằng số và lấy mẫu trường |
| `orbital-mechanics/` | **Cơ học quỹ đạo** — Chuyển động hai vật thể, phần tử quỹ đạo và hằng số thiên văn |
| `rigid-body-physics/` | **Vật lý vật rắn** — Quán tính, mô-men động lượng, thiết lập tiếp xúc và động lực học quay |
| `continuum-mechanics/` | **Cơ học môi trường liên tục** — Đại lượng biến dạng, dữ liệu vật liệu đàn hồi và nền tảng mô hình cấu thành |
| `stochastic-processes/` | **Quá trình ngẫu nhiên** — Quá trình ngẫu nhiên, bước tích phân ngẫu nhiên và phân phối xác suất |

### Cấu trúc thư mục

```text
domain-folder/
├── analysis/
├── models/
├── solvers/
├── DomainSupportOne.lua
└── DomainSupportTwo.lua
```

### Tiện ích dùng chung

| Module | Responsibility |
|---|---|
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping and safe division |
| `SimulationClock.lua` | Fixed-step simulation timing |
| `EquationCatalog.lua` | A compact catalog of governing equations |

### Tích hợp với các mô-đun lõi

Các mô-đun mở rộng được giữ riêng khỏi src/VectorForge/. shared/CoreRegistry.lua cung cấp cơ chế tiêm phụ thuộc để tập lệnh khởi tạo đăng ký những mô-đun lõi thực sự tồn tại và có API công khai đã được kiểm tra. Registry không tự đoán đường dẫn hoặc tự động tải mô-đun.

```lua
local CoreRegistry = require(path.to.shared.CoreRegistry)
CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
})
local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

### Ví dụ và kiểm chứng

Thư mục examples/ chứa các nghiên cứu độc lập có tên riêng như đáp ứng dao động tắt dần, tiến hóa trạng thái ghép, đáp ứng phi tuyến, suy giảm năng lượng, độ ổn định số và mô phỏng trạng thái dài hạn. Các kiểm tra trong tests/ là điểm khởi đầu cho kiểm thử hồi quy, không thay thế nghiệm giải tích, kiểm tra thứ nguyên, nghiên cứu hội tụ hoặc dữ liệu khoa học đáng tin cậy.

### Trạng thái nghiên cứu và sản xuất

Các phần mở rộng khoa học là nền tảng nghiên cứu thử nghiệm. Một số mô-đun cung cấp thủ tục số có thể tái sử dụng; các mô-đun khác vẫn cần rời rạc hóa, điều kiện biên, định luật vật liệu, đơn vị và chiến lược bộ giải phù hợp với bài toán cụ thể. Trước khi dùng trong sản phẩm, hãy kiểm tra đầu vào, đầu ra, đơn vị, giả định, điều kiện biên, hội tụ, ổn định số và chi phí thực thi.

Lưu ý: Các phần mở rộng này là nền tảng nghiên cứu thử nghiệm, không có nghĩa mọi mô hình vật lý đã được xác thực bằng thực nghiệm. Trước khi sử dụng trong sản phẩm, cần kiểm chứng đơn vị, điều kiện biên, giả định vật liệu, độ ổn định và hội tụ bằng nghiệm tham chiếu đáng tin cậy.

## VectorForge hoạt động như thế nào

Nhà phát triển xác định bài toán hoặc mô hình toán học, chọn mô-đun phù hợp, cung cấp dữ liệu đầu vào và sử dụng kết quả trả về trong hệ thống Roblox của riêng mình. Các mô-đun không tự động kết nối thành một quy trình cố định duy nhất.

## Thí nghiệm · Mô phỏng · Bộ dữ liệu · Trực quan hóa · Đánh giá hiệu năng

## Nền tảng toán học · Ghi chú nghiên cứu · Kiểm thử · Lưu ý hiệu năng

## Cấu trúc kho mã nguồn

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

## Câu hỏi thường gặp

**Lưu ý: Các phần mở rộng này là nền tảng nghiên cứu thử nghiệm, không có nghĩa mọi mô hình vật lý đã được xác thực bằng thực nghiệm. Trước khi sử dụng trong sản phẩm, cần kiểm chứng đơn vị, điều kiện biên, giả định vật liệu, độ ổn định và hội tụ bằng nghiệm tham chiếu đáng tin cậy.**

## Tài liệu

- [API Reference](../../docs/API.md)
- [Architecture](../../docs/ARCHITECTURE.md)
- [Mathematics](../../docs/MATHEMATICS.md)
- [Numerical Validation](../../docs/NUMERICAL_VALIDATION.md)

## Đóng góp

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## Trạng thái phát triển

Lưu ý: Các phần mở rộng này là nền tảng nghiên cứu thử nghiệm, không có nghĩa mọi mô hình vật lý đã được xác thực bằng thực nghiệm. Trước khi sử dụng trong sản phẩm, cần kiểm chứng đơn vị, điều kiện biên, giả định vật liệu, độ ổn định và hội tụ bằng nghiệm tham chiếu đáng tin cậy.

## Giấy phép

MIT License — see [LICENSE](../../LICENSE).

**VectorForge**

