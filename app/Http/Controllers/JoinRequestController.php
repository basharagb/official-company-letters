<?php

namespace App\Http\Controllers;

use App\Models\JoinRequest;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class JoinRequestController extends Controller
{
    /**
     * عرض طلبات الانضمام للشركة
     */
    public function index()
    {
        $user = Auth::user();
        
        // الأدمن الرئيسي يرى جميع الطلبات
        if ($user->isSuperAdmin()) {
            $requests = JoinRequest::with(['user', 'company', 'approver'])
                ->orderBy('created_at', 'desc')
                ->paginate(20);
        } else {
            // مالك الشركة يرى طلبات شركته فقط
            $requests = JoinRequest::with(['user', 'company', 'approver'])
                ->where('company_id', $user->company_id)
                ->orderBy('created_at', 'desc')
                ->paginate(20);
        }

        return view('join-requests.index', compact('requests'));
    }

    /**
     * الموافقة على طلب الانضمام
     */
    public function approve(JoinRequest $joinRequest)
    {
        $user = Auth::user();

        // التحقق من الصلاحية
        if (!$user->isSuperAdmin() && !($user->isCompanyOwner() && $user->company_id == $joinRequest->company_id)) {
            return back()->with('error', 'ليس لديك صلاحية للموافقة على هذا الطلب');
        }

        // تحديث حالة الطلب
        $joinRequest->update([
            'status' => 'approved',
            'approved_by' => $user->id,
        ]);

        // تحديث حالة المستخدم
        $joinRequest->user->update([
            'status' => 'approved',
        ]);

        return back()->with('success', 'تم الموافقة على طلب الانضمام بنجاح');
    }

    /**
     * رفض طلب الانضمام
     */
    public function reject(Request $request, JoinRequest $joinRequest)
    {
        $user = Auth::user();

        // التحقق من الصلاحية
        if (!$user->isSuperAdmin() && !($user->isCompanyOwner() && $user->company_id == $joinRequest->company_id)) {
            return back()->with('error', 'ليس لديك صلاحية لرفض هذا الطلب');
        }

        $reason = $request->input('rejection_reason', '');

        // تحديث حالة الطلب
        $joinRequest->update([
            'status' => 'rejected',
            'approved_by' => $user->id,
            'rejection_reason' => $reason,
        ]);

        // تحديث حالة المستخدم
        $joinRequest->user->update([
            'status' => 'rejected',
        ]);

        return back()->with('success', 'تم رفض طلب الانضمام');
    }
}
