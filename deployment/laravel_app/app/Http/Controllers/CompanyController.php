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

    /**
     * عرض صفحة إعدادات الورق الرسمي
     */
    public function letterheadSettings()
    {
        $company = Auth::user()->company;
        return view('company.letterhead-settings', compact('company'));
    }

    /**
     * تحديث إعدادات الورق الرسمي
     */
    public function updateLetterhead(Request $request)
    {
        $request->validate([
            'letterhead_file' => 'nullable|file|mimes:pdf,jpeg,png,jpg|max:5120',
            'barcode_position' => 'required|in:right,left',
            'barcode_top_margin' => 'required|integer|min:0|max:100',
            'barcode_side_margin' => 'required|integer|min:0|max:100',
        ]);

        $company = Auth::user()->company;

        // حذف الورق الرسمي إذا طُلب
        if ($request->input('delete_letterhead') == '1') {
            if ($company->letterhead_file) {
                Storage::disk('public')->delete($company->letterhead_file);
                $company->letterhead_file = null;
            }
        }

        // رفع ملف الورق الرسمي الجديد
        if ($request->hasFile('letterhead_file')) {
            if ($company->letterhead_file) {
                Storage::disk('public')->delete($company->letterhead_file);
            }
            $company->letterhead_file = $request->file('letterhead_file')->store('company/letterheads', 'public');
        }

        // تحديث الإعدادات
        $company->barcode_position = $request->barcode_position;
        $company->show_barcode = $request->has('show_barcode');
        $company->show_reference_number = $request->has('show_reference_number');
        $company->show_hijri_date = $request->has('show_hijri_date');
        $company->show_gregorian_date = $request->has('show_gregorian_date');
        $company->show_subject_in_header = $request->has('show_subject_in_header');
        $company->barcode_top_margin = $request->barcode_top_margin;
        $company->barcode_side_margin = $request->barcode_side_margin;
        $company->setup_completed = true;

        $company->save();

        return redirect()->back()->with('success', 'تم تحديث إعدادات الورق الرسمي بنجاح');
    }

    /**
     * عرض صفحة الإعداد الأولي
     */
    public function setup(Request $request)
    {
        $company = Auth::user()->company;
        $step = $request->get('step', 1);
        
        // إذا كان الإعداد مكتمل، توجيه للوحة التحكم
        if ($company && $company->setup_completed) {
            return redirect()->route('dashboard');
        }
        
        return view('company.setup', compact('company', 'step'));
    }

    /**
     * حفظ الخطوة 1 - البيانات الأساسية
     */
    public function setupStep1(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'name_en' => 'nullable|string|max:255',
            'address' => 'nullable|string|max:500',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'letter_prefix' => 'nullable|string|max:10',
            'logo' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'signature' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
            'stamp' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $company = Auth::user()->company;
        
        if (!$company) {
            $company = Company::create([
                'name' => $request->name,
                'letter_prefix' => $request->letter_prefix ?? 'OUT',
            ]);
            Auth::user()->update(['company_id' => $company->id, 'role' => 'admin']);
        }

        $company->fill($request->only([
            'name', 'name_en', 'address', 'phone', 'email', 'letter_prefix'
        ]));

        // رفع الملفات
        if ($request->hasFile('logo')) {
            if ($company->logo) Storage::disk('public')->delete($company->logo);
            $company->logo = $request->file('logo')->store('company/logos', 'public');
        }
        if ($request->hasFile('signature')) {
            if ($company->signature) Storage::disk('public')->delete($company->signature);
            $company->signature = $request->file('signature')->store('company/signatures', 'public');
        }
        if ($request->hasFile('stamp')) {
            if ($company->stamp) Storage::disk('public')->delete($company->stamp);
            $company->stamp = $request->file('stamp')->store('company/stamps', 'public');
        }

        $company->save();

        return redirect()->route('company.setup', ['step' => 2]);
    }

    /**
     * حفظ الخطوة 2 - الورق الرسمي
     */
    public function setupStep2(Request $request)
    {
        $company = Auth::user()->company;

        if ($request->has('skip')) {
            return redirect()->route('company.setup', ['step' => 3]);
        }

        if ($request->hasFile('letterhead_file')) {
            $request->validate([
                'letterhead_file' => 'file|mimes:pdf,jpeg,png,jpg|max:5120',
            ]);
            
            if ($company->letterhead_file) {
                Storage::disk('public')->delete($company->letterhead_file);
            }
            $company->letterhead_file = $request->file('letterhead_file')->store('company/letterheads', 'public');
            $company->save();
        }

        return redirect()->route('company.setup', ['step' => 3]);
    }

    /**
     * حفظ الخطوة 3 - إعدادات الباركود وإنهاء الإعداد
     */
    public function setupStep3(Request $request)
    {
        $company = Auth::user()->company;

        $company->barcode_position = $request->barcode_position ?? 'right';
        $company->show_barcode = $request->has('show_barcode');
        $company->show_reference_number = $request->has('show_reference_number');
        $company->show_hijri_date = $request->has('show_hijri_date');
        $company->show_gregorian_date = $request->has('show_gregorian_date');
        $company->show_subject_in_header = $request->has('show_subject_in_header');
        $company->setup_completed = true;

        $company->save();

        return redirect()->route('dashboard')->with('success', 'تم إعداد الشركة بنجاح! يمكنك الآن البدء بإنشاء الخطابات.');
    }
}
