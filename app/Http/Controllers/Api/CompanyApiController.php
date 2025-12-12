<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class CompanyApiController extends Controller
{
    /**
     * الحصول على بيانات الشركة
     */
    public function show()
    {
        $company = Auth::user()->company;

        return response()->json([
            'success' => true,
            'data' => [
                'company' => $company,
                'logo_url' => $company->logo ? Storage::disk('public')->url($company->logo) : null,
                'signature_url' => $company->signature ? Storage::disk('public')->url($company->signature) : null,
                'stamp_url' => $company->stamp ? Storage::disk('public')->url($company->stamp) : null,
            ],
        ]);
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
        ]);

        $company = Auth::user()->company;

        $company->fill($request->only([
            'name', 'name_en', 'address', 'phone', 'email',
            'website', 'commercial_register', 'tax_number', 'letter_prefix'
        ]));

        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث بيانات الشركة بنجاح',
            'data' => $company,
        ]);
    }

    /**
     * رفع الشعار
     */
    public function uploadLogo(Request $request)
    {
        $request->validate([
            'logo' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $company = Auth::user()->company;

        if ($company->logo) {
            Storage::disk('public')->delete($company->logo);
        }

        $company->logo = $request->file('logo')->store('company/logos', 'public');
        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم رفع الشعار بنجاح',
            'data' => [
                'logo_url' => Storage::disk('public')->url($company->logo),
            ],
        ]);
    }

    /**
     * رفع التوقيع
     */
    public function uploadSignature(Request $request)
    {
        $request->validate([
            'signature' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $company = Auth::user()->company;

        if ($company->signature) {
            Storage::disk('public')->delete($company->signature);
        }

        $company->signature = $request->file('signature')->store('company/signatures', 'public');
        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم رفع التوقيع بنجاح',
            'data' => [
                'signature_url' => Storage::disk('public')->url($company->signature),
            ],
        ]);
    }

    /**
     * رفع الختم
     */
    public function uploadStamp(Request $request)
    {
        $request->validate([
            'stamp' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $company = Auth::user()->company;

        if ($company->stamp) {
            Storage::disk('public')->delete($company->stamp);
        }

        $company->stamp = $request->file('stamp')->store('company/stamps', 'public');
        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم رفع الختم بنجاح',
            'data' => [
                'stamp_url' => Storage::disk('public')->url($company->stamp),
            ],
        ]);
    }

    /**
     * حذف الشعار
     */
    public function deleteLogo()
    {
        $company = Auth::user()->company;

        if ($company->logo) {
            Storage::disk('public')->delete($company->logo);
            $company->logo = null;
            $company->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الشعار بنجاح',
        ]);
    }

    /**
     * حذف التوقيع
     */
    public function deleteSignature()
    {
        $company = Auth::user()->company;

        if ($company->signature) {
            Storage::disk('public')->delete($company->signature);
            $company->signature = null;
            $company->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'تم حذف التوقيع بنجاح',
        ]);
    }

    /**
     * حذف الختم
     */
    public function deleteStamp()
    {
        $company = Auth::user()->company;

        if ($company->stamp) {
            Storage::disk('public')->delete($company->stamp);
            $company->stamp = null;
            $company->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الختم بنجاح',
        ]);
    }

    /**
     * الحصول على إعدادات الورق الرسمي
     */
    public function getLetterheadSettings()
    {
        $company = Auth::user()->company;

        return response()->json([
            'success' => true,
            'data' => [
                'letterhead_file' => $company->letterhead_file,
                'letterhead_url' => $company->letterhead_file ? Storage::disk('public')->url($company->letterhead_file) : null,
                'barcode_position' => $company->barcode_position ?? 'right',
                'barcode_top_margin' => $company->barcode_top_margin ?? 20,
                'barcode_side_margin' => $company->barcode_side_margin ?? 15,
                'show_barcode' => $company->show_barcode ?? true,
                'show_reference_number' => $company->show_reference_number ?? true,
                'show_hijri_date' => $company->show_hijri_date ?? true,
                'show_gregorian_date' => $company->show_gregorian_date ?? true,
                'show_subject_in_header' => $company->show_subject_in_header ?? true,
                'setup_completed' => $company->setup_completed ?? false,
            ],
        ]);
    }

    /**
     * تحديث إعدادات الورق الرسمي
     */
    public function updateLetterheadSettings(Request $request)
    {
        $request->validate([
            'barcode_position' => 'required|in:right,left',
            'barcode_top_margin' => 'nullable|integer|min:0|max:100',
            'barcode_side_margin' => 'nullable|integer|min:0|max:100',
            'show_barcode' => 'nullable|boolean',
            'show_reference_number' => 'nullable|boolean',
            'show_hijri_date' => 'nullable|boolean',
            'show_gregorian_date' => 'nullable|boolean',
            'show_subject_in_header' => 'nullable|boolean',
        ]);

        $company = Auth::user()->company;

        $company->barcode_position = $request->barcode_position;
        $company->barcode_top_margin = $request->barcode_top_margin ?? 20;
        $company->barcode_side_margin = $request->barcode_side_margin ?? 15;
        $company->show_barcode = $request->show_barcode ?? true;
        $company->show_reference_number = $request->show_reference_number ?? true;
        $company->show_hijri_date = $request->show_hijri_date ?? true;
        $company->show_gregorian_date = $request->show_gregorian_date ?? true;
        $company->show_subject_in_header = $request->show_subject_in_header ?? true;
        $company->setup_completed = true;

        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث إعدادات الورق الرسمي بنجاح',
            'data' => [
                'barcode_position' => $company->barcode_position,
                'barcode_top_margin' => $company->barcode_top_margin,
                'barcode_side_margin' => $company->barcode_side_margin,
                'show_barcode' => $company->show_barcode,
                'show_reference_number' => $company->show_reference_number,
                'show_hijri_date' => $company->show_hijri_date,
                'show_gregorian_date' => $company->show_gregorian_date,
                'show_subject_in_header' => $company->show_subject_in_header,
                'setup_completed' => $company->setup_completed,
            ],
        ]);
    }

    /**
     * رفع ملف الورق الرسمي
     */
    public function uploadLetterhead(Request $request)
    {
        $request->validate([
            'letterhead_file' => 'required|file|mimes:pdf,jpeg,png,jpg|max:5120',
        ]);

        $company = Auth::user()->company;

        if ($company->letterhead_file) {
            Storage::disk('public')->delete($company->letterhead_file);
        }

        $company->letterhead_file = $request->file('letterhead_file')->store('company/letterheads', 'public');
        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم رفع الورق الرسمي بنجاح',
            'data' => [
                'letterhead_url' => Storage::disk('public')->url($company->letterhead_file),
            ],
        ]);
    }

    /**
     * حذف ملف الورق الرسمي
     */
    public function deleteLetterhead()
    {
        $company = Auth::user()->company;

        if ($company->letterhead_file) {
            Storage::disk('public')->delete($company->letterhead_file);
            $company->letterhead_file = null;
            $company->save();
        }

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الورق الرسمي بنجاح',
        ]);
    }

    /**
     * التحقق من حالة الإعداد الأولي
     */
    public function checkSetupStatus()
    {
        $company = Auth::user()->company;

        return response()->json([
            'success' => true,
            'data' => [
                'setup_completed' => $company->setup_completed ?? false,
                'has_letterhead' => !empty($company->letterhead_file),
                'has_logo' => !empty($company->logo),
                'has_signature' => !empty($company->signature),
                'has_stamp' => !empty($company->stamp),
            ],
        ]);
    }

    /**
     * إكمال الإعداد الأولي (من الموبايل)
     */
    public function completeSetup(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'barcode_position' => 'required|in:right,left',
        ]);

        $company = Auth::user()->company;

        // تحديث البيانات الأساسية
        $company->fill($request->only([
            'name', 'name_en', 'address', 'phone', 'email', 'letter_prefix'
        ]));

        // تحديث إعدادات الباركود
        $company->barcode_position = $request->barcode_position ?? 'right';
        $company->show_barcode = $request->show_barcode ?? true;
        $company->show_reference_number = $request->show_reference_number ?? true;
        $company->show_hijri_date = $request->show_hijri_date ?? true;
        $company->show_gregorian_date = $request->show_gregorian_date ?? true;
        $company->show_subject_in_header = $request->show_subject_in_header ?? true;
        $company->barcode_top_margin = $request->barcode_top_margin ?? 20;
        $company->barcode_side_margin = $request->barcode_side_margin ?? 15;
        $company->setup_completed = true;

        $company->save();

        return response()->json([
            'success' => true,
            'message' => 'تم إكمال الإعداد بنجاح',
            'data' => $company,
        ]);
    }
}
