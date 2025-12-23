# نظام إصدار الخطابات الرسمية للشركات

## 🆕 إصلاح زر "ليس لديك حساب" في صفحة تسجيل الدخول (Dec 23, 2025)

### المشكلة:
- زر "سجل الآن" في صفحة تسجيل الدخول لا يعمل
- عند الضغط عليه يتم إعادة التوجيه مباشرة إلى صفحة تسجيل الدخول
- السبب: Router redirect logic كان يمنع المستخدمين غير المسجلين من الوصول إلى صفحة التسجيل

### الحل المطبق:
- [x] تحديث `app_router.dart` لإضافة `isRegistering` check
- [x] السماح للمستخدمين غير المسجلين بالوصول إلى `/register`
- [x] تحديث شروط redirect لاستثناء صفحة التسجيل

### الملفات المعدلة:
- `mobile_app/lib/core/router/app_router.dart` - تحديث redirect logic

---

## 🆕 إصلاح خطأ تفاصيل المستخدم في صفحة الويب (Dec 22, 2025)

### المشكلة:
- خطأ "حدث خطأ في تحميل البيانات" عند النقر على زر عرض تفاصيل المستخدم
- السبب: صفحة الويب تستدعي `/api/users/{id}` التي تتطلب Sanctum token، بينما الويب يستخدم session authentication

### الحل المطبق:
- [x] إضافة web routes لإدارة المستخدمين في AdminController
  - `GET /admin/users/{id}/details` - عرض تفاصيل المستخدم
  - `PUT /admin/users/{id}` - تحديث المستخدم
  - `DELETE /admin/users/{id}` - حذف المستخدم
- [x] تحديث JavaScript في users.blade.php لاستخدام web routes بدلاً من API routes
- [x] إضافة methods في AdminController: `getUserDetails()`, `updateUser()`, `deleteUser()`

### الملفات المعدلة:
- `app/Http/Controllers/AdminController.php` - إضافة 3 methods جديدة
- `routes/web.php` - إضافة 3 web routes جديدة
- `resources/views/admin/users.blade.php` - تحديث JavaScript functions

---

## 🆕 إضافة ميزة إدارة المستخدمين للـ Super Admin في تطبيق الموبايل (Dec 22, 2025)

### المهام المطلوبة:
- [x] إنشاء API endpoints لإدارة المستخدمين (عرض، تعديل، حذف، سجل النشاطات)
- [x] إنشاء هيكل users feature في تطبيق الموبايل (data, domain, presentation)
- [x] إنشاء صفحة إدارة المستخدمين مع البحث والفلترة
- [x] إنشاء صفحة تفاصيل المستخدم مع سجل النشاطات
- [x] إنشاء صفحة تعديل المستخدم
- [x] إضافة خيار إدارة المستخدمين في القائمة الجانبية للـ Super Admin
- [x] تحديث User entity لإضافة is_super_admin و is_company_owner
- [x] commit و push التغييرات

### الميزات المضافة:
1. **API Endpoints** (Laravel):
   - `GET /api/users` - عرض جميع المستخدمين مع البحث والفلترة
   - `GET /api/users/{id}` - عرض تفاصيل مستخدم
   - `PUT /api/users/{id}` - تعديل مستخدم
   - `DELETE /api/users/{id}` - حذف مستخدم
   - `GET /api/users/{id}/activity-log` - سجل نشاطات المستخدم
   - `GET /api/users/companies` - قائمة الشركات للفلترة
   - `PUT /api/users/{id}/status` - تحديث حالة المستخدم

2. **Mobile App Features** (Flutter):
   - صفحة إدارة المستخدمين مع:
     - بحث بالاسم أو البريد الإلكتروني
     - فلترة حسب الشركة والحالة
     - عرض بطاقات المستخدمين مع المعلومات الأساسية
     - قائمة خيارات (عرض، تعديل، سجل النشاطات، حذف)
   - صفحة تفاصيل المستخدم مع:
     - عرض المعلومات الشخصية والشركة
     - سجل النشاطات (الخطابات المصدرة)
     - تصميم جميل مع animations
   - صفحة تعديل المستخدم مع:
     - تعديل جميع البيانات (الاسم، البريد، الهاتف، الوظيفة)
     - تغيير الدور والحالة
     - تحديد مالك الشركة
     - تغيير كلمة المرور (اختياري)

3. **Security & Permissions**:
   - جميع endpoints محمية بـ Super Admin check
   - لا يمكن حذف Super Admin
   - لا يمكن حذف نفسك
   - القائمة تظهر فقط للـ Super Admin في تطبيق الموبايل

### الملفات المنشأة/المعدلة:

**Backend (Laravel):**
- `app/Http/Controllers/Api/UserApiController.php` - ✅ جديد
- `routes/api.php` - إضافة مسارات إدارة المستخدمين

**Mobile App (Flutter):**
- `lib/features/users/domain/entities/user.dart` - ✅ جديد
- `lib/features/users/domain/entities/user_activity.dart` - ✅ جديد
- `lib/features/users/domain/repositories/users_repository.dart` - ✅ جديد
- `lib/features/users/data/models/user_model.dart` - ✅ جديد
- `lib/features/users/data/models/user_activity_model.dart` - ✅ جديد
- `lib/features/users/data/datasources/users_remote_datasource.dart` - ✅ جديد
- `lib/features/users/data/repositories/users_repository_impl.dart` - ✅ جديد
- `lib/features/users/presentation/bloc/users_bloc.dart` - ✅ جديد
- `lib/features/users/presentation/bloc/users_event.dart` - ✅ جديد
- `lib/features/users/presentation/bloc/users_state.dart` - ✅ جديد
- `lib/features/users/presentation/pages/users_page.dart` - ✅ جديد
- `lib/features/users/presentation/pages/user_details_page.dart` - ✅ جديد
- `lib/features/users/presentation/pages/user_edit_page.dart` - ✅ جديد
- `lib/core/router/app_router.dart` - إضافة مسار /users
- `lib/features/main/presentation/pages/main_page.dart` - إضافة خيار إدارة المستخدمين للـ Super Admin
- `lib/features/auth/domain/entities/user.dart` - إضافة is_super_admin و is_company_owner
- `lib/features/auth/data/models/user_model.dart` - تحديث لدعم الحقول الجديدة

### الفرع: `feature/mobile-user-management`

---

## 🆕 إضافة ميزات Super Admin للنظام (Dec 22, 2025)

### المهام المطلوبة:
- [x] إضافة قائمة "إدارة النظام" في Sidebar للـ Super Admin
- [x] إنشاء صفحة عرض جميع الشركات المسجلة
- [x] إنشاء صفحة عرض جميع الخطابات من جميع الشركات
- [x] إنشاء صفحة عرض جميع المستخدمين
- [x] تحديث Middleware للتحقق من صلاحيات Super Admin

### الميزات المضافة:
1. **لوحة الأدمن**: `/admin/dashboard` - إحصائيات شاملة للنظام
2. **الشركات المسجلة**: `/admin/companies` - عرض وإدارة جميع الشركات
3. **جميع الخطابات**: `/admin/letters` - عرض خطابات جميع الشركات مع فلترة
4. **جميع المستخدمين**: `/admin/users` - عرض وإدارة جميع المستخدمين

### الملفات المعدلة/المنشأة:
- `resources/views/layouts/template.blade.php` - إضافة قسم "إدارة النظام" في القائمة
- `resources/views/admin/letters.blade.php` - ✅ جديد - صفحة جميع الخطابات
- `resources/views/admin/users.blade.php` - ✅ جديد - صفحة جميع المستخدمين
- `app/Http/Middleware/IsAdmin.php` - تحديث للتحقق من Super Admin

### ملاحظات:
- القائمة تظهر فقط للمستخدمين الذين لديهم `is_super_admin = true` أو البريد `admin@letters.sa`
- جميع الصفحات محمية بـ Middleware `is_admin`
- يمكن للـ Super Admin البحث والفلترة في جميع البيانات

---

## 🆕 إصلاح خطأ 419 PAGE EXPIRED في صفحة تسجيل الدخول (Dec 22, 2025)

### المشكلة:
- خطأ "419 | PAGE EXPIRED" عند محاولة تسجيل الدخول
- السبب: انتهاء صلاحية CSRF token

### الحل المطبق:
- [x] تنظيف الـ cache (cache:clear, config:clear, route:clear, view:clear)
- [x] التحقق من صلاحيات مجلد sessions
- [x] الحل: تحديث الصفحة في المتصفح (Cmd+Shift+R) لتحميل token جديد

### التعليمات للمستخدم:
1. افتح صفحة تسجيل الدخول في المتصفح
2. اضغط **Cmd+Shift+R** (Mac) أو **Ctrl+Shift+R** (Windows) لتحديث الصفحة بدون cache
3. جرب تسجيل الدخول مرة أخرى

---

## 🆕 تطبيق ميزة الورق الرسمي والباركود على الويب (Dec 22, 2025)

### المهام المطلوبة:
- [x] إنشاء فرع `feature/web-letterhead-barcode`
- [x] فحص التطبيق الحالي على الموبايل والويب
- [x] إنشاء Middleware للتحقق من الإعداد الأولي
- [x] تحديث Routes لاستخدام Middleware
- [x] تحسين صفحة الإعداد الأولي لتظهر عند أول تحميل
- [x] تحسين صفحة إعدادات الورق الرسمي
- [x] اختبار التطبيق
- [x] commit التغييرات ✅

### الميزات المطبقة:
1. **رفع الورق الرسمي**: سكان PDF أو صورة للورق الرسمي
2. **الباركود**: يحتوي على الرقم الصادر
3. **الترتيب**: باركود ← رقم صادر ← تاريخ هجري ← تاريخ ميلادي ← موضوع
4. **موقع**: يمين أو يسار الورقة
5. **الإعداد الأولي**: معالج 3 خطوات عند أول استخدام مع تصميم محسّن

### الملفات المعدلة:
- `app/Http/Middleware/CheckSetupCompleted.php` - ✅ جديد - middleware للتحقق من الإعداد
- `app/Http/Kernel.php` - إضافة middleware جديد
- `routes/web.php` - تحديث المسارات لاستخدام middleware
- `resources/views/company/setup.blade.php` - تحسين التصميم والـ UI
- `resources/views/company/letterhead-settings.blade.php` - تحسين التصميم والـ UI

### الميزات الموجودة مسبقاً (تم التحقق منها):
- ✅ قالب PDF مع الورق الرسمي كخلفية (`pdf-letterhead.blade.php`)
- ✅ إعدادات الباركود في قاعدة البيانات (migration موجود)
- ✅ Controller methods لحفظ الإعدادات (`CompanyController.php`)
- ✅ صفحة إعدادات الورق الرسمي (محسّنة الآن)

---

## 🆕 تحسين عرض الباركود في صفحة تفاصيل الخطاب (Dec 21, 2025)

### المهام المطلوبة:
- [x] إنشاء فرع `feature/barcode-display-enhancement`
- [x] تحديث صفحة تفاصيل الخطاب في الموبايل لعرض الباركود مع الرقم الصادر والتاريخ والموضوع
- [x] إضافة خيار تحديد موقع الباركود (يمين/يسار)
- [x] تحديث صفحة عرض الخطاب في الويب بنفس الميزة
- [x] إضافة Barcode Facade في Laravel config
- [x] التأكد من تحميل إعدادات الباركود عند أول تشغيل للتطبيق
- [x] اختبار وcommit التغييرات

### الملفات المعدلة:
- `mobile_app/lib/features/letters/presentation/pages/letter_details_page.dart` - إضافة قسم الباركود
- `mobile_app/lib/core/services/barcode_service.dart` - تحسين توليد الباركود
- `resources/views/letters/show.blade.php` - إضافة قسم الباركود في الويب
- `config/app.php` - إضافة Barcode Facades

### الترتيب المطلوب للعرض:
1. الباركود (يحتوي على الرقم الصادر)
2. الرقم الصادر
3. التاريخ الهجري
4. التاريخ الميلادي
5. الموضوع

