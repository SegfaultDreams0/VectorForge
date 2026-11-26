<div dir="rtl">


# VectorForge
### الرياضيات الحاسوبية المتقدمة لـ Roblox Luau
**استكشف الطرق العددية والحسابات الهندسية والأنظمة الرياضية داخل Roblox**

[English](../../README.md) · [简体中文](README_zh.md) · [日本語](README_ja.md) · [한국어](README_ko.md) · [Tiếng Việt](README_vi.md) · [ไทย](README_th.md)

---

## VectorForge مكتبة Luau تجريبية تستكشف تطبيق الرياضيات الحاسوبية المتقدمة داخل بيئة Roblox. تشمل موضوعاتها حركيات زمر لي والجبر الخطي العددي وتقدير الحالة البايزي والهندسة التفاضلية، إضافة إلى مجالات أوسع من الحوسبة العلمية.

**يهدف المشروع إلى جعل التقنيات الرياضية المتقدمة سهلة الوصول وقابلة لإعادة الاستخدام ومفتوحة للتجربة داخل Roblox.**

## البدء السريع

### التثبيت

**التثبيت اليدوي**

1. افتح Roblox Studio
2. انتقل إلى ReplicatedStorage
3. أنشئ مجلداً باسم VectorForge
4. انسخ ملفات ModuleScript من src/VectorForge/ إلى ذلك المجلد
5. احتفظ بأسماء ModuleScript الأصلية

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

يتضمن VectorForge إعداداً لمشروع Rojo. تأكد من أن default.project.json يربط src/VectorForge مع ReplicatedStorage/VectorForge، ثم نفّذ:

```bash
rojo build default.project.json -o VectorForge.rbxlx
```

