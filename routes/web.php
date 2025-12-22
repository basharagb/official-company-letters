<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\RegisterController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\LetterController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\CompanyController;
use App\Http\Controllers\TemplateController;
use App\Http\Controllers\SubscriptionController;
use App\Http\Controllers\RecipientController;
use App\Http\Controllers\OrganizationController;
use App\Http\Controllers\RecipientTitleController;
use App\Http\Controllers\LetterSubjectController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\JoinRequestController;
use App\Http\Controllers\UserSettingsController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| نظام إصدار الخطابات الرسمية للشركات
|
*/

// الصفحة الرئيسية
Route::get('/', function () {
    return view('index');
})->name('home');

// رابط مشاركة الخطاب (عام)
Route::get('/letters/share/{token}', [LetterController::class, 'share'])->name('letters.share');

// صفحات سياسة الخصوصية والشروط والأحكام (عامة - للـ App Store و Google Play)
Route::get('/privacy-policy', function () {
    return view('pages.privacy-policy');
})->name('privacy-policy');

Route::get('/terms-conditions', function () {
    return view('pages.terms-conditions');
})->name('terms-conditions');

// مسارات الضيوف (غير مسجلين) - تسجيل الدخول والتسجيل
Route::middleware(['already_login'])->group(function () {
    Route::get('/login', [LoginController::class, 'index'])->name('login');
    Route::post('/login', [LoginController::class, 'authenticate'])->name('login.post');
    
    // التسجيل الجديد
    Route::get('/register', [RegisterController::class, 'index'])->name('register');
    Route::post('/register', [RegisterController::class, 'store'])->name('register.submit');
});

// API للحصول على قائمة الشركات (عام)
Route::get('/api/companies', [RegisterController::class, 'getCompanies'])->name('api.companies');

// مسارات المستخدمين المسجلين
Route::middleware(['is_login'])->group(function () {
    // تسجيل الخروج
    Route::match(['get', 'post'], '/logout', [LoginController::class, 'logout'])->name('logout');
    
    // الإعداد الأولي للشركة (بدون middleware setup.completed)
    Route::get('/company/setup', [CompanyController::class, 'setup'])->name('company.setup');
    Route::post('/company/setup/step1', [CompanyController::class, 'setupStep1'])->name('company.setup.step1');
    Route::post('/company/setup/step2', [CompanyController::class, 'setupStep2'])->name('company.setup.step2');
    Route::post('/company/setup/step3', [CompanyController::class, 'setupStep3'])->name('company.setup.step3');
});