### الإعدادات المتاحة:
- موقع الباركود: يمين أو يسار الورقة
- إظهار/إخفاء: الباركود، الرقم الصادر، التاريخ الهجري، التاريخ الميلادي، الموضوع

---

## 🆕 تحسينات تطبيق الموبايل (Dec 21, 2025)

### المهام المطلوبة:

- [x] تعديل تعريف البرنامج ليكون عام (منصة لإصدار الخطابات) - ليس فقط للشركات
- [x] إضافة ميزة تسجيل جديد من الموبايل
- [x] إضافة شاشة تعبئة بيانات المؤسسة عند أول تسجيل دخول
- [x] إعادة ترتيب القائمة: القوالب أولاً → إنشاء خطاب → تعديل خطابات سابقة
- [x] تغيير اسم القالب إلى "تحميل الورق الرسمي"
- [x] إضافة خيار "إنشاء قالب يدوي" تحت القوالب
- [x] إضافة ميزة الختم والتوقيع ضمن القوالب
- [x] إضافة ميزة تصدير PDF مباشرة للواتس أو الإيميل بعد إصدار الخطاب

### الملفات الجديدة/المعدلة:

- `lib/features/auth/presentation/pages/register_page.dart` - صفحة تسجيل جديد
- `lib/features/company/presentation/pages/organization_setup_page.dart` - صفحة إعداد المؤسسة
- `lib/core/config/app_config.dart` - تعديل اسم التطبيق ليكون عام
- `lib/core/router/app_router.dart` - إضافة مسارات التسجيل وإعداد المؤسسة
- `lib/features/main/presentation/pages/main_page.dart` - إعادة ترتيب القائمة
- `lib/features/templates/presentation/pages/templates_page.dart` - إضافة خيارات الختم والتوقيع
- `lib/features/letters/presentation/pages/letter_create_page.dart` - إضافة خيارات المشاركة بعد الإصدار
- `lib/features/auth/presentation/pages/login_page.dart` - إضافة زر تسجيل جديد والتوجيه لإعداد المؤسسة
- `lib/features/auth/presentation/bloc/auth_bloc.dart` - التحقق من حالة إعداد المؤسسة
- `lib/features/auth/presentation/bloc/auth_state.dart` - إضافة حقل needsOrganizationSetup

### الفرع: `feature/mobile-app-improvements`

---

## 🆕 ميزة رفع قالب الورق الرسمي عبر السكان (Dec 2025)

### ✅ تم إنجازه:
- [x] إنشاء فرع `feature/template-scan-upload`
- [x] إضافة مكتبات `file_picker` و `document_scanner_flutter` في pubspec.yaml
- [x] إنشاء صفحة `TemplateUploadPage` لرفع القالب عبر السكان/المعرض/PDF
- [x] إنشاء صفحة `TemplateInitialSetupPage` للإعداد الأولي عند تحميل التطبيق
- [x] تحديث صفحة القوالب لإضافة خيارات رفع القالب
- [x] إضافة مسارات جديدة في app_router.dart

### 📁 الملفات الجديدة:
- `lib/features/templates/presentation/pages/template_upload_page.dart` - صفحة رفع القالب مع 3 خطوات
- `lib/features/templates/presentation/pages/template_initial_setup_page.dart` - صفحة الإعداد الأولي مع 4 خطوات

### 📝 الميزات الجديدة:
1. **رفع الورق الرسمي**: سكان ضوئي / من المعرض / ملف PDF
2. **إعدادات الباركود**:
   - موقع الباركود (يمين/يسار)
   - عرض/إخفاء: الباركود، الرقم الصادر، التاريخ الهجري، التاريخ الميلادي، الموضوع
   - تحديد الهوامش (من الأعلى/من الجانب)
3. **الإعداد الأولي**: معالج 4 خطوات عند أول استخدام
4. **معاينة الباركود**: عرض مباشر للإعدادات

### 🔗 المسارات الجديدة:
- `/templates/upload` - رفع قالب جديد
- `/templates/initial-setup` - الإعداد الأولي

---

## 📌 ميزة الورق الرسمي والباركود (سابق)

### ✅ تم إنجازه:
- [x] إنشاء فرع `feature/letterhead-settings`
- [x] إضافة migration لحقول إعدادات الورق الرسمي
- [x] تحديث Model الشركة
- [x] إنشاء صفحة إعدادات الورق الرسمي
- [x] إنشاء قالب PDF مع الورق الرسمي كخلفية
- [x] إضافة الباركود + الرقم الصادر + التاريخ الهجري/الميلادي + الموضوع
- [x] إمكانية تحديد موقع الباركود (يمين/يسار)
- [x] إنشاء صفحة الإعداد الأولي (onboarding)
- [x] تثبيت مكتبة `milon/barcode`
- [x] رفع التغييرات إلى GitHub

### 📁 الملفات الجديدة:
- `database/migrations/2024_01_01_000010_add_letterhead_settings_to_companies.php`
- `resources/views/company/letterhead-settings.blade.php`
- `resources/views/company/setup.blade.php`
- `resources/views/letters/pdf-letterhead.blade.php`

### 🔗 الروابط الجديدة:
- `/company/letterhead` - إعدادات الورق الرسمي
- `/company/setup` - الإعداد الأولي للشركة

---

## 📱 Flutter Mobile App - API Integration Progress

### ✅ تم إنجازه:
- [x] إنشاء فرع جديد للعمل
- [x] إنشاء Data Layer (Models, DataSources, Repositories) لجميع الـ Features
- [x] إنشاء Domain Layer (Entities, Repositories, UseCases) لجميع الـ Features
- [x] إنشاء BLoC للـ Features (Auth, Dashboard, Letters, Company, Templates, Recipients, Organizations, Subscriptions)
- [x] تثبيت الحزم (flutter pub get)
- [x] إصلاح أخطاء الصفحات الموجودة (dashboard_page, letters_page, app_router)
- [x] إنشاء Widgets المفقودة (StatCard, QuickActionCard, RecentLettersList, AnimatedTextField, AnimatedButton)
- [x] إصلاح أخطاء Theme (CardThemeData, DialogThemeData)
- [x] تحديث DashboardStats entity لإضافة userName و companyName
- [x] إنشاء ملفات Android و iOS
- [x] إضافة Dark Mode مع Theme Provider
- [x] إنشاء صفحة الإعدادات مع تبديل الثيم
- [x] تحديث الـ Theme بالكامل (Light + Dark)
- [x] دمج التغييرات في main branch
- [x] رفع التغييرات إلى GitHub

