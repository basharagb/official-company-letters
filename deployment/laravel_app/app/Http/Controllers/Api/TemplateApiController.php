<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LetterTemplate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TemplateApiController extends Controller
{
    /**
     * قائمة جميع القوالب
     */
    public function index()
    {
        $templates = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $templates,
        ]);
    }

    /**
     * القوالب النشطة فقط
     */
    public function active()
    {
        $templates = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->where('is_active', true)
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $templates,
        ]);
    }

    /**
     * إنشاء قالب جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'content' => 'nullable|string',
            'styles' => 'nullable|array',
            'is_active' => 'boolean',
        ]);

        $template = LetterTemplate::create([
            'company_id' => Auth::user()->company_id,
            'name' => $request->name,
            'content' => $request->content,
            'styles' => $request->styles ?? [],
            'is_active' => $request->is_active ?? true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إنشاء القالب بنجاح',
            'data' => $template,
        ], 201);
    }

    /**
     * عرض قالب محدد
     */
    public function show($id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $template,
        ]);
    }

    /**
     * تحديث قالب
     */
    public function update(Request $request, $id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'content' => 'nullable|string',
            'styles' => 'nullable|array',
            'is_active' => 'boolean',
        ]);

        $template->update($request->only(['name', 'content', 'styles', 'is_active']));

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث القالب بنجاح',
            'data' => $template,
        ]);
    }

    /**
     * حذف قالب
     */
    public function destroy($id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $template->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف القالب بنجاح',
        ]);
    }

    /**
     * تفعيل/إلغاء تفعيل قالب
     */
    public function toggleActive($id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $template->update(['is_active' => !$template->is_active]);

        return response()->json([
            'success' => true,
            'message' => $template->is_active ? 'تم تفعيل القالب' : 'تم إلغاء تفعيل القالب',
            'data' => $template,
        ]);
    }
}
