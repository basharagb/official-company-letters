<?php
/**
 * سكريبت اختبار شامل للنظام
 * تشغيل: php test_system.php
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

echo "🔍 اختبار شامل للنظام...\n\n";

// 1. اختبار قاعدة البيانات
echo "1️⃣ اختبار الاتصال بقاعدة البيانات...\n";
try {
    DB::connection()->getPdo();
    echo "   ✅ الاتصال بقاعدة البيانات ناجح\n\n";
} catch (\Exception $e) {
    echo "   ❌ فشل الاتصال: " . $e->getMessage() . "\n\n";
    exit(1);
}

// 2. اختبار الحسابات
echo "2️⃣ اختبار الحسابات...\n";

$adminUser = App\Models\User::where('email', 'admin@letters.sa')->first();
if ($adminUser) {
    echo "   ✅ الأدمن الرئيسي موجود: {$adminUser->name}\n";
    echo "      - Super Admin: " . ($adminUser->isSuperAdmin() ? 'نعم' : 'لا') . "\n";
    echo "      - Company Owner: " . ($adminUser->isCompanyOwner() ? 'نعم' : 'لا') . "\n";
} else {
    echo "   ⚠️  الأدمن الرئيسي غير موجود\n";
}

$demoUser = App\Models\User::where('email', 'demo@letters.sa')->first();
if ($demoUser) {
    echo "   ✅ حساب Demo موجود: {$demoUser->name}\n";
    echo "      - Company: {$demoUser->company->name}\n";
    echo "      - Status: {$demoUser->status}\n";
} else {
    echo "   ⚠️  حساب Demo غير موجود\n";
}
echo "\n";

// 3. اختبار البيانات التجريبية
echo "3️⃣ اختبار البيانات التجريبية...\n";
if ($demoUser && $demoUser->company) {
    $company = $demoUser->company;
    
    $lettersCount = App\Models\Letter::where('company_id', $company->id)->count();
    $recipientsCount = App\Models\Recipient::where('company_id', $company->id)->count();
    $templatesCount = App\Models\LetterTemplate::where('company_id', $company->id)->count();
    $orgsCount = App\Models\Organization::where('company_id', $company->id)->count();
    
    echo "   ✅ الخطابات: {$lettersCount}\n";
    echo "   ✅ المستلمين: {$recipientsCount}\n";
    echo "   ✅ القوالب: {$templatesCount}\n";
    echo "   ✅ الجهات: {$orgsCount}\n";
} else {
    echo "   ⚠️  لا توجد بيانات تجريبية\n";
}
echo "\n";

// 4. اختبار الـ Routes
echo "4️⃣ اختبار الـ Routes الأساسية...\n";
$routes = [
    'login' => 'صفحة تسجيل الدخول',
    'register' => 'صفحة التسجيل',
    'dashboard' => 'لوحة التحكم',
    'admin.dashboard' => 'لوحة الأدمن',
    'join-requests.index' => 'طلبات الانضمام',
];

foreach ($routes as $name => $desc) {
    try {
        $url = route($name);
        echo "   ✅ {$desc}: {$url}\n";
    } catch (\Exception $e) {
        echo "   ❌ {$desc}: غير موجود\n";
    }
}
echo "\n";

// 5. اختبار الـ Migrations
echo "5️⃣ اختبار الـ Migrations...\n";
$tables = [
    'users' => 'المستخدمين',
    'companies' => 'الشركات',
    'letters' => 'الخطابات',
    'join_requests' => 'طلبات الانضمام',
    'subscriptions' => 'الاشتراكات',
];

foreach ($tables as $table => $desc) {
    try {
        $exists = Schema::hasTable($table);
        if ($exists) {
            $count = DB::table($table)->count();
            echo "   ✅ جدول {$desc}: موجود ({$count} سجل)\n";
        } else {
            echo "   ❌ جدول {$desc}: غير موجود\n";
        }
    } catch (\Exception $e) {
        echo "   ❌ جدول {$desc}: خطأ\n";
    }
}
echo "\n";

// 6. اختبار الـ Middleware
echo "6️⃣ اختبار الـ Middleware...\n";
$middlewares = [
    'is_login' => 'التحقق من تسجيل الدخول',
    'setup.completed' => 'التحقق من إكمال الإعداد',
    'is_admin' => 'التحقق من صلاحيات الأدمن',
];

foreach ($middlewares as $name => $desc) {
    $exists = array_key_exists($name, app('router')->getMiddleware());
    echo ($exists ? "   ✅" : "   ❌") . " {$desc}\n";
}
echo "\n";

// 7. اختبار كلمات المرور
echo "7️⃣ اختبار كلمات المرور...\n";
if ($adminUser) {
    $adminPasswordCorrect = Hash::check('Adm!n@L3tt3rs#2024$Str0ng', $adminUser->password);
    echo ($adminPasswordCorrect ? "   ✅" : "   ❌") . " كلمة مرور الأدمن\n";
}
if ($demoUser) {
    $demoPasswordCorrect = Hash::check('Demo@Review2024', $demoUser->password);
    echo ($demoPasswordCorrect ? "   ✅" : "   ❌") . " كلمة مرور Demo\n";
}
echo "\n";

echo "✅ اكتمل الاختبار الشامل!\n";