### ✅ مكتمل - جاهز للاختبار

### 📁 الملفات المُنشأة للـ Flutter:
**Core:**
- `core/error/failures.dart` - أنواع الأخطاء
- `core/utils/either.dart` - Either type للنتائج

**Auth Feature:**
- `features/auth/data/models/user_model.dart`
- `features/auth/data/datasources/auth_remote_datasource.dart`
- `features/auth/data/repositories/auth_repository_impl.dart`
- `features/auth/domain/repositories/auth_repository.dart`
- `features/auth/domain/usecases/login_usecase.dart`
- `features/auth/domain/usecases/logout_usecase.dart`
- `features/auth/domain/usecases/get_user_usecase.dart`

**Dashboard Feature:**
- `features/dashboard/domain/entities/dashboard_stats.dart`
- `features/dashboard/data/models/dashboard_stats_model.dart`
- `features/dashboard/data/datasources/dashboard_remote_datasource.dart`
- `features/dashboard/data/repositories/dashboard_repository_impl.dart`
- `features/dashboard/domain/repositories/dashboard_repository.dart`
- `features/dashboard/domain/usecases/get_dashboard_usecase.dart`
- `features/dashboard/presentation/bloc/dashboard_bloc.dart`

**Letters Feature:**
- `features/letters/domain/entities/letter.dart`
- `features/letters/data/models/letter_model.dart`
- `features/letters/data/datasources/letters_remote_datasource.dart`
- `features/letters/data/repositories/letters_repository_impl.dart`
- `features/letters/domain/repositories/letters_repository.dart`
- `features/letters/domain/usecases/get_letters_usecase.dart`
- `features/letters/domain/usecases/create_letter_usecase.dart`
- `features/letters/presentation/bloc/letters_bloc.dart`

**Company Feature:**
- `features/company/data/datasources/company_remote_datasource.dart`
- `features/company/data/repositories/company_repository_impl.dart`
- `features/company/domain/repositories/company_repository.dart`
- `features/company/presentation/bloc/company_bloc.dart`

**Templates Feature:**
- `features/templates/data/datasources/templates_remote_datasource.dart`
- `features/templates/data/repositories/templates_repository_impl.dart`
- `features/templates/domain/repositories/templates_repository.dart`
- `features/templates/presentation/bloc/templates_bloc.dart`

**Recipients Feature:**
- `features/recipients/data/datasources/recipients_remote_datasource.dart`
- `features/recipients/data/repositories/recipients_repository_impl.dart`
- `features/recipients/domain/repositories/recipients_repository.dart`
- `features/recipients/presentation/bloc/recipients_bloc.dart`

**Organizations Feature:**
- `features/organizations/data/datasources/organizations_remote_datasource.dart`
- `features/organizations/data/repositories/organizations_repository_impl.dart`
- `features/organizations/domain/repositories/organizations_repository.dart`
- `features/organizations/presentation/bloc/organizations_bloc.dart`

**Subscriptions Feature:**
- `features/subscriptions/data/datasources/subscriptions_remote_datasource.dart`
- `features/subscriptions/data/repositories/subscriptions_repository_impl.dart`
- `features/subscriptions/domain/repositories/subscriptions_repository.dart`
- `features/subscriptions/presentation/bloc/subscriptions_bloc.dart`

---

## 📊 تقرير المطابقة - 100%

### ✅ الميزات المطلوبة الأساسية (مطابقة 100%)

| الميزة | الحالة | الملفات |
|--------|--------|---------|
| 1. ترقيم صادر تلقائي | ✅ | `Company::getNextReferenceNumber()` |
| 2. تاريخ هجري/ميلادي تلقائي | ✅ | `HijriDate.php` Helper |
| 3. رفع بيانات الشركة (شعار، توقيع، ختم) | ✅ | `CompanyController.php`, `company/settings.blade.php` |
| 4. قوالب جاهزة + تنسيق (خط، لون، حجم) | ✅ | `TemplateController.php`, `letters/create.blade.php` |
| 5. قاعدة بيانات متكاملة (أرشفة) | ✅ | جميع migrations |
| 6. نظام بحث ذكي | ✅ | `Letter::scopeSearch()`, `letters/search.blade.php` |
| 7. خيارات الإرسال | ✅ | `letters/show.blade.php` |
| 8. نظام اشتراكات مرن | ✅ | `SubscriptionController.php`, `subscriptions/index.blade.php` |

### ✅ الميزات الجديدة المضافة (إدارة البيانات المحفوظة)

| الميزة | الحالة | الملفات |
|--------|--------|---------|
| 9. إدارة أسماء المستلمين | ✅ | `RecipientController.php`, `recipients/*.blade.php` |
| 10. إدارة صفات المستلمين | ✅ | `RecipientTitleController.php`, `recipient-titles/*.blade.php` |
| 11. إدارة الجهات | ✅ | `OrganizationController.php`, `organizations/*.blade.php` |
| 12. إدارة مواضيع الخطابات | ✅ | `LetterSubjectController.php`, `letter-subjects/*.blade.php` |
| 13. الاختيار أو الكتابة الجديدة | ✅ | `letters/create.blade.php` (قوائم منسدلة + حقول نصية) |

### 📋 تفاصيل خيارات الإرسال (الميزة 7)
- ✅ إرسال بالإيميل
- ✅ تصدير PDF
- ✅ واتساب
- ✅ تيليجرام
- ✅ نسخ رابط المشاركة
- ✅ تحميل النسخة الأصلية
- ✅ SMS
- ✅ ملاحظة عن AirDrop

### 📋 تفاصيل نظام الاشتراكات (الميزة 8)
- ✅ اشتراك لمرة واحدة (100 خطاب)
- ✅ اشتراك شهري (غير محدود)
- ✅ اشتراك سنوي (غير محدود + توفير)

### 📋 تفاصيل إدارة البيانات المحفوظة (الميزات 9-13)
- ✅ صفحات مستقلة لإدارة كل نوع من البيانات (إضافة، تعديل، حذف)
- ✅ إمكانية الاختيار من القوائم المحفوظة عند إنشاء خطاب جديد
- ✅ إمكانية الكتابة الجديدة مع الاحتفاظ بخيار الاختيار
- ✅ ربط صفة المستلم تلقائياً عند اختيار مستلم محفوظ
- ✅ بحث وفلترة في جميع الصفحات
- ✅ تفعيل/إلغاء تفعيل العناصر

## 📁 الملفات المُنشأة/المُحدثة

**Controllers:**
- `LetterController.php` - إدارة الخطابات (محدث)
- `CompanyController.php` - إعدادات الشركة
- `TemplateController.php` - إدارة القوالب
- `SubscriptionController.php` - إدارة الاشتراكات
- `DashboardController.php` - لوحة التحكم
- `RecipientController.php` - إدارة المستلمين ⭐ جديد
- `RecipientTitleController.php` - إدارة صفات المستلمين ⭐ جديد
- `OrganizationController.php` - إدارة الجهات ⭐ جديد
- `LetterSubjectController.php` - إدارة مواضيع الخطابات ⭐ جديد

**Models:**
- `Letter.php`, `Company.php`, `LetterTemplate.php`, `Subscription.php`, `User.php`
- `Recipient.php` - المستلمين ⭐ جديد
- `RecipientTitle.php` - صفات المستلمين ⭐ جديد
- `Organization.php` - الجهات ⭐ جديد
- `LetterSubject.php` - مواضيع الخطابات ⭐ جديد

**Views:**
- `layouts/template.blade.php` - تصميم RTL حديث (محدث - قائمة جانبية)
- `dashboard.blade.php` - لوحة تحكم مع إحصائيات
- `letters/create.blade.php` - إنشاء خطاب + قوائم منسدلة للاختيار ⭐ محدث
- `letters/show.blade.php` - عرض + جميع خيارات الإرسال
- `letters/search.blade.php` - بحث متقدم
- `letters/pdf.blade.php` - قالب PDF
- `letters/share.blade.php` - صفحة المشاركة العامة
- `company/settings.blade.php` - إعدادات الشركة
- `recipients/` - صفحات إدارة المستلمين (index, create, edit) ⭐ جديد
- `recipient-titles/` - صفحات إدارة صفات المستلمين ⭐ جديد
- `organizations/` - صفحات إدارة الجهات ⭐ جديد
- `letter-subjects/` - صفحات إدارة مواضيع الخطابات ⭐ جديد
- `templates/index.blade.php` - قائمة القوالب ⭐ جديد
- `templates/create.blade.php` - إنشاء قالب ⭐ جديد
- `templates/edit.blade.php` - تعديل قالب ⭐ جديد
- `subscriptions/index.blade.php` - صفحة الاشتراكات ⭐ جديد
- `emails/letter.blade.php` - قالب البريد الإلكتروني ⭐ جديد

**Helpers:**
- `HijriDate.php` - تحويل التاريخ الهجري

**قاعدة البيانات:** `erp` (MySQL)

## 🚀 خطوات التشغيل

```bash
# 1. تثبيت المكتبات
composer install
composer require barryvdh/laravel-dompdf

# 2. توليد مفتاح التطبيق
php artisan key:generate

# 3. تشغيل migrations
php artisan migrate

# 4. إنشاء رابط التخزين
php artisan storage:link

# 5. تشغيل السيرفر
php artisan serve
```

---

# 📱 تقرير API لتطبيق الموبايل (Flutter)

## 📊 نسبة الإنجاز: 100%

تم إنشاء API كامل يغطي جميع وظائف الويب، جاهز للاستخدام مع تطبيق Flutter.

## 🔗 Base URL (Production)
```
https://emsg.elite-center-ld.com/api
```

> ⚠️ **ملاحظة**: تم تحديث الـ Base URL ليستخدم الرابط المنشور بدلاً من localhost

## 📋 جدول API Endpoints الكامل

### 1. المصادقة (Authentication) - 6 endpoints ✅

| Method | Endpoint | الوصف | Auth |
|--------|----------|-------|------|
| POST | `/api/auth/register` | تسجيل مستخدم جديد | ❌ |
| POST | `/api/auth/login` | تسجيل الدخول | ❌ |
| POST | `/api/auth/logout` | تسجيل الخروج | ✅ |
| GET | `/api/auth/user` | بيانات المستخدم الحالي | ✅ |
| PUT | `/api/auth/profile` | تحديث الملف الشخصي | ✅ |
| PUT | `/api/auth/password` | تغيير كلمة المرور | ✅ |

### 2. لوحة التحكم (Dashboard) - 2 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/dashboard` | إحصائيات لوحة التحكم الكاملة |
| GET | `/api/dashboard/quick-stats` | إحصائيات سريعة |

### 3. الخطابات (Letters) - 12 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/letters` | قائمة الخطابات (مع بحث وفلترة) |
| GET | `/api/letters/create-data` | بيانات إنشاء خطاب (قوالب، مستلمين، إلخ) |
| GET | `/api/letters/statistics` | إحصائيات الخطابات |
| POST | `/api/letters` | إنشاء خطاب جديد |
| GET | `/api/letters/{id}` | عرض خطاب محدد |
| PUT | `/api/letters/{id}` | تحديث خطاب |
| DELETE | `/api/letters/{id}` | حذف خطاب |
| POST | `/api/letters/{id}/issue` | إصدار الخطاب |
| GET | `/api/letters/{id}/pdf` | تحميل PDF |
| GET | `/api/letters/{id}/pdf-url` | رابط PDF |
| GET | `/api/letters/{id}/share-link` | رابط المشاركة |
| POST | `/api/letters/{id}/send-email` | إرسال بالبريد |

