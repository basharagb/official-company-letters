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
}
