<?php

namespace App\Http\Controllers;

use App\Models\RecipientTitle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

/**
 * متحكم إدارة صفات المستلمين
 */
class RecipientTitleController extends Controller
{
    /**
     * عرض قائمة صفات المستلمين
     */
    public function index(Request $request)
    {
        $query = RecipientTitle::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $query->search($request->search);
        }

        $titles = $query->orderBy('title')->paginate(20);

        return view('recipient-titles.index', compact('titles'));
    }

    /**
     * عرض صفحة إنشاء صفة جديدة
     */
    public function create()
    {
        return view('recipient-titles.create');
    }

    /**
     * حفظ صفة جديدة
     */
    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
        ]);

        RecipientTitle::create([
            'company_id' => Auth::user()->company_id,
            'title' => $request->title,
        ]);

        return redirect()->route('recipient-titles.index')
            ->with('success', 'تم إضافة صفة المستلم بنجاح');
    }

    /**
     * عرض صفحة تعديل الصفة
     */
    public function edit($id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return view('recipient-titles.edit', compact('title'));
    }

    /**
     * تحديث الصفة
     */
    public function update(Request $request, $id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'title' => 'required|string|max:255',
        ]);

        $title->update([
            'title' => $request->title,
            'is_active' => $request->has('is_active'),
        ]);

        return redirect()->route('recipient-titles.index')
            ->with('success', 'تم تحديث صفة المستلم بنجاح');
    }

    /**
     * حذف الصفة
     */
    public function destroy($id)
    {
        $title = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $title->delete();

        return redirect()->route('recipient-titles.index')
            ->with('success', 'تم حذف صفة المستلم بنجاح');
    }

    /**
     * API: جلب صفات المستلمين للاختيار
     */
    public function getAll()
    {
        $titles = RecipientTitle::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('title')
            ->get(['id', 'title']);

        return response()->json($titles);
    }
}
