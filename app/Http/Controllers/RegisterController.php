<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Company;
use App\Models\JoinRequest;
use App\Models\Subscription;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class RegisterController extends Controller
{
    /**
     * عرض صفحة التسجيل
     */
    public function index()
    {
        $companies = Company::select('id', 'name')->orderBy('name')->get();
        return view('register', compact('companies'));
    }

    /**
     * تسجيل مستخدم جديد مع شركة جديدة
     */
    public function store(Request $request)
    {
        $registrationType = $request->input('registration_type', 'new_company');

        if ($registrationType === 'new_company') {
            return $this->registerNewCompany($request);
        } else {
            return $this->joinExistingCompany($request);
        }
    }

    /**
     * تسجيل شركة جديدة
     */
    protected function registerNewCompany(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users|max:255',
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
            'name' => $validatedData['company_name'],
            'name_en' => $validatedData['company_name_en'] ?? null,
            'phone' => $validatedData['phone'] ?? null,
            'email' => $validatedData['email'],
            'letter_prefix' => 'OUT',
            'last_letter_number' => 0,
            'setup_completed' => false,
        ]);

        // إنشاء المستخدم كمالك للشركة
        $user = User::create([
            'company_id' => $company->id,
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'phone' => $validatedData['phone'] ?? null,
            'password' => Hash::make($validatedData['password']),
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

        // تسجيل الدخول تلقائياً
        Auth::login($user);

        return redirect()->route('company.setup')->with('success', 'تم التسجيل بنجاح! الرجاء إكمال إعدادات الشركة.');
    }

    /**
     * طلب الانضمام لشركة موجودة
     */
    protected function joinExistingCompany(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|unique:users|max:255',
            'password' => 'required|string|min:8|confirmed',
            'phone' => 'nullable|string|max:20',
            'existing_company_id' => 'required|exists:companies,id',
        ], [
            'name.required' => 'الرجاء إدخال الاسم',
            'email.required' => 'الرجاء إدخال البريد الإلكتروني',
            'email.unique' => 'هذا البريد الإلكتروني مسجل مسبقاً',
            'password.required' => 'الرجاء إدخال كلمة المرور',
            'password.min' => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
            'password.confirmed' => 'كلمة المرور غير متطابقة',
            'existing_company_id.required' => 'الرجاء اختيار الشركة',
            'existing_company_id.exists' => 'الشركة المختارة غير موجودة',
        ]);

        // إنشاء المستخدم بحالة معلقة
        $user = User::create([
            'company_id' => $validatedData['existing_company_id'],
            'name' => $validatedData['name'],
            'email' => $validatedData['email'],
            'phone' => $validatedData['phone'] ?? null,
            'password' => Hash::make($validatedData['password']),
            'role' => 'employee',
            'access_level' => 0,
            'is_company_owner' => false,
            'status' => 'pending',
        ]);

        // إنشاء طلب الانضمام
        JoinRequest::create([
            'user_id' => $user->id,
            'company_id' => $validatedData['existing_company_id'],
            'status' => 'pending',
        ]);

        return redirect()->route('login')->with('info', 'تم إرسال طلب الانضمام للشركة. سيتم إعلامك عند الموافقة على طلبك.');
    }

    /**
     * الحصول على قائمة الشركات للـ API
     */
    public function getCompanies()
    {
        $companies = Company::select('id', 'name')->orderBy('name')->get();
        return response()->json($companies);
    }
}