### 4. إعدادات الشركة (Company) - 8 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/company` | بيانات الشركة |
| PUT | `/api/company` | تحديث بيانات الشركة |
| POST | `/api/company/logo` | رفع الشعار |
| POST | `/api/company/signature` | رفع التوقيع |
| POST | `/api/company/stamp` | رفع الختم |
| DELETE | `/api/company/logo` | حذف الشعار |
| DELETE | `/api/company/signature` | حذف التوقيع |
| DELETE | `/api/company/stamp` | حذف الختم |

### 5. القوالب (Templates) - 7 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/templates` | قائمة القوالب |
| GET | `/api/templates/active` | القوالب النشطة |
| POST | `/api/templates` | إنشاء قالب |
| GET | `/api/templates/{id}` | عرض قالب |
| PUT | `/api/templates/{id}` | تحديث قالب |
| DELETE | `/api/templates/{id}` | حذف قالب |
| POST | `/api/templates/{id}/toggle-active` | تفعيل/إلغاء |

### 6. المستلمين (Recipients) - 7 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/recipients` | قائمة المستلمين |
| GET | `/api/recipients/active` | المستلمين النشطين |
| POST | `/api/recipients` | إضافة مستلم |
| GET | `/api/recipients/{id}` | عرض مستلم |
| PUT | `/api/recipients/{id}` | تحديث مستلم |
| DELETE | `/api/recipients/{id}` | حذف مستلم |
| POST | `/api/recipients/{id}/toggle-active` | تفعيل/إلغاء |

### 7. الجهات (Organizations) - 7 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/organizations` | قائمة الجهات |
| GET | `/api/organizations/active` | الجهات النشطة |
| POST | `/api/organizations` | إضافة جهة |
| GET | `/api/organizations/{id}` | عرض جهة |
| PUT | `/api/organizations/{id}` | تحديث جهة |
| DELETE | `/api/organizations/{id}` | حذف جهة |
| POST | `/api/organizations/{id}/toggle-active` | تفعيل/إلغاء |

### 8. صفات المستلمين (Recipient Titles) - 7 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/recipient-titles` | قائمة الصفات |
| GET | `/api/recipient-titles/active` | الصفات النشطة |
| POST | `/api/recipient-titles` | إضافة صفة |
| GET | `/api/recipient-titles/{id}` | عرض صفة |
| PUT | `/api/recipient-titles/{id}` | تحديث صفة |
| DELETE | `/api/recipient-titles/{id}` | حذف صفة |
| POST | `/api/recipient-titles/{id}/toggle-active` | تفعيل/إلغاء |

### 9. مواضيع الخطابات (Letter Subjects) - 7 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/letter-subjects` | قائمة المواضيع |
| GET | `/api/letter-subjects/active` | المواضيع النشطة |
| POST | `/api/letter-subjects` | إضافة موضوع |
| GET | `/api/letter-subjects/{id}` | عرض موضوع |
| PUT | `/api/letter-subjects/{id}` | تحديث موضوع |
| DELETE | `/api/letter-subjects/{id}` | حذف موضوع |
| POST | `/api/letter-subjects/{id}/toggle-active` | تفعيل/إلغاء |

### 10. الاشتراكات (Subscriptions) - 5 endpoints ✅

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/subscriptions/current` | الاشتراك الحالي |
| GET | `/api/subscriptions/plans` | الباقات المتاحة |
| POST | `/api/subscriptions/subscribe` | الاشتراك في باقة |
| POST | `/api/subscriptions/cancel` | إلغاء الاشتراك |
| GET | `/api/subscriptions/history` | سجل الاشتراكات |

---

## 📈 ملخص الإحصائيات

| القسم | عدد Endpoints |
|-------|---------------|
| المصادقة | 6 |
| لوحة التحكم | 2 |
| الخطابات | 12 |
| الشركة | 8 |
| القوالب | 7 |
| المستلمين | 7 |
| الجهات | 7 |
| صفات المستلمين | 7 |
| مواضيع الخطابات | 7 |
| الاشتراكات | 5 |
| **المجموع** | **68 endpoint** |

## 🔐 المصادقة (Authentication)

يستخدم النظام **Laravel Sanctum** للمصادقة:

```dart
// Flutter - Headers
headers: {
  'Authorization': 'Bearer $token',
  'Accept': 'application/json',
  'Content-Type': 'application/json',
}
```

## 📁 ملفات API Controllers

```
app/Http/Controllers/Api/
├── AuthController.php
├── DashboardApiController.php
├── LetterApiController.php
├── CompanyApiController.php
├── TemplateApiController.php
├── RecipientApiController.php
├── OrganizationApiController.php
├── RecipientTitleApiController.php
├── LetterSubjectApiController.php
└── SubscriptionApiController.php
```

## ✅ التزامن بين الويب والموبايل

- نفس قاعدة البيانات
- نفس المنطق البرمجي
- أي تعديل من الويب أو الموبايل ينعكس على الاثنين

---

---

# 📱 تطبيق Flutter للموبايل

## 📊 نسبة الإنجاز: 85% (UI جاهز - في انتظار تثبيت Flutter)

## 🏗️ هيكل المشروع (Clean Architecture + BLoC)

```
mobile_app/
├── lib/
│   ├── main.dart                    # نقطة البداية
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart      # إعدادات التطبيق
│   │   ├── constants/
│   │   │   └── app_constants.dart   # الثوابت
│   │   ├── di/
│   │   │   └── injection_container.dart  # Dependency Injection
│   │   ├── network/
│   │   │   ├── api_client.dart      # HTTP Client
│   │   │   └── auth_interceptor.dart # Token Interceptor
│   │   ├── router/
│   │   │   └── app_router.dart      # GoRouter Navigation
│   │   └── theme/
│   │       ├── app_colors.dart      # الألوان
│   │       └── app_theme.dart       # الثيم
│   └── features/
│       ├── auth/
│       │   ├── domain/entities/user.dart
│       │   └── presentation/
│       │       ├── bloc/auth_bloc.dart
│       │       └── pages/
│       │           ├── splash_page.dart
│       │           └── login_page.dart
│       ├── main/
│       │   └── presentation/pages/main_page.dart
│       ├── dashboard/
│       │   └── presentation/pages/dashboard_page.dart
│       ├── letters/
│       │   └── presentation/pages/
│       │       ├── letters_page.dart
│       │       ├── letter_create_page.dart
│       │       └── letter_details_page.dart
│       ├── templates/
│       │   └── presentation/pages/templates_page.dart
│       ├── company/
│       │   └── presentation/pages/company_settings_page.dart
│       ├── subscriptions/
│       │   └── presentation/pages/subscriptions_page.dart
│       ├── recipients/
│       │   └── presentation/pages/recipients_page.dart
│       ├── organizations/
│       │   └── presentation/pages/organizations_page.dart
│       ├── recipient_titles/
│       │   └── presentation/pages/recipient_titles_page.dart
│       └── letter_subjects/
│           └── presentation/pages/letter_subjects_page.dart
├── assets/
│   ├── images/
│   ├── icons/
│   ├── animations/
│   └── fonts/
└── pubspec.yaml
```

## 📦 الحزم المستخدمة

```yaml
dependencies:
  flutter_bloc: ^8.1.3          # State Management
  dio: ^5.3.3                   # HTTP Client
  retrofit: ^4.0.3              # API Generator
  json_serializable: ^6.7.1     # JSON Serialization
  flutter_secure_storage: ^9.0.0 # Secure Token Storage
  shared_preferences: ^2.2.2    # Local Storage
  go_router: ^12.1.1            # Navigation
  google_fonts: ^6.1.0          # Cairo Font
  lottie: ^2.7.0                # Animations
  animate_do: ^3.1.2            # UI Animations
  iconsax: ^0.0.8               # Icons
  get_it: ^7.6.4                # Dependency Injection
  equatable: ^2.0.5             # State Comparison
  share_plus: ^7.2.1            # Share Content
  flutter_staggered_animations: ^1.1.1 # List Animations
