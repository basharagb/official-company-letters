<?php

namespace App\Http\Controllers;

use App\Models\Letter;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    public function index()
    {
        $user = Auth::user();
        $companyId = $user->company_id;

        // إحصائيات
        $stats = [
            'total' => Letter::where('company_id', $companyId)->count(),
            'draft' => Letter::where('company_id', $companyId)->where('status', 'draft')->count(),
            'issued' => Letter::where('company_id', $companyId)->where('status', 'issued')->count(),
            'sent' => Letter::where('company_id', $companyId)->where('status', 'sent')->count(),
        ];

        // آخر الخطابات
        $recentLetters = Letter::where('company_id', $companyId)
            ->with('author')
            ->orderBy('created_at', 'desc')
            ->limit(10)
            ->get();

        // خطابات المستخدم
        $myLetters = Letter::where('author_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        return view('dashboard', compact('stats', 'recentLetters', 'myLetters'));
    }
}