<?php

namespace App\Http\Controllers;

use App\Models\LetterSubject;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

/**
 * متحكم إدارة مواضيع الخطابات
 */
class LetterSubjectController extends Controller
{
    /**
     * عرض قائمة مواضيع الخطابات
     */
    public function index(Request $request)
    {
        $query = LetterSubject::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $query->search($request->search);
        }

        $subjects = $query->orderBy('subject')->paginate(20);

        return view('letter-subjects.index', compact('subjects'));
    }

    /**
     * عرض صفحة إنشاء موضوع جديد
     */
    public function create()
    {
        return view('letter-subjects.create');
    }

    /**
     * حفظ موضوع جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'subject' => 'required|string|max:255',
            'category' => 'nullable|string|max:100',
        ]);

        LetterSubject::create([
            'company_id' => Auth::user()->company_id,
            'subject' => $request->subject,
            'category' => $request->category,
        ]);

        return redirect()->route('letter-subjects.index')
            ->with('success', 'تم إضافة موضوع الخطاب بنجاح');
    }

    /**
     * عرض صفحة تعديل الموضوع
     */
    public function edit($id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return view('letter-subjects.edit', compact('subject'));
    }

    /**
     * تحديث الموضوع
     */
    public function update(Request $request, $id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'subject' => 'required|string|max:255',
            'category' => 'nullable|string|max:100',
        ]);

        $subject->update([
            'subject' => $request->subject,
            'category' => $request->category,
            'is_active' => $request->has('is_active'),
        ]);

        return redirect()->route('letter-subjects.index')
            ->with('success', 'تم تحديث موضوع الخطاب بنجاح');
    }

    /**
     * حذف الموضوع
     */
    public function destroy($id)
    {
        $subject = LetterSubject::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $subject->delete();

        return redirect()->route('letter-subjects.index')
            ->with('success', 'تم حذف موضوع الخطاب بنجاح');
    }

    /**
     * API: جلب مواضيع الخطابات للاختيار
     */
    public function getAll()
    {
        $subjects = LetterSubject::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('subject')
            ->get(['id', 'subject', 'category']);

        return response()->json($subjects);
    }
}
