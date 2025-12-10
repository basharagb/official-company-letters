<?php

namespace App\Http\Controllers;

use App\Models\Organization;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

/**
 * متحكم إدارة الجهات
 */
class OrganizationController extends Controller
{
    /**
     * عرض قائمة الجهات
     */
    public function index(Request $request)
    {
        $query = Organization::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $query->search($request->search);
        }

        $organizations = $query->orderBy('name')->paginate(20);

        return view('organizations.index', compact('organizations'));
    }

    /**
     * عرض صفحة إنشاء جهة جديدة
     */
    public function create()
    {
        return view('organizations.create');
    }

    /**
     * حفظ جهة جديدة
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'nullable|string|max:500',
            'email' => 'nullable|email|max:255',
            'phone' => 'nullable|string|max:50',
        ]);

        Organization::create([
            'company_id' => Auth::user()->company_id,
            'name' => $request->name,
            'address' => $request->address,
            'email' => $request->email,
            'phone' => $request->phone,
        ]);

        return redirect()->route('organizations.index')
            ->with('success', 'تم إضافة الجهة بنجاح');
    }

    /**
     * عرض صفحة تعديل الجهة
     */
    public function edit($id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return view('organizations.edit', compact('organization'));
    }

    /**
     * تحديث الجهة
     */
    public function update(Request $request, $id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'nullable|string|max:500',
            'email' => 'nullable|email|max:255',
            'phone' => 'nullable|string|max:50',
        ]);

        $organization->update([
            'name' => $request->name,
            'address' => $request->address,
            'email' => $request->email,
            'phone' => $request->phone,
            'is_active' => $request->has('is_active'),
        ]);

        return redirect()->route('organizations.index')
            ->with('success', 'تم تحديث الجهة بنجاح');
    }

    /**
     * حذف الجهة
     */
    public function destroy($id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $organization->delete();

        return redirect()->route('organizations.index')
            ->with('success', 'تم حذف الجهة بنجاح');
    }

    /**
     * API: جلب الجهات للاختيار
     */
    public function getAll()
    {
        $organizations = Organization::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('name')
            ->get(['id', 'name', 'address', 'email']);

        return response()->json($organizations);
    }
}
