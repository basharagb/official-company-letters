# نظام إصدار الخطابات الرسمية للشركات

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

## 🔗 Base URL
```
http://localhost:8000/api
```

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

## Lessons

- Laravel 10 مع PHP 8.1+
- Bootstrap 5 RTL للواجهة العربية
- barryvdh/laravel-dompdf لتوليد PDF
- خوارزمية تحويل التاريخ الهجري مدمجة
- قاعدة البيانات: erp
- Laravel Sanctum للـ API Authentication
