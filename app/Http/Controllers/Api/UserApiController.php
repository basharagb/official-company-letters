<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Company;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class UserApiController extends Controller
{
    /**
     * Get all users (Super Admin only)
     */
    public function index(Request $request)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $query = User::with('company');

        // Filter by company
        if ($request->has('company_id') && $request->company_id) {
            $query->where('company_id', $request->company_id);
        }

        // Filter by status
        if ($request->has('status') && $request->status) {
            $query->where('status', $request->status);
        }

        // Search
        if ($request->has('search') && $request->search) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $perPage = $request->input('per_page', 20);
        $users = $query->orderBy('created_at', 'desc')->paginate($perPage);

        return response()->json([
            'success' => true,
            'data' => $users
        ]);
    }

    /**
     * Get user details
     */
    public function show($id)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $targetUser = User::with(['company', 'letters' => function($query) {
            $query->orderBy('created_at', 'desc')->take(10);
        }])->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $targetUser
        ]);
    }

    /**
     * Update user
     */
    public function update(Request $request, $id)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $targetUser = User::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => ['required', 'email', Rule::unique('users')->ignore($targetUser->id)],
            'phone' => 'nullable|string|max:50',
            'job_title' => 'nullable|string|max:255',
            'role' => 'nullable|in:admin,manager,user',
            'status' => 'nullable|in:approved,pending,rejected',
            'is_company_owner' => 'nullable|boolean',
        ]);

        // Update password if provided
        if ($request->filled('password')) {
            $validated['password'] = Hash::make($request->password);
        }

        $targetUser->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث بيانات المستخدم بنجاح',
            'data' => $targetUser->fresh(['company'])
        ]);
    }

    /**
     * Delete user
     */
    public function destroy($id)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $targetUser = User::findOrFail($id);

        // Prevent deleting super admin
        if ($targetUser->is_super_admin) {
            return response()->json([
                'success' => false,
                'message' => 'لا يمكن حذف مستخدم Super Admin'
            ], 403);
        }

        // Prevent deleting yourself
        if ($targetUser->id === $user->id) {
            return response()->json([
                'success' => false,
                'message' => 'لا يمكنك حذف حسابك الخاص'
            ], 403);
        }

        $targetUser->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف المستخدم بنجاح'
        ]);
    }

    /**
     * Get user activity log
     */
    public function activityLog($id)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $targetUser = User::findOrFail($id);

        // Get user's letters as activity
        $letters = $targetUser->letters()
            ->with('company')
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        $activities = collect($letters->items())->map(function($letter) {
            return [
                'id' => $letter->id,
                'type' => 'letter',
                'action' => $letter->status === 'issued' ? 'أصدر خطاب' : 'أنشأ مسودة خطاب',
                'description' => $letter->subject,
                'reference_number' => $letter->reference_number,
                'company' => $letter->company ? $letter->company->name : null,
                'created_at' => $letter->created_at->format('Y-m-d H:i:s'),
                'date_hijri' => $letter->date_hijri,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => [
                'user' => $targetUser,
                'activities' => $activities,
                'pagination' => [
                    'current_page' => $letters->currentPage(),
                    'last_page' => $letters->lastPage(),
                    'per_page' => $letters->perPage(),
                    'total' => $letters->total(),
                ]
            ]
        ]);
    }

    /**
     * Get companies list for filter
     */
    public function companies()
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $companies = Company::select('id', 'name')->orderBy('name')->get();

        return response()->json([
            'success' => true,
            'data' => $companies
        ]);
    }

    /**
     * Update user status
     */
    public function updateStatus(Request $request, $id)
    {
        $user = Auth::user();

        if (!$user->isSuperAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'ليس لديك صلاحية الوصول'
            ], 403);
        }

        $targetUser = User::findOrFail($id);

        $validated = $request->validate([
            'status' => 'required|in:approved,pending,rejected'
        ]);

        $targetUser->update($validated);

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث حالة المستخدم بنجاح',
            'data' => $targetUser->fresh(['company'])
        ]);
    }
}
