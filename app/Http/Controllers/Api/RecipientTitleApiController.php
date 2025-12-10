<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\RecipientTitle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RecipientTitleApiController extends Controller
{
    /**
     * قائمة جميع صفات المستلمين
     */
    public function index(Request $request)
    {
        $query = RecipientTitle::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $query->where('title', 'like', "%{$request->search}%");
        }

        if ($request->has('active')) {
            $query->where('is_active', $request->boolean('active'));
        }

        $titles = $query->orderBy('title')->paginate($request->per_page ?? 20);

        return response()->json([
            'success' => true,
            'data' => $titles,
        ]);
    }

    /**
     * الصفات النشطة فقط
     */
    public function active()
    {
        $titles = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('title')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $titles,
        ]);
    }

    /**
     * إنشاء صفة جديدة
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
        ]);

        $title = RecipientTitle::create([
            'company_id' => Auth::user()->company_id,
            'title' => $request->title,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إضافة الصفة بنجاح',
            'data' => $title,
        ], 201);
    }

    /**
     * عرض صفة محددة
     */
    public function show($id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $title,
        ]);
    }

    /**
     * تحديث صفة
     */
    public function update(Request $request, $id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
            'is_active' => 'boolean',
        ]);

        $title->update($request->only(['title', 'is_active']));

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث الصفة بنجاح',
            'data' => $title,
        ]);
    }

    /**
     * حذف صفة
     */
    public function destroy($id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $title->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الصفة بنجاح',
        ]);
    }

    /**
     * تفعيل/إلغاء تفعيل صفة
     */
    public function toggleActive($id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $title->update(['is_active' => !$title->is_active]);

        return response()->json([
            'success' => true,
            'message' => $title->is_active ? 'تم تفعيل الصفة' : 'تم إلغاء تفعيل الصفة',
            'data' => $title,
        ]);
    }
}
