<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Recipient;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RecipientApiController extends Controller
{
    /**
     * قائمة جميع المستلمين
     */
    public function index(Request $request)
    {
        $query = Recipient::where('company_id', Auth::user()->company_id)
            ->with('recipientTitle');

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%")
                    ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        if ($request->has('active')) {
            $query->where('is_active', $request->boolean('active'));
        }

        $recipients = $query->orderBy('name')->paginate($request->per_page ?? 20);

        return response()->json([
            'success' => true,
            'data' => $recipients,
        ]);
    }

    /**
     * المستلمين النشطين فقط
     */
    public function active()
    {
        $recipients = Recipient::where('company_id', Auth::user()->company_id)
            ->active()
            ->with('recipientTitle')
            ->orderBy('name')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $recipients,
        ]);
    }

    /**
     * إنشاء مستلم جديد
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'recipient_title_id' => 'nullable|exists:recipient_titles,id',
            'organization_id' => 'nullable|exists:organizations,id',
            'email' => 'nullable|email|max:255',
            'phone' => 'nullable|string|max:20',
            'notes' => 'nullable|string',
        ]);

        $recipient = Recipient::create([
            'company_id' => Auth::user()->company_id,
            'name' => $request->name,
            'recipient_title_id' => $request->recipient_title_id,
            'organization_id' => $request->organization_id,
            'email' => $request->email,
            'phone' => $request->phone,
            'notes' => $request->notes,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إضافة المستلم بنجاح',
            'data' => $recipient->load(['recipientTitle', 'organization']),
        ], 201);
    }

    /**
     * عرض مستلم محدد
     */
    public function show($id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->with(['recipientTitle', 'organization'])
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'data' => $recipient,
        ]);
    }

    /**
     * تحديث مستلم
     */
    public function update(Request $request, $id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'required|string|max:255',
            'recipient_title_id' => 'nullable|exists:recipient_titles,id',
            'organization_id' => 'nullable|exists:organizations,id',
            'email' => 'nullable|email|max:255',
            'phone' => 'nullable|string|max:20',
            'notes' => 'nullable|string',
            'is_active' => 'boolean',
        ]);

        $recipient->update($request->only([
            'name', 'recipient_title_id', 'organization_id',
            'email', 'phone', 'notes', 'is_active'
        ]));

        return response()->json([
            'success' => true,
            'message' => 'تم تحديث المستلم بنجاح',
            'data' => $recipient->load(['recipientTitle', 'organization']),
        ]);
    }

    /**
     * حذف مستلم
     */
    public function destroy($id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $recipient->delete();

        return response()->json([
            'success' => true,
            'message' => 'تم حذف المستلم بنجاح',
        ]);
    }

    /**
     * تفعيل/إلغاء تفعيل مستلم
     */
    public function toggleActive($id)
    {
        $recipient = Recipient::where('company_id', Auth::user()->company_id)
            ->findOrFail($id);

        $recipient->update(['is_active' => !$recipient->is_active]);

        return response()->json([
            'success' => true,
            'message' => $recipient->is_active ? 'تم تفعيل المستلم' : 'تم إلغاء تفعيل المستلم',
            'data' => $recipient,
        ]);
    }
}
