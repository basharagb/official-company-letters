<?php

namespace App\Http\Controllers;

use App\Models\LetterTemplate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class TemplateController extends Controller
{
    /**
     * عرض قائمة القوالب
     */
    public function index()
    {
        $templates = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->orderBy('created_at', 'desc')
            ->get();

        return view('templates.index', compact('templates'));
    }

    /**
     * عرض صفحة إنشاء قالب جديد
     */
    public function create()
    {
        return view('templates.create');
    }

    /**
     * حفظ قالب جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'content' => 'required|string',
            'category' => 'nullable|string|max:100',
        ]);

        LetterTemplate::create([
            'company_id' => Auth::user()->company_id,
            'name' => $request->name,
            'content' => $request->content,
            'category' => $request->category,
            'styles' => $request->styles ?? [],
            'is_active' => true,
        ]);

        return redirect()->route('templates.index')
            ->with('success', 'تم إنشاء القالب بنجاح');
    }

    /**
     * عرض صفحة تعديل القالب
     */
    public function edit($id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return view('templates.edit', compact('template'));
    }

    /**
     * تحديث القالب
     */
    public function update(Request $request, $id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $template->update([
            'name' => $request->name,
            'content' => $request->content,
            'category' => $request->category,
            'styles' => $request->styles ?? $template->styles,
            'is_active' => $request->has('is_active'),
        ]);

        return redirect()->route('templates.index')
            ->with('success', 'تم تحديث القالب بنجاح');
    }

    /**
     * حذف القالب
     */
    public function destroy($id)
    {
        $template = LetterTemplate::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $template->delete();

        return redirect()->route('templates.index')
            ->with('success', 'تم حذف القالب بنجاح');
    }
}