### الاستخدام الأساسي

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LinearAlgebra = require(VectorForge.SpectralLinearAlgebra)
local StateEstimation = require(VectorForge.BayesianStateEstimation)
```

## الوحدات الأساسية

يتكون الجزء الأساسي من VectorForge حالياً من ثماني وحدات رياضية.

| Module | Domain | Main focus |
|---|---|---|
| `LieGroupKinematics` | نظرية زمر لي | الدوران والتحويلات الصلبة |
| `SpectralLinearAlgebra` | الجبر الخطي | عمليات المصفوفات والمحللات العددية |
| `BayesianStateEstimation` | الاحتمالات | تقدير الحالة وعدم اليقين |
| `DifferentialPathGeometry` | الهندسة التفاضلية | المنحنيات والانحناء وتحليل المسارات |
| `AutomaticDifferentiation` | التفاضل العددي | تمرير المشتقات |
| `RigidBodyDynamics` | الميكانيكا الكلاسيكية | القوى والعزوم وحركة الأجسام الصلبة |
| `NumericalOptimization` | التحسين | التصغير العددي |
| `TrajectoryPlanning` | تخطيط المسارات | إنشاء المسارات وتقييمها |

## الإضافات العلمية

يحتوي المستودع أيضاً على طبقة إضافات بحثية علمية تجريبية منفصلة عن المكتبة الأساسية الأصلية. توجد هذه المجلدات في جذر المستودع، وليس داخل src/VectorForge/.

تتضمن حزمة الإضافات 15 مجلداً للمجالات العلمية و300 وحدة متخصصة و30 ملف دعم للمجالات و5 أدوات مشتركة و10 أمثلة محاكاة بأسماء مستقلة و10 ملفات لفحص الثوابت العددية، أي ما مجموعه 355 ملف Lua.

| Folder | Research area |
|---|---|
| `fluid-dynamics/` | **ديناميكا الموائع** — نماذج التدفق ومعادلات الزخم والنقل وأساسيات محللات الموائع |
| `control-systems/` | **أنظمة التحكم** — نماذج فضاء الحالة والتحكم الراجع والمراقبات وتحليل الاستقرار |
| `finite-element-methods/` | **طريقة العناصر المحددة** — صياغة العناصر وبيانات المواد والتكامل الغاوسي والتجميع |
| `signal-processing/` | **معالجة الإشارات** — التحويلات المتقطعة والترشيح والالتفاف ونظرية أخذ العينات |
| `tensor-calculus/` | **حساب الموترات** — تخزين الموترات والانكماش والموتر المتري والعمليات التفاضلية |
| `differential-equations/` | **المعادلات التفاضلية** — تكامل مسائل القيم الابتدائية ومسائل القيم الحدية والخطوات العددية |
| `computational-geometry/` | **الهندسة الحاسوبية** — المنحنيات البارامترية والانحناء والاختبارات الهندسية ومفاهيم الشبكات |
| `optimization-methods/` | **طرق التحسين** — طرق التدرج والبحث الخطي والمربعات الصغرى ومعايير التوقف |
| `quantum-mechanics/` | **ميكانيكا الكم** — تمثيل الدالة الموجية وكثافة الاحتمال وأساسيات النماذج الكمومية |
| `thermodynamics/` | **الديناميكا الحرارية** — معادلات الحالة والخصائص الحرارية والطاقة وتحويل الوحدات |
| `electromagnetics/` | **الكهرومغناطيسية** — الحقول الكهرومغناطيسية وقوة لورنتز والثوابت وأخذ عينات الحقول |
| `orbital-mechanics/` | **ميكانيكا المدارات** — حركة الجسمين والعناصر المدارية وثوابت الميكانيكا الفلكية |
| `rigid-body-physics/` | **فيزياء الأجسام الصلبة** — العطالة والزخم الزاوي وإعدادات التلامس والديناميكا الدورانية |
| `continuum-mechanics/` | **ميكانيكا الأوساط المتصلة** — مقاييس الانفعال وبيانات المواد المرنة وأساسيات النماذج التكوينية |
| `stochastic-processes/` | **العمليات العشوائية** — العمليات العشوائية والخطوات العشوائية والتوزيعات الاحتمالية |

### بنية المجلدات

```text
domain-folder/
├── analysis/
├── models/
├── solvers/
├── DomainSupportOne.lua
└── DomainSupportTwo.lua
```

### الأدوات المشتركة

| Module | Responsibility |
|---|---|
| `CoreRegistry.lua` | Explicit registration and lookup of existing VectorForge Core Modules |
| `LinearAlgebra.lua` | Basic row-array matrix operations |
| `NumericalGuards.lua` | Finite-value checks, clamping and safe division |
| `SimulationClock.lua` | Fixed-step simulation timing |
| `EquationCatalog.lua` | A compact catalog of governing equations |

### التكامل مع الوحدات الأساسية

تبقى وحدات الإضافات منفصلة عن src/VectorForge/. يوفر shared/CoreRegistry.lua آلية لحقن الاعتماديات تسمح لملف التهيئة بتسجيل الوحدات الأساسية الموجودة فعلياً والتي تم التحقق من واجهاتها العامة. لا يخمّن السجل المسارات ولا يحمّل الوحدات تلقائياً.

```lua
local CoreRegistry = require(path.to.shared.CoreRegistry)
CoreRegistry.Configure({
    SpectralLinearAlgebra = require(path.to.src.VectorForge.SpectralLinearAlgebra),
    AutomaticDifferentiation = require(path.to.src.VectorForge.AutomaticDifferentiation),
})
local LinearAlgebraCore = CoreRegistry.Require("SpectralLinearAlgebra")
```

### الأمثلة والتحقق

يحتوي مجلد examples/ على دراسات مستقلة بأسماء واضحة، مثل استجابة المذبذب المخمّد وتطور الحالات المترابطة والاستجابة غير الخطية واضمحلال الطاقة والاستقرار العددي ومحاكاة الحالة طويلة الأمد. تمثل الفحوص الموجودة في tests/ نقطة بداية لاختبارات الانحدار، لكنها لا تغني عن الحلول التحليلية أو فحص الأبعاد أو دراسات التقارب أو المقارنة مع بيانات علمية موثوقة.

### حالة البحث والاستخدام الإنتاجي

الإضافات العلمية هي بنية بحثية تجريبية. توفر بعض الوحدات إجراءات عددية قابلة لإعادة الاستخدام، بينما تحتاج وحدات أخرى إلى تخصيص التقسيم العددي والشروط الحدية وقوانين المواد والوحدات واستراتيجية الحل وفقاً للمسألة. قبل الاستخدام الإنتاجي، تحقق من المدخلات والمخرجات والوحدات والافتراضات والشروط الحدية والتقارب والاستقرار العددي وتكلفة التنفيذ.

ملاحظة مهمة: هذه الإضافات هي أساس بحثي تجريبي، ولا يعني ذلك أن كل نموذج فيزيائي قد تم التحقق منه تجريبياً. قبل الاستخدام الإنتاجي، يجب التحقق من الوحدات والشروط الحدية وافتراضات المواد والاستقرار والتقارب بمقارنتها بحلول مرجعية موثوقة.

## كيف يعمل VectorForge

يحدد المطور مسألة أو نموذجاً رياضياً، ويختار الوحدة المناسبة، ويمرر المدخلات، ثم يستخدم النتائج في نظام Roblox الخاص به. لا تتصل جميع الوحدات تلقائياً لتشكّل مسار معالجة واحداً وثابتاً.

## التجارب · المحاكاة · مجموعات البيانات · التصورات · اختبارات الأداء

## الأسس الرياضية · ملاحظات البحث · الاختبارات · اعتبارات الأداء

## بنية المستودع

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

## الأسئلة الشائعة

**ملاحظة مهمة: هذه الإضافات هي أساس بحثي تجريبي، ولا يعني ذلك أن كل نموذج فيزيائي قد تم التحقق منه تجريبياً. قبل الاستخدام الإنتاجي، يجب التحقق من الوحدات والشروط الحدية وافتراضات المواد والاستقرار والتقارب بمقارنتها بحلول مرجعية موثوقة.**

## التوثيق

- [API Reference](../../docs/API.md)
- [Architecture](../../docs/ARCHITECTURE.md)
- [Mathematics](../../docs/MATHEMATICS.md)
- [Numerical Validation](../../docs/NUMERICAL_VALIDATION.md)

## المساهمة

See [CONTRIBUTING.md](../../CONTRIBUTING.md).

## حالة التطوير

ملاحظة مهمة: هذه الإضافات هي أساس بحثي تجريبي، ولا يعني ذلك أن كل نموذج فيزيائي قد تم التحقق منه تجريبياً. قبل الاستخدام الإنتاجي، يجب التحقق من الوحدات والشروط الحدية وافتراضات المواد والاستقرار والتقارب بمقارنتها بحلول مرجعية موثوقة.

## الترخيص

MIT License — see [LICENSE](../../LICENSE).

**VectorForge**



</div>
