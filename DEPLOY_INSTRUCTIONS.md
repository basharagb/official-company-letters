# تعليمات النشر على السيرفر الإنتاجي

## الملفات المطلوب رفعها:

### 1. ملف إنشاء حساب Demo
```
app/Console/Commands/CreateDemoAccount.php
```

### 2. Migration الشركات المتعددة
```
database/migrations/2024_12_22_000001_add_multi_company_support.php
```

### 3. Models المحدثة
```
app/Models/User.php
app/Models/JoinRequest.php
```

### 4. Controllers المحدثة
```
app/Http/Controllers/RegisterController.php
app/Http/Controllers/JoinRequestController.php
app/Http/Controllers/AdminController.php
app/Http/Controllers/Api/AuthController.php
```

### 5. Views الجديدة
```
resources/views/register.blade.php
resources/views/admin/dashboard.blade.php
resources/views/admin/companies.blade.php
resources/views/join-requests/index.blade.php
```

### 6. Routes المحدثة
```
routes/web.php
routes/api.php
```

### 7. Seeder المحدث
```
database/seeders/DatabaseSeeder.php
```

---

## خطوات النشر:

### 1. رفع الملفات عبر FTP/SFTP
استخدم FileZilla أو أي برنامج FTP لرفع الملفات المذكورة أعلاه.

### 2. الاتصال بالسيرفر عبر SSH
```bash
ssh username@your-server.com
cd /path/to/your/project
```

### 3. تشغيل Migrations
```bash
php artisan migrate
```

### 4. تحديث كلمة مرور الأدمن الرئيسي
```bash
php artisan tinker
```
ثم:
```php
$admin = User::where('email', 'admin@letters.sa')->first();
$admin->update([
    'password' => Hash::make('Adm!n@L3tt3rs#2024$Str0ng'),
    'is_super_admin' => true,
    'is_company_owner' => true,
    'status' => 'approved'
]);
exit
```

### 5. إنشاء حساب Demo للمراجعة
```bash
php artisan demo:create --email=demo@letters.sa --password=Demo@Review2024 --with-data
```

### 6. مسح الـ Cache
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

---

## بيانات الحسابات:

### الأدمن الرئيسي (Super Admin):
- **Email**: admin@letters.sa
- **Password**: Adm!n@L3tt3rs#2024$Str0ng
- **الصلاحيات**: يمكنه رؤية جميع الشركات والخطابات

### حساب Demo للمراجعة:
- **Email**: demo@letters.sa
- **Password**: Demo@Review2024
- **الصلاحيات**: مالك شركة عادية مع بيانات تجريبية

---

## بيانات App Store Connect:

في قسم **App Review Information** > **Sign-in required**:

```
Demo Account Username: demo@letters.sa
Demo Account Password: Demo@Review2024
```

### ملاحظات للمراجع (Review Notes):
```
مرحباً بفريق المراجعة،

هذا تطبيق لإدارة الخطابات الرسمية للشركات والمؤسسات في المملكة العربية السعودية.

بيانات الدخول التجريبية:
Email: demo@letters.sa
Password: Demo@Review2024

الميزات الرئيسية:
• إنشاء وإدارة الخطابات الرسمية مع رقم صادر وباركود
• قوالب جاهزة للخطابات
• إدارة المستلمين والجهات الحكومية
• طباعة الخطابات على الورق الرسمي للشركة
• نظام اشتراكات للشركات
• دعم التاريخ الهجري والميلادي

تم إضافة بيانات تجريبية كاملة (خطابات، مستلمين، قوالب) للحساب التجريبي لتسهيل المراجعة.

شكراً لكم.
```

---

## التحقق من النشر:

1. افتح الموقع: https://emsg.elite-center-ld.com
2. سجل دخول بحساب Demo: `demo@letters.sa`
3. تحقق من وجود البيانات التجريبية
4. جرب إنشاء خطاب جديد
5. جرب طباعة خطاب بصيغة PDF

---

## ملاحظات مهمة:

⚠️ **لا تنسى**:
- تحديث بيانات الدخول في App Store Connect
- إضافة الملاحظات للمراجع
- التأكد من أن السيرفر يعمل بشكل صحيح
- اختبار التطبيق قبل إعادة الإرسال

📱 **للموبايل**:
- تأكد من رفع ملف `register_page.dart` المحدث
- اختبر التطبيق على جهاز حقيقي
- تأكد من أن API يعمل بشكل صحيح
