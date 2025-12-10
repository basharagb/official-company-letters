<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LetterSubject;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LetterSubjectApiController extends Controller
{
    /**
     * قائمة جميع مواضيع الخطابات
     */
    public function index(Request $request)
    {
        $query = LetterSubject::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $query->where('subject', 'like', "%{$request->search}%");
        }

        if ($request->has('active')) {
            $query->where('is_active', $request->boolean('active'));
        }

        $subjects = $query->orderBy('subject')->paginate($request->per_page ?? 20);

        return response()->json([
            'success' => true,
            'data' => $subjects,
        ]);
    }

    /**
     * المواضيع النشطة فقط
     */
    public function active()
    {
        $subjects = LetterSubject::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('subject')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $subjects,
        ]);
    }

    /**
     * إنشاء موضوع جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'subject' => 'required|string|max:255',
            'default_content' => 'nullable|string',
        ]);

        $subject = LetterSubject::create([
            'company_id' => Auth::user()->company_id,
            'subject' => $request->subject,
            'default_content' => $request->default_content,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إضافة الموضوع بنجاح',
            'data' => $subject,
        ], 201);
    }

    /**
     * عرض موضوع محدد
     */
    public function show($id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $subject,
        ]);
    }

    /**
     * تحديث موضوع
     */
    public function update(Request $request, $id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'subject' => 'required|string|max:255',
            'default_content' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        $subject->update($request->only(['subject', 'default_content', 'is_active']));

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث الموضوع بنجاح',
            'data' => $subject,
        ]);
    }

    /**
     * حذف موضوع
     */
    public function destroy($id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $subject->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الموضوع بنجاح',
        ]);
    }

    /**
     * تفعيل/إلغاء تفعيل موضوع
     */
    public function toggleActive($id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $subject->update(['is_active' => !$subject->is_active]);

        return response()->json([
            'success' => true,
            'message' => $subject->is_active ? 'تم تفعيل الموضوع' : 'تم إلغاء تفعيل الموضوع',
            'data' => $subject,
        ]);
    }
}