```

## 🎨 الصفحات المُنشأة (مع Animations)

| الصفحة | الملف | الحالة |
|--------|-------|--------|
| Splash Screen | `splash_page.dart` | ✅ |
| تسجيل الدخول | `login_page.dart` | ✅ |
| الصفحة الرئيسية | `main_page.dart` | ✅ |
| لوحة التحكم | `dashboard_page.dart` | ✅ |
| قائمة الخطابات | `letters_page.dart` | ✅ |
| إنشاء خطاب | `letter_create_page.dart` | ✅ |
| تفاصيل الخطاب | `letter_details_page.dart` | ✅ |
| القوالب | `templates_page.dart` | ✅ |
| إعدادات الشركة | `company_settings_page.dart` | ✅ |
| الاشتراكات | `subscriptions_page.dart` | ✅ |
| المستلمين | `recipients_page.dart` | ✅ |
| الجهات | `organizations_page.dart` | ✅ |
| صفات المستلمين | `recipient_titles_page.dart` | ✅ |
| مواضيع الخطابات | `letter_subjects_page.dart` | ✅ |

## 🔧 إعدادات API

```dart
// lib/core/config/app_config.dart
class AppConfig {
  static const String baseUrl = 'http://localhost:8000/api';
  // ⚠️ تغيير localhost إلى IP السيرفر للموبايل
  // مثال: 'http://192.168.1.100:8000/api'
  