// مسارات تتطلب إكمال الإعداد الأولي
Route::middleware(['is_login', 'setup.completed'])->group(function () {
    // لوحة التحكم
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
    
    // إعدادات الشركة
    Route::get('/company/settings', [CompanyController::class, 'settings'])->name('company.settings');
    Route::put('/company/settings', [CompanyController::class, 'update'])->name('company.update');
    Route::post('/company', [CompanyController::class, 'store'])->name('company.store');
    
    // إعدادات الورق الرسمي
    Route::get('/company/letterhead', [CompanyController::class, 'letterheadSettings'])->name('company.letterhead');
    Route::put('/company/letterhead', [CompanyController::class, 'updateLetterhead'])->name('company.letterhead.update');
    
    // الخطابات
    Route::prefix('letters')->name('letters.')->group(function () {
        Route::get('/', [LetterController::class, 'search'])->name('index');
        Route::get('/create', [LetterController::class, 'create'])->name('create');
        Route::post('/', [LetterController::class, 'store'])->name('store');
        Route::get('/search', [LetterController::class, 'search'])->name('search');
        Route::get('/{id}', [LetterController::class, 'show'])->name('show');
        Route::get('/{id}/edit', [LetterController::class, 'edit'])->name('edit');
        Route::put('/{id}', [LetterController::class, 'update'])->name('update');
        Route::post('/{id}/issue', [LetterController::class, 'issue'])->name('issue');
        Route::get('/{id}/pdf', [LetterController::class, 'exportPdf'])->name('pdf');
        Route::post('/{id}/email', [LetterController::class, 'sendEmail'])->name('email');
        Route::get('/{id}/share-link', [LetterController::class, 'getShareLink'])->name('share-link');
    });
    
    // القوالب
    Route::prefix('templates')->name('templates.')->group(function () {
        Route::get('/', [TemplateController::class, 'index'])->name('index');
        Route::get('/create', [TemplateController::class, 'create'])->name('create');
        Route::post('/', [TemplateController::class, 'store'])->name('store');
        Route::get('/{id}/edit', [TemplateController::class, 'edit'])->name('edit');
        Route::put('/{id}', [TemplateController::class, 'update'])->name('update');
        Route::delete('/{id}', [TemplateController::class, 'destroy'])->name('destroy');
    });

    // الاشتراكات
    Route::prefix('subscriptions')->name('subscriptions.')->group(function () {
        Route::get('/', [SubscriptionController::class, 'index'])->name('index');
        Route::post('/subscribe', [SubscriptionController::class, 'subscribe'])->name('subscribe');
        Route::post('/cancel', [SubscriptionController::class, 'cancel'])->name('cancel');
    });

    // المستلمين
    Route::prefix('recipients')->name('recipients.')->group(function () {
        Route::get('/', [RecipientController::class, 'index'])->name('index');
        Route::get('/create', [RecipientController::class, 'create'])->name('create');
        Route::post('/', [RecipientController::class, 'store'])->name('store');
        Route::get('/{id}/edit', [RecipientController::class, 'edit'])->name('edit');
        Route::put('/{id}', [RecipientController::class, 'update'])->name('update');
        Route::delete('/{id}', [RecipientController::class, 'destroy'])->name('destroy');
        Route::get('/api/all', [RecipientController::class, 'getAll'])->name('api.all');
    });

    // الجهات
    Route::prefix('organizations')->name('organizations.')->group(function () {
        Route::get('/', [OrganizationController::class, 'index'])->name('index');
        Route::get('/create', [OrganizationController::class, 'create'])->name('create');
        Route::post('/', [OrganizationController::class, 'store'])->name('store');
        Route::get('/{id}/edit', [OrganizationController::class, 'edit'])->name('edit');
        Route::put('/{id}', [OrganizationController::class, 'update'])->name('update');
        Route::delete('/{id}', [OrganizationController::class, 'destroy'])->name('destroy');
        Route::get('/api/all', [OrganizationController::class, 'getAll'])->name('api.all');
    });

    // صفات المستلمين
    Route::prefix('recipient-titles')->name('recipient-titles.')->group(function () {
        Route::get('/', [RecipientTitleController::class, 'index'])->name('index');
        Route::get('/create', [RecipientTitleController::class, 'create'])->name('create');
        Route::post('/', [RecipientTitleController::class, 'store'])->name('store');
        Route::get('/{id}/edit', [RecipientTitleController::class, 'edit'])->name('edit');
        Route::put('/{id}', [RecipientTitleController::class, 'update'])->name('update');
        Route::delete('/{id}', [RecipientTitleController::class, 'destroy'])->name('destroy');
        Route::get('/api/all', [RecipientTitleController::class, 'getAll'])->name('api.all');
    });

    // مواضيع الخطابات
    Route::prefix('letter-subjects')->name('letter-subjects.')->group(function () {
        Route::get('/', [LetterSubjectController::class, 'index'])->name('index');
        Route::get('/create', [LetterSubjectController::class, 'create'])->name('create');
        Route::post('/', [LetterSubjectController::class, 'store'])->name('store');
        Route::get('/{id}/edit', [LetterSubjectController::class, 'edit'])->name('edit');
        Route::put('/{id}', [LetterSubjectController::class, 'update'])->name('update');
        Route::delete('/{id}', [LetterSubjectController::class, 'destroy'])->name('destroy');
        Route::get('/api/all', [LetterSubjectController::class, 'getAll'])->name('api.all');
    });

    // طلبات الانضمام (لمالك الشركة والأدمن)
    Route::prefix('join-requests')->name('join-requests.')->group(function () {
        Route::get('/', [JoinRequestController::class, 'index'])->name('index');
        Route::post('/{joinRequest}/approve', [JoinRequestController::class, 'approve'])->name('approve');
        Route::post('/{joinRequest}/reject', [JoinRequestController::class, 'reject'])->name('reject');
    });

    // إعدادات المستخدم
    Route::prefix('user')->name('user.')->group(function () {
        Route::get('/settings', [UserSettingsController::class, 'index'])->name('settings');
        Route::put('/profile', [UserSettingsController::class, 'updateProfile'])->name('update-profile');
        Route::put('/password', [UserSettingsController::class, 'changePassword'])->name('change-password');
        Route::delete('/account', [UserSettingsController::class, 'deleteAccount'])->name('delete-account');
    });

    // لوحة تحكم الأدمن الرئيسي
    Route::prefix('admin')->name('admin.')->middleware('is_admin')->group(function () {
        Route::get('/dashboard', [AdminController::class, 'dashboard'])->name('dashboard');
        Route::get('/companies', [AdminController::class, 'companies'])->name('companies');
        Route::get('/companies/{company}', [AdminController::class, 'companyDetails'])->name('company.details');
        Route::get('/companies/{company}/edit', [AdminController::class, 'editCompany'])->name('company.edit');
        Route::put('/companies/{company}', [AdminController::class, 'updateCompany'])->name('company.update');
        Route::delete('/companies/{company}', [AdminController::class, 'deleteCompany'])->name('company.delete');
        Route::get('/letters', [AdminController::class, 'allLetters'])->name('letters');
        Route::get('/users', [AdminController::class, 'users'])->name('users');
    });
});