<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Letter;
use App\Models\Subscription;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class DashboardApiController extends Controller
{
    /**
     * إحصائيات لوحة التحكم
     */
    public function index()
    {
        $companyId = Auth::user()->company_id;

        // إحصائيات الخطابات
        $lettersStats = [
            'total' => Letter::where('company_id', $companyId)->count(),
            'draft' => Letter::where('company_id', $companyId)->where('status', 'draft')->count(),
            'issued' => Letter::where('company_id', $companyId)->where('status', 'issued')->count(),
            'sent' => Letter::where('company_id', $companyId)->where('status', 'sent')->count(),
            'this_month' => Letter::where('company_id', $companyId)
                ->whereMonth('created_at', now()->month)
                ->whereYear('created_at', now()->year)
                ->count(),
            'this_year' => Letter::where('company_id', $companyId)
                ->whereYear('created_at', now()->year)
                ->count(),
        ];

        // آخر الخطابات
        $recentLetters = Letter::where('company_id', $companyId)
            ->with('author')
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        // حالة الاشتراك
        $subscription = Subscription::where('company_id', $companyId)
            ->where('status', 'active')
            ->first();

        $subscriptionStatus = null;
        if ($subscription) {
            $subscriptionStatus = [
                'plan' => $subscription->plan,
                'is_active' => $subscription->isValid(),
                'remaining_letters' => $subscription->remainingLetters(),
                'days_remaining' => $subscription->daysRemaining(),
                'end_date' => $subscription->end_date,
            ];
        }

        // إحصائيات الشهر الحالي بالأيام
        $monthlyStats = [];
        $startOfMonth = now()->startOfMonth();
        $today = now();
        
        for ($date = $startOfMonth->copy(); $date <= $today; $date->addDay()) {
            $count = Letter::where('company_id', $companyId)
                ->whereDate('created_at', $date)
                ->count();
            $monthlyStats[] = [
                'date' => $date->format('Y-m-d'),
                'count' => $count,
            ];
        }

        return response()->json([
            'success' => true,
            'data' => [
                'letters' => $lettersStats,
                'recent_letters' => $recentLetters,
                'subscription' => $subscriptionStatus,
                'monthly_chart' => $monthlyStats,
                'company' => Auth::user()->company,
            ],
        ]);
    }

    /**
     * إحصائيات سريعة
     */
    public function quickStats()
    {
        $companyId = Auth::user()->company_id;

        return response()->json([
            'success' => true,
            'data' => [
                'total_letters' => Letter::where('company_id', $companyId)->count(),
                'pending_letters' => Letter::where('company_id', $companyId)->where('status', 'draft')->count(),
                'sent_today' => Letter::where('company_id', $companyId)
                    ->where('status', 'sent')
                    ->whereDate('created_at', today())
                    ->count(),
            ],
        ]);
    }
}
