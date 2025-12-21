/// إعدادات التطبيق الأساسية
class AppConfig {
  AppConfig._();

  // App Info
  static const String appName = 'منصة الخطابات';
  static const String appNameFull = 'منصة إصدار الخطابات الرسمية';
  static const String appDescription =
      'منصة متكاملة لإصدار وإدارة الخطابات الرسمية للمؤسسات والإدارات والجهات المختلفة';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://emsg.elite-center-ld.com/api';

  // للاختبار على الموبايل استخدم IP الجهاز بدلاً من localhost
  // مثال: 'http://192.168.1.100:8000/api'

  // API Timeout
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // Pagination
  static const int defaultPageSize = 15;
}

/// API Endpoints - مطابقة لـ Laravel API
///
/// Base URL: https://emsg.elite-center-ld.com/api
///
/// الـ Endpoints المتاحة:
///
/// 1. المصادقة (Authentication):
///    - POST /auth/register - تسجيل مستخدم جديد
///    - POST /auth/login - تسجيل الدخول
///    - POST /auth/logout - تسجيل الخروج
///    - GET /auth/user - بيانات المستخدم الحالي
///    - PUT /auth/profile - تحديث الملف الشخصي
///    - PUT /auth/password - تغيير كلمة المرور
///
/// 2. لوحة التحكم (Dashboard):
///    - GET /dashboard - إحصائيات لوحة التحكم
///    - GET /dashboard/quick-stats - إحصائيات سريعة
///
/// 3. الخطابات (Letters):
///    - GET /letters - قائمة الخطابات
///    - GET /letters/create-data - بيانات إنشاء خطاب
///    - GET /letters/statistics - إحصائيات الخطابات
///    - POST /letters - إنشاء خطاب جديد
///    - GET /letters/{id} - عرض خطاب
///    - PUT /letters/{id} - تحديث خطاب
///    - DELETE /letters/{id} - حذف خطاب
///    - POST /letters/{id}/issue - إصدار الخطاب
///    - GET /letters/{id}/pdf - تحميل PDF
///    - GET /letters/{id}/pdf-url - رابط PDF
///    - GET /letters/{id}/share-link - رابط المشاركة
///    - POST /letters/{id}/send-email - إرسال بالبريد
///
/// 4. إعدادات الشركة (Company):
///    - GET /company - بيانات الشركة
///    - PUT /company - تحديث بيانات الشركة
///    - POST /company/logo - رفع الشعار
///    - POST /company/signature - رفع التوقيع
///    - POST /company/stamp - رفع الختم
///    - DELETE /company/logo - حذف الشعار
///    - DELETE /company/signature - حذف التوقيع
///    - DELETE /company/stamp - حذف الختم
///
/// 5. القوالب (Templates):
///    - GET /templates - قائمة القوالب
///    - GET /templates/active - القوالب النشطة
///    - POST /templates - إنشاء قالب
///    - GET /templates/{id} - عرض قالب
///    - PUT /templates/{id} - تحديث قالب
///    - DELETE /templates/{id} - حذف قالب
///    - POST /templates/{id}/toggle-active - تفعيل/إلغاء
///
/// 6. المستلمين (Recipients):
///    - GET /recipients - قائمة المستلمين
///    - GET /recipients/active - المستلمين النشطين
///    - POST /recipients - إضافة مستلم
///    - GET /recipients/{id} - عرض مستلم
///    - PUT /recipients/{id} - تحديث مستلم
///    - DELETE /recipients/{id} - حذف مستلم
///    - POST /recipients/{id}/toggle-active - تفعيل/إلغاء
///
/// 7. الجهات (Organizations):
///    - GET /organizations - قائمة الجهات
///    - GET /organizations/active - الجهات النشطة
///    - POST /organizations - إضافة جهة
///    - GET /organizations/{id} - عرض جهة
///    - PUT /organizations/{id} - تحديث جهة
///    - DELETE /organizations/{id} - حذف جهة
///    - POST /organizations/{id}/toggle-active - تفعيل/إلغاء
///
/// 8. صفات المستلمين (Recipient Titles):
///    - GET /recipient-titles - قائمة الصفات
///    - GET /recipient-titles/active - الصفات النشطة
///    - POST /recipient-titles - إضافة صفة
///    - GET /recipient-titles/{id} - عرض صفة
///    - PUT /recipient-titles/{id} - تحديث صفة
///    - DELETE /recipient-titles/{id} - حذف صفة
///    - POST /recipient-titles/{id}/toggle-active - تفعيل/إلغاء
///
/// 9. مواضيع الخطابات (Letter Subjects):
///    - GET /letter-subjects - قائمة المواضيع
///    - GET /letter-subjects/active - المواضيع النشطة
///    - POST /letter-subjects - إضافة موضوع
///    - GET /letter-subjects/{id} - عرض موضوع
///    - PUT /letter-subjects/{id} - تحديث موضوع
///    - DELETE /letter-subjects/{id} - حذف موضوع
///    - POST /letter-subjects/{id}/toggle-active - تفعيل/إلغاء
///
/// 10. الاشتراكات (Subscriptions):
///    - GET /subscriptions/current - الاشتراك الحالي
///    - GET /subscriptions/plans - الباقات المتاحة
///    - POST /subscriptions/subscribe - الاشتراك في باقة
///    - POST /subscriptions/cancel - إلغاء الاشتراك
///    - GET /subscriptions/history - سجل الاشتراكات
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String user = '/auth/user';
  static const String updateProfile = '/auth/profile';
  static const String changePassword = '/auth/password';

  // Dashboard
  static const String dashboard = '/dashboard';
  static const String quickStats = '/dashboard/quick-stats';

  // Letters
  static const String letters = '/letters';
  static const String lettersCreateData = '/letters/create-data';
  static const String lettersStatistics = '/letters/statistics';
  static String letterById(int id) => '/letters/$id';
  static String issueLetter(int id) => '/letters/$id/issue';
  static String letterPdf(int id) => '/letters/$id/pdf';
  static String letterPdfUrl(int id) => '/letters/$id/pdf-url';
  static String letterShareLink(int id) => '/letters/$id/share-link';
  static String sendLetterEmail(int id) => '/letters/$id/send-email';

  // Company
  static const String company = '/company';
  static const String companyLogo = '/company/logo';
  static const String companySignature = '/company/signature';
  static const String companyStamp = '/company/stamp';
  static const String companyLetterhead = '/company/letterhead';
  static const String companySetupStatus = '/company/setup-status';
  static const String companyCompleteSetup = '/company/complete-setup';

  // Templates
  static const String templates = '/templates';
  static const String templatesActive = '/templates/active';
  static String templateById(int id) => '/templates/$id';
  static String toggleTemplate(int id) => '/templates/$id/toggle-active';

  // Recipients
  static const String recipients = '/recipients';
  static const String recipientsActive = '/recipients/active';
  static String recipientById(int id) => '/recipients/$id';
  static String toggleRecipient(int id) => '/recipients/$id/toggle-active';

  // Organizations
  static const String organizations = '/organizations';
  static const String organizationsActive = '/organizations/active';
  static String organizationById(int id) => '/organizations/$id';
  static String toggleOrganization(int id) =>
      '/organizations/$id/toggle-active';

  // Recipient Titles
  static const String recipientTitles = '/recipient-titles';
  static const String recipientTitlesActive = '/recipient-titles/active';
  static String recipientTitleById(int id) => '/recipient-titles/$id';
  static String toggleRecipientTitle(int id) =>
      '/recipient-titles/$id/toggle-active';

  // Letter Subjects
  static const String letterSubjects = '/letter-subjects';
  static const String letterSubjectsActive = '/letter-subjects/active';
  static String letterSubjectById(int id) => '/letter-subjects/$id';
  static String toggleLetterSubject(int id) =>
      '/letter-subjects/$id/toggle-active';

  // Subscriptions
  static const String subscriptionCurrent = '/subscriptions/current';
  static const String subscriptionPlans = '/subscriptions/plans';
  static const String subscribe = '/subscriptions/subscribe';
  static const String cancelSubscription = '/subscriptions/cancel';
  static const String subscriptionHistory = '/subscriptions/history';
}
