<?php

namespace App\Http\Controllers;

use App\Models\Recipient;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

/**
 * متحكم إدارة المستلمين
 */
class RecipientController extends Controller
{
    /**
     * عرض قائمة المستلمين
     */
    public function index(Request $request)
    {
        $query = Recipient::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $query->search($request->search);
        }

        $recipients = $query->orderBy('name')->paginate(20);

        return view('recipients.index', compact('recipients'));
    }

    /**
     * عرض صفحة إنشاء مستلم جديد
     */
    public function create()
    {
        return view('recipients.create');
    }

    /**
     * حفظ مستلم جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'title' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255',
            'phone' => 'nullable|string|max:50',
        ]);

        Recipient::create([
            'company_id' => Auth::user()->company_id,
            'name' => $request->name,
            'title' => $request->title,
            'email' => $request->email,
            'phone' => $request->phone,
        ]);

        return redirect()->route('recipients.index')
            ->with('success', 'تم إضافة المستلم بنجاح');
    }

    /**
     * عرض صفحة تعديل المستلم
     */
    public function edit($id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return view('recipients.edit', compact('recipient'));
    }

    /**
     * تحديث المستلم
     */
    public function update(Request $request, $id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'title' => 'nullable|string|max:255',
            'email' => 'nullable|email|max:255',
            'phone' => 'nullable|string|max:50',
        ]);

        $recipient->update([
            'name' => $request->name,
            'title' => $request->title,
            'email' => $request->email,
            'phone' => $request->phone,
            'is_active' => $request->has('is_active'),
        ]);

        return redirect()->route('recipients.index')
            ->with('success', 'تم تحديث المستلم بنجاح');
    }

    /**
     * حذف المستلم
     */
    public function destroy($id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $recipient->delete();

        return redirect()->route('recipients.index')
            ->with('success', 'تم حذف المستلم بنجاح');
    }

    /**
     * API: جلب المستلمين للاختيار
     */
    public function getAll()
    {
        $recipients = Recipient::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('name')
            ->get(['id', 'name', 'title', 'email']);

        return response()->json($recipients);
    }
}
