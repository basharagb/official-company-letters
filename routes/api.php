<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\LetterApiController;
use App\Http\Controllers\Api\CompanyApiController;
use App\Http\Controllers\Api\TemplateApiController;
use App\Http\Controllers\Api\RecipientApiController;
use App\Http\Controllers\Api\OrganizationApiController;
use App\Http\Controllers\Api\RecipientTitleApiController;
use App\Http\Controllers\Api\LetterSubjectApiController;
use App\Http\Controllers\Api\SubscriptionApiController;
use App\Http\Controllers\Api\DashboardApiController;
use App\Http\Controllers\Api\UserApiController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// ==========================================
// المصادقة (Authentication) - بدون تسجيل دخول
// ==========================================
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    Route::get('/companies', [AuthController::class, 'getCompanies']);
});

// ==========================================
// الـ Routes المحمية (تتطلب تسجيل دخول)
// ==========================================
Route::middleware('auth:sanctum')->group(function () {
    
    // ----- المصادقة -----
    Route::prefix('auth')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/user', [AuthController::class, 'user']);
        Route::put('/profile', [AuthController::class, 'updateProfile']);
        Route::put('/password', [AuthController::class, 'changePassword']);
    });

    // ----- لوحة التحكم -----
    Route::prefix('dashboard')->group(function () {
        Route::get('/', [DashboardApiController::class, 'index']);
        Route::get('/quick-stats', [DashboardApiController::class, 'quickStats']);
    });

    // ----- الخطابات -----
    Route::prefix('letters')->group(function () {
        Route::get('/', [LetterApiController::class, 'index']);
        Route::get('/create-data', [LetterApiController::class, 'createData']);
        Route::get('/statistics', [LetterApiController::class, 'statistics']);
        Route::post('/', [LetterApiController::class, 'store']);
        Route::get('/{id}', [LetterApiController::class, 'show']);
        Route::put('/{id}', [LetterApiController::class, 'update']);
        Route::delete('/{id}', [LetterApiController::class, 'destroy']);
        Route::post('/{id}/issue', [LetterApiController::class, 'issue']);
        Route::get('/{id}/pdf', [LetterApiController::class, 'exportPdf']);
        Route::get('/{id}/pdf-url', [LetterApiController::class, 'getPdfUrl']);
        Route::get('/{id}/share-link', [LetterApiController::class, 'getShareLink']);
        Route::post('/{id}/send-email', [LetterApiController::class, 'sendEmail']);
    });

    // ----- إعدادات الشركة -----
    Route::prefix('company')->group(function () {
        Route::get('/', [CompanyApiController::class, 'show']);
        Route::put('/', [CompanyApiController::class, 'update']);
        Route::post('/logo', [CompanyApiController::class, 'uploadLogo']);
        Route::post('/signature', [CompanyApiController::class, 'uploadSignature']);
        Route::post('/stamp', [CompanyApiController::class, 'uploadStamp']);
        Route::delete('/logo', [CompanyApiController::class, 'deleteLogo']);
        Route::delete('/signature', [CompanyApiController::class, 'deleteSignature']);
        Route::delete('/stamp', [CompanyApiController::class, 'deleteStamp']);
        // إعدادات الورق الرسمي
        Route::get('/letterhead', [CompanyApiController::class, 'getLetterheadSettings']);
        Route::put('/letterhead', [CompanyApiController::class, 'updateLetterheadSettings']);
        Route::post('/letterhead', [CompanyApiController::class, 'uploadLetterhead']);
        Route::delete('/letterhead', [CompanyApiController::class, 'deleteLetterhead']);
        // الإعداد الأولي
        Route::get('/setup-status', [CompanyApiController::class, 'checkSetupStatus']);
        Route::post('/complete-setup', [CompanyApiController::class, 'completeSetup']);
    });

    // ----- القوالب -----
    Route::prefix('templates')->group(function () {
        Route::get('/', [TemplateApiController::class, 'index']);
        Route::get('/active', [TemplateApiController::class, 'active']);
        Route::post('/', [TemplateApiController::class, 'store']);
        Route::get('/{id}', [TemplateApiController::class, 'show']);
        Route::put('/{id}', [TemplateApiController::class, 'update']);
        Route::delete('/{id}', [TemplateApiController::class, 'destroy']);
        Route::post('/{id}/toggle-active', [TemplateApiController::class, 'toggleActive']);
    });

    // ----- المستلمين -----
    Route::prefix('recipients')->group(function () {
        Route::get('/', [RecipientApiController::class, 'index']);
        Route::get('/active', [RecipientApiController::class, 'active']);
        Route::post('/', [RecipientApiController::class, 'store']);
        Route::get('/{id}', [RecipientApiController::class, 'show']);
        Route::put('/{id}', [RecipientApiController::class, 'update']);
        Route::delete('/{id}', [RecipientApiController::class, 'destroy']);
        Route::post('/{id}/toggle-active', [RecipientApiController::class, 'toggleActive']);
    });

    // ----- الجهات -----
    Route::prefix('organizations')->group(function () {
        Route::get('/', [OrganizationApiController::class, 'index']);
        Route::get('/active', [OrganizationApiController::class, 'active']);
        Route::post('/', [OrganizationApiController::class, 'store']);
        Route::get('/{id}', [OrganizationApiController::class, 'show']);
        Route::put('/{id}', [OrganizationApiController::class, 'update']);
        Route::delete('/{id}', [OrganizationApiController::class, 'destroy']);
        Route::post('/{id}/toggle-active', [OrganizationApiController::class, 'toggleActive']);
    });

    // ----- صفات المستلمين -----
    Route::prefix('recipient-titles')->group(function () {
        Route::get('/', [RecipientTitleApiController::class, 'index']);
        Route::get('/active', [RecipientTitleApiController::class, 'active']);
        Route::post('/', [RecipientTitleApiController::class, 'store']);
        Route::get('/{id}', [RecipientTitleApiController::class, 'show']);
        Route::put('/{id}', [RecipientTitleApiController::class, 'update']);
        Route::delete('/{id}', [RecipientTitleApiController::class, 'destroy']);
        Route::post('/{id}/toggle-active', [RecipientTitleApiController::class, 'toggleActive']);
    });

    // ----- مواضيع الخطابات -----
    Route::prefix('letter-subjects')->group(function () {
        Route::get('/', [LetterSubjectApiController::class, 'index']);
        Route::get('/active', [LetterSubjectApiController::class, 'active']);
        Route::post('/', [LetterSubjectApiController::class, 'store']);
        Route::get('/{id}', [LetterSubjectApiController::class, 'show']);
        Route::put('/{id}', [LetterSubjectApiController::class, 'update']);
        Route::delete('/{id}', [LetterSubjectApiController::class, 'destroy']);
        Route::post('/{id}/toggle-active', [LetterSubjectApiController::class, 'toggleActive']);
    });

    // ----- الاشتراكات -----
    Route::prefix('subscriptions')->group(function () {
        Route::get('/current', [SubscriptionApiController::class, 'current']);
        Route::get('/plans', [SubscriptionApiController::class, 'plans']);
        Route::post('/subscribe', [SubscriptionApiController::class, 'subscribe']);
        Route::post('/cancel', [SubscriptionApiController::class, 'cancel']);
        Route::get('/history', [SubscriptionApiController::class, 'history']);
    });

    // ----- إدارة المستخدمين (Super Admin فقط) -----
    Route::prefix('users')->group(function () {
        Route::get('/', [UserApiController::class, 'index']);
        Route::get('/companies', [UserApiController::class, 'companies']);
        Route::get('/{id}', [UserApiController::class, 'show']);
        Route::put('/{id}', [UserApiController::class, 'update']);
        Route::delete('/{id}', [UserApiController::class, 'destroy']);
        Route::get('/{id}/activity-log', [UserApiController::class, 'activityLog']);
        Route::put('/{id}/status', [UserApiController::class, 'updateStatus']);
    });
});
