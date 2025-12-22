<?php

namespace App\Http\Controllers;

use App\Models\Company;
use App\Models\User;
use App\Models\Letter;
use App\Models\JoinRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminController extends Controller
{
    /**
     * لوحة تحكم الأدمن الرئيسي
     */
    public function dashboard()
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        $stats = [
            'companies_count' => Company::count(),
            'users_count' => User::count(),
            'letters_count' => Letter::count(),
            'pending_requests' => JoinRequest::where('status', 'pending')->count(),
        ];

        $recentCompanies = Company::with('users')
            ->orderBy('created_at', 'desc')
            ->take(10)
            ->get();

        $recentRequests = JoinRequest::with(['user', 'company'])
            ->where('status', 'pending')
            ->orderBy('created_at', 'desc')
            ->take(10)
            ->get();

        return view('admin.dashboard', compact('stats', 'recentCompanies', 'recentRequests'));
    }

    /**
     * عرض جميع الشركات
     */
    public function companies(Request $request)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        $query = Company::with(['users', 'activeSubscription']);

        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('name_en', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $companies = $query->orderBy('created_at', 'desc')->paginate(20);

        return view('admin.companies', compact('companies'));
    }

    /**
     * عرض تفاصيل شركة معينة
     */
    public function companyDetails(Company $company)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        $company->load(['users', 'activeSubscription', 'letters']);

        return view('admin.company-details', compact('company'));
    }

    /**
     * عرض جميع الخطابات من جميع الشركات
     */
    public function allLetters(Request $request)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        $query = Letter::with(['company', 'author']);

        if ($request->has('company_id') && $request->company_id) {
            $query->where('company_id', $request->company_id);
        }

        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where(function($q) use ($search) {
                $q->where('subject', 'like', "%{$search}%")
                  ->orWhere('reference_number', 'like', "%{$search}%");
            });
        }

        $letters = $query->orderBy('created_at', 'desc')->paginate(20);
        $companies = Company::select('id', 'name')->orderBy('name')->get();

        return view('admin.letters', compact('letters', 'companies'));
    }

    /**
     * عرض جميع المستخدمين
     */
    public function users(Request $request)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        $query = User::with('company');

        if ($request->has('company_id') && $request->company_id) {
            $query->where('company_id', $request->company_id);
        }

        if ($request->has('status') && $request->status) {
            $query->where('status', $request->status);
        }

        if ($request->has('search')) {
            $search = $request->input('search');
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $users = $query->orderBy('created_at', 'desc')->paginate(20);
        $companies = Company::select('id', 'name')->orderBy('name')->get();

        return view('admin.users', compact('users', 'companies'));
    }

    /**
     * عرض صفحة تعديل الشركة
     */
    public function editCompany(Company $company)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        return view('admin.company-edit', compact('company'));
    }

    /**
     * تحديث بيانات الشركة
     */
    public function updateCompany(Request $request, Company $company)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'name_en' => 'nullable|string|max:255',
            'email' => 'required|email|max:255',
            'phone' => 'nullable|string|max:50',
            'address' => 'nullable|string|max:500',
            'website' => 'nullable|url|max:255',
            'commercial_register' => 'nullable|string|max:100',
            'tax_number' => 'nullable|string|max:100',
        ]);

        $company->update($validated);

        return redirect()->route('admin.companies')
            ->with('success', 'تم تحديث بيانات الشركة بنجاح');
    }

    /**
     * حذف الشركة
     */
    public function deleteCompany(Company $company)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }

        // حذف جميع البيانات المرتبطة
        $company->letters()->delete();
        $company->templates()->delete();
        $company->subscriptions()->delete();
        $company->users()->delete();
        
        // حذف الشركة
        $company->delete();

        return redirect()->route('admin.companies')
            ->with('success', 'تم حذف الشركة وجميع بياناتها بنجاح');
    }
}
