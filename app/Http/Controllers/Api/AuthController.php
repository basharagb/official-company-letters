<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Company;
use App\Models\JoinRequest;
use App\Models\Subscription;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Carbon\Carbon;

class AuthController extends Controller
{
    /**
     * تسجيل مستخدم جديد مع شركة جديدة
     */
    public function register(Request $request)
    {
        $registrationType = $request->input('registration_type', 'new_company');

        if ($registrationType === 'join_company') {
            return $this->joinExistingCompany($request);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'nullable|string|max:20',
            'company_name' => 'required|string|max:255',
            'company_name_en' => 'nullable|string|max:255',
        ], [
            'name.required' => 'الرجاء إدخال الاسم',
            'email.required' => 'الرجاء إدخال البريد الإلكتروني',
            'email.unique' => 'هذا البريد الإلكتروني مسجل مسبقاً',
            'password.required' => 'الرجاء إدخال كلمة المرور',
            'password.min' => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
            'password.confirmed' => 'كلمة المرور غير متطابقة',
            'company_name.required' => 'الرجاء إدخال اسم الشركة',
        ]);

        // إنشاء الشركة
        $company = Company::create([
            'name' => $request->company_name,
            'name_en' => $request->company_name_en,
            'phone' => $request->phone,
            'email' => $request->email,
            'letter_prefix' => 'OUT',
            'last_letter_number' => 0,
            'setup_completed' => false,
        ]);

        // إنشاء المستخدم كمالك للشركة
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'company_id' => $company->id,
            'role' => 'admin',
            'access_level' => 1,
            'is_company_owner' => true,
            'status' => 'approved',
        ]);

        // إنشاء اشتراك تجريبي
        Subscription::create([
            'company_id' => $company->id,
            'type' => 'trial',
            'price' => 0,
            'start_date' => Carbon::now(),
            'end_date' => Carbon::now()->addMonth(),
            'status' => 'active',
            'letters_limit' => 50,
            'letters_used' => 0,
        ]);

        $token = $user->createToken('mobile-app')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'تم التسجيل بنجاح',
            'data' => [
                'user' => $user->load('company'),
                'token' => $token,
            ],
        ], 201);
    }

    /**
     * طلب الانضمام لشركة موجودة
     */
    protected function joinExistingCompany(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'nullable|string|max:20',
            'company_id' => 'required|exists:companies,id',
        ], [
            'name.required' => 'الرجاء إدخال الاسم',
            'email.required' => 'الرجاء إدخال البريد الإلكتروني',
            'email.unique' => 'هذا البريد الإلكتروني مسجل مسبقاً',
            'password.required' => 'الرجاء إدخال كلمة المرور',
            'password.min' => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
            'password.confirmed' => 'كلمة المرور غير متطابقة',
            'company_id.required' => 'الرجاء اختيار الشركة',
            'company_id.exists' => 'الشركة المختارة غير موجودة',
        ]);

        // إنشاء المستخدم بحالة معلقة
        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'company_id' => $request->company_id,
            'role' => 'employee',
            'access_level' => 0,
            'is_company_owner' => false,
            'status' => 'pending',
        ]);

        // إنشاء طلب الانضمام
        JoinRequest::create([
            'user_id' => $user->id,
            'company_id' => $request->company_id,
            'status' => 'pending',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إرسال طلب الانضمام للشركة. سيتم إعلامك عند الموافقة على طلبك.',
            'data' => [
                'user' => $user,
                'status' => 'pending',
            ],
        ], 201);
    }

    /**
     * الحصول على قائمة الشركات المتاحة
     */
    public function getCompanies()
    {
        $companies = Company::select('id', 'name')->orderBy('name')->get();
        return response()->json([
            'success' => true,
            'data' => $companies,
        ]);
    }

    /**
     * تسجيل الدخول
     */
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if (!Auth::attempt($request->only('email', 'password'))) {
            throw ValidationException::withMessages([
                'email' => ['البيانات المدخلة غير صحيحة'],
            ]);
        }

        $user = User::where('email', $request->email)->first();

        // التحقق من حالة المستخدم
        if ($user->status === 'pending') {
            return response()->json([
                'success' => false,
                'message' => 'حسابك في انتظار الموافقة من مالك الشركة',
            ], 403);
        }

        if ($user->status === 'rejected') {
            return response()->json([
                'success' => false,
                'message' => 'تم رفض طلب انضمامك للشركة',
            ], 403);
        }
        
        // حذف التوكنات القديمة
        $user->tokens()->delete();
        
        $token = $user->createToken('mobile-app')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'تم تسجيل الدخول بنجاح',
            'data' => [
                'user' => $user->load('company'),
                'token' => $token,
                'is_super_admin' => $user->isSuperAdmin(),
                'is_company_owner' => $user->isCompanyOwner(),
            ],
        ]);
    }

    /**
     * تسجيل الخروج
     */
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم تسجيل الخروج بنجاح',
        ]);
    }

    /**
     * الحصول على بيانات المستخدم الحالي
     */
    public function user(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => $request->user()->load('company'),
        ]);
    }

    /**
     * تحديث الملف الشخصي
     */
    public function updateProfile(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $request->user()->id,
        ]);

        $request->user()->update($request->only('name', 'email'));

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث الملف الشخصي بنجاح',
            'data' => $request->user(),
        ]);
    }

    /**
     * تغيير كلمة المرور
     */
    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = $request->user();

        if (!Hash::check($request->current_password, $user->password)) {
            throw ValidationException::withMessages([
                'current_password' => ['كلمة المرور الحالية غير صحيحة'],
            ]);
        }

        $user->update([
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم تغيير كلمة المرور بنجاح',
        ]);
    }
}
