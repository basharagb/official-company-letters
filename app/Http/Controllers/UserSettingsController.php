<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use App\Models\User;

class UserSettingsController extends Controller
{
    public function index()
    {
        return view('user.settings');
    }

    public function updateProfile(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . auth()->id(),
            'phone' => 'nullable|string|max:20',
            'job_title' => 'nullable|string|max:100',
        ]);

        $user = auth()->user();
        $user->update([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'job_title' => $request->job_title,
        ]);

        return redirect()->route('user.settings')->with('success', 'تم تحديث البيانات بنجاح');
    }

    public function changePassword(Request $request)
    {
        $request->validate([
            'current_password' => 'required',
            'new_password' => 'required|min:8|confirmed',
        ]);

        $user = auth()->user();

        if (!Hash::check($request->current_password, $user->password)) {
            return back()->withErrors(['current_password' => 'كلمة المرور الحالية غير صحيحة']);
        }

        $user->update([
            'password' => Hash::make($request->new_password),
        ]);

        return redirect()->route('user.settings')->with('success', 'تم تغيير كلمة المرور بنجاح');
    }

    public function deleteAccount(Request $request)
    {
        $request->validate([
            'password' => 'required',
        ]);

        $user = auth()->user();

        // التحقق من كلمة المرور
        if (!Hash::check($request->password, $user->password)) {
            return back()->withErrors(['password' => 'كلمة المرور غير صحيحة']);
        }

        // منع حذف Super Admin
        if ($user->is_super_admin) {
            return back()->withErrors(['error' => 'لا يمكن حذف حساب Super Admin']);
        }

        // منع حذف مالك الشركة إذا كان لديه موظفين
        if ($user->is_company_owner && $user->company) {
            $employeesCount = User::where('company_id', $user->company_id)
                ->where('id', '!=', $user->id)
                ->count();
            
            if ($employeesCount > 0) {
                return back()->withErrors(['error' => 'لا يمكن حذف الحساب لأنك مالك شركة ولديك موظفين. يرجى نقل ملكية الشركة أولاً.']);
            }
        }

        // تسجيل الخروج
        Auth::logout();

        // حذف الحساب
        $user->delete();

        return redirect()->route('login')->with('success', 'تم حذف الحساب بنجاح');
    }
}
