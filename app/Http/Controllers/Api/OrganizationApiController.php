<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Organization;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OrganizationApiController extends Controller
{
    /**
     * قائمة جميع الجهات
     */
    public function index(Request $request)
    {
        $query = Organization::where('company_id', Auth::user()->company_id);

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('address', 'like', "%{$search}%");
            });
        }

        if ($request->has('active')) {
            $query->where('is_active', $request->boolean('active'));
        }

        $organizations = $query->orderBy('name')->paginate($request->per_page ?? 20);

        return response()->json([
            'success' => true,
            'data' => $organizations,
        ]);
    }

    /**
     * الجهات النشطة فقط
     */
    public function active()
    {
        $organizations = Organization::where('company_id', Auth::user()->company_id)
            ->active()
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $organizations,
        ]);
    }

    /**
     * إنشاء جهة جديدة
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'nullable|string|max:500',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'notes' => 'nullable|string',
        ]);

        $organization = Organization::create([
            'company_id' => Auth::user()->company_id,
            'name' => $request->name,
            'address' => $request->address,
            'phone' => $request->phone,
            'email' => $request->email,
            'notes' => $request->notes,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إضافة الجهة بنجاح',
            'data' => $organization,
        ], 201);
    }

    /**
     * عرض جهة محددة
     */
    public function show($id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $organization,
        ]);
    }

    /**
     * تحديث جهة
     */
    public function update(Request $request, $id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'address' => 'nullable|string|max:500',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'notes' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        $organization->update($request->only([
            'name', 'address', 'phone', 'email', 'notes', 'is_active'
        ]));

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث الجهة بنجاح',
            'data' => $organization,
        ]);
    }

    /**
     * حذف جهة
     */
    public function destroy($id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $organization->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف الجهة بنجاح',
        ]);
    }

    /**
     * تفعيل/إلغاء تفعيل جهة
     */
    public function toggleActive($id)
    {
        $organization = Organization::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $organization->update(['is_active' => !$organization->is_active]);

        return response()->json([
            'success' => true,
            'message' => $organization->is_active ? 'تم تفعيل الجهة' : 'تم إلغاء تفعيل الجهة',
            'data' => $organization,
        ]);
    }
}
