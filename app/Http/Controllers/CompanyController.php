<?php

namespace App\Http\Controllers;

use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class CompanyController extends Controller
{
    /**
     * عرض صفحة إعدادات الشركة
     */
    public function settings()
    {
        $company = Auth::user()->company;
        return view('company.settings', compact('company'));
    }

    /**
     * تحديث بيانات الشركة
     */
    public function update(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'name_en' => 'nullable|string|max:255',
            'address' => 'nullable|string|max:500',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'website' => 'nullable|url|max:255',
            'commercial_register' => 'nullable|string|max:50',
            'tax_number' => 'nullable|string|max:50',
            'letter_prefix' => 'nullable|string|max:10',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'signature' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'stamp' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $company = Auth::user()->company;

        // تحديث البيانات الأساسية
        $company->fill($request->only([
            'name', 'name_en', 'address', 'phone', 'email',
            'website', 'commercial_register', 'tax_number', 'letter_prefix'
        ]));

        // رفع الشعار
        if ($request->hasFile('logo')) {
            if ($company->logo) {
                Storage::disk('public')->delete($company->logo);
            }
            $company->logo = $request->file('logo')->store('company/logos', 'public');
        }

        // رفع التوقيع
        if ($request->hasFile('signature')) {
            if ($company->signature) {
                Storage::disk('public')->delete($company->signature);
            }
            $company->signature = $request->file('signature')->store('company/signatures', 'public');
        }

        // رفع الختم
        if ($request->hasFile('stamp')) {
            if ($company->stamp) {
                Storage::disk('public')->delete($company->stamp);
            }
            $company->stamp = $request->file('stamp')->store('company/stamps', 'public');
        }

        $company->save();

        return redirect()->back()->with('success', 'تم تحديث بيانات الشركة بنجاح');
    }

    /**
     * إنشاء شركة جديدة (للتسجيل الأول)
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
        ]);

        $company = Company::create([
            'name' => $request->name,
            'letter_prefix' => 'OUT',
        ]);

        // ربط المستخدم بالشركة
        Auth::user()->update(['company_id' => $company->id, 'role' => 'admin']);

        return redirect()->route('company.settings')->with('success', 'تم إنشاء الشركة بنجاح');
    }
}