  static const String tokenKey = 'auth_token';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
```

## 🚀 خطوات تشغيل تطبيق الموبايل

```bash
# 1. الانتقال لمجلد التطبيق
cd mobile_app

# 2. تثبيت الحزم
flutter pub get

# 3. توليد ملفات JSON
flutter pub run build_runner build --delete-conflicting-outputs

# 4. تشغيل التطبيق
flutter run
```

## ⚠️ ملاحظات مهمة

1. **تغيير Base URL**: يجب تغيير `localhost` إلى IP السيرفر الفعلي
2. **الأخطاء الحالية**: أخطاء lint بسبب عدم تثبيت Flutter SDK (طبيعية)
3. **RTL**: التطبيق مُعد للغة العربية (RTL) بالكامل
4. **Animations**: جميع الصفحات تحتوي على animations باستخدام animate_do
5. **Theme**: الألوان والتصميم مطابق لتصميم الويب

## 🔗 ربط API

التطبيق جاهز للربط مع الـ 68 endpoint المتوفرة في Laravel API:
- المصادقة (6 endpoints)
- لوحة التحكم (2 endpoints)
- الخطابات (12 endpoints)
- الشركة (8 endpoints)
- القوالب (7 endpoints)
- المستلمين (7 endpoints)
- الجهات (7 endpoints)
- صفات المستلمين (7 endpoints)
- مواضيع الخطابات (7 endpoints)
- الاشتراكات (5 endpoints)

---

---

## 📱 ميزة الورق الرسمي والباركود للموبايل (مكتملة 100%) 

### ✅ تم إنجازه:
- [x] إضافة مكتبات PDF والباركود في Flutter (pdf, printing, barcode, qr_flutter)
- [x] إنشاء PdfService مع دعم العربية والورق الرسمي
- [x] إنشاء BarcodeService مع التواريخ الهجرية والميلادية
- [x] إنشاء صفحة الإعداد الأولي للورق الرسمي (LetterheadSetupPage)
- [x] تحديث CompanyBloc مع events و states جديدة
- [x] إضافة methods للورق الرسمي في Repository و DataSource
- [x] تحديث Laravel API لدعم الورق الرسمي والباركود
- [x] إنشاء قالب PDF للورق الرسمي مع الباركود في Laravel

### ✅ تحديثات ديسمبر 2024 - تصدير PDF مع دعم العربية الكامل:
- [x] تحديث PdfService مع خط Amiri العربي
- [x] استخدام BarcodeWidget الحقيقي من مكتبة barcode
- [x] تحويل التاريخ الهجري بخوارزمية دقيقة
- [x] إنشاء صفحة LetterheadOnboardingPage للإعداد الأولي
- [x] تحديث صفحة تفاصيل الخطاب مع تصدير/طباعة/مشاركة PDF
- [x] إضافة خطوط Amiri-Regular.ttf و Amiri-Bold.ttf

### 📁 الملفات الجديدة/المُحدثة:

**Laravel API:**
- `app/Http/Controllers/Api/CompanyApiController.php` - إضافة 6 endpoints جديدة
- `routes/api.php` - إضافة routes للورق الرسمي والإعداد

**Flutter Mobile:**
- `lib/features/company/presentation/pages/company_setup_page.dart` ⭐ جديد
- `lib/features/company/presentation/pages/company_settings_page.dart` ⭐ محدث
- `lib/features/company/data/datasources/company_remote_datasource.dart` ⭐ محدث
- `lib/core/config/app_config.dart` ⭐ محدث
- `lib/core/router/app_router.dart` ⭐ محدث

### 🔗 API Endpoints الجديدة:

| Method | Endpoint | الوصف |
|--------|----------|-------|
| GET | `/api/company/letterhead` | جلب إعدادات الورق الرسمي |
| PUT | `/api/company/letterhead` | تحديث إعدادات الباركود |
| POST | `/api/company/letterhead` | رفع ملف الورق الرسمي |
| DELETE | `/api/company/letterhead` | حذف ملف الورق الرسمي |
| GET | `/api/company/setup-status` | التحقق من حالة الإعداد |
| POST | `/api/company/complete-setup` | إكمال الإعداد الأولي |

### 📋 الميزات:
1. **رفع الورق الرسمي**: سكان PDF أو صورة للورق الرسمي
2. **الباركود**: يحتوي على الرقم الصادر
3. **الترتيب**: باركود ← رقم صادر ← تاريخ هجري ← تاريخ ميلادي ← موضوع
4. **موقع**: يمين أو يسار الورقة
5. **الإعداد الأولي**: معالج 3 خطوات عند أول استخدام

---

## Lessons

- Laravel 10 مع PHP 8.1+
- Bootstrap 5 RTL للواجهة العربية
- barryvdh/laravel-dompdf لتوليد PDF
- خوارزمية تحويل التاريخ الهجري مدمجة
- قاعدة البيانات: erp
- Laravel Sanctum للـ API Authentication
- Flutter مع Clean Architecture + BLoC
- animate_do للـ UI Animations
- GoRouter للـ Navigation
- GetIt للـ Dependency Injection
- **Flutter Provider Fix**: When using BLoC with provider pattern, ensure all BLoCs accessed via `context.read<>()` are added to `MultiBlocProvider` in main.dart. Simply registering them in dependency injection (GetIt) is not sufficient - they must be provided in the widget tree.

### 🐛 Bug Fix Lessons (Dec 2025):

- **PDF Arabic Text Reversed**: Fixed issue where Arabic text appeared reversed/mirrored in exported PDF. The problem was that dompdf doesn't properly handle Google Fonts loaded via URL for RTL languages. Solution: Removed @font-face for Cairo font and used DejaVu Sans (built-in dompdf font that supports Arabic). Also created `config/dompdf.php` with `enable_remote => true` and `default_font => 'DejaVu Sans'`.

- **Database Column Mismatch**: Fixed 500 error in `DashboardApiController` where code tried to query `is_active` column on subscriptions table, but table uses `status` enum instead. Always check actual database schema vs model queries.
- **Missing User Table Columns**: Laravel authentication expects `remember_token` and `email_verified_at` columns in users table. Created migration to add these missing columns.
- **Subscription Model Methods**: Added missing methods `remainingLetters()`, `daysRemaining()`, and `getPlanAttribute()` to Subscription model that were being called by API but didn't exist.
- **Cache Clearing**: Always clear Laravel caches after deployment fixes: `php artisan config:clear`, `cache:clear`, `route:clear`, `view:clear`
- **Production Environment**: Use `APP_DEBUG=false` and `LOG_LEVEL=error` in production. Set proper database credentials for cPanel hosting.
- **Frontend Assets**: Run `npm install` and `npm run build` to ensure frontend assets are properly compiled for production.
- **cPanel Deployment**: Database credentials format - `elitece_erp` database, `elitece_user` username, password: `Bashar@1994engzy`

### 🔧 Dec 14, 2025 - Logout Route & Mobile Permissions Fix:

- **Logout Route Error**: Fixed "GET method not supported for route logout" error. Changed `Route::post('/logout')` to `Route::match(['get', 'post'], '/logout')` in `routes/web.php` to support both GET and POST methods.

- **Mobile App Crash on Template Upload (iPhone)**: Added missing permissions for iOS and Android:
  - **iOS (Info.plist)**: Added `NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`, `NSCameraUsageDescription`, `NSDocumentsFolderUsageDescription`, `UIFileSharingEnabled`, `LSSupportsOpeningDocumentsInPlace`
  - **Android (AndroidManifest.xml)**: Added `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`, `READ_MEDIA_AUDIO`, `CAMERA`, `MANAGE_EXTERNAL_STORAGE`
  - **Flutter**: Added `permission_handler: ^11.3.0` package and implemented runtime permission requests in `template_upload_page.dart` and `template_initial_setup_page.dart`

### 🔧 Dec 14, 2025 - Legal Pages (English Only)

- **English-only Legal Pages**: Updated `/privacy-policy` and `/terms-conditions` web pages to be English-only for App Store / Google Play submission requirements.
- **Test Coverage**: Added `tests/Feature/LegalPagesTest.php` to assert both pages return `200` and contain English headings.

### 🔧 Dec 21, 2025 - Hero Tag & Route Fix

- **Flutter Hero Tag Conflict**: Fixed "multiple heroes share the same tag" error. When multiple pages have `FloatingActionButton` widgets, each must have a unique `heroTag` property to prevent Hero animation conflicts during page transitions. Added unique heroTags: `main_page_fab`, `letters_page_fab`, `letter_subjects_fab`, `recipient_titles_fab`, `recipients_fab`, `organizations_fab`.

- **Missing Route Fix**: Fixed "GoException: no routes for location: /letters/5/edit" error. The `letters_page.dart` was navigating to `/letters/:id/edit` but the route was defined as `/letters/:id`. Changed navigation from `/letters/${letter['id']}/edit` to `/letters/${letter['id']}`.
