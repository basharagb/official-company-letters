<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Subscription;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class SubscriptionApiController extends Controller
{
    /**
     * الحصول على الاشتراك الحالي
     */
    public function current()
    {
        $subscription = Subscription::where('company_id', Auth::user()->company_id)
            ->where('is_active', true)
            ->first();

        return response()->json([
            'success' => true,
            'data' => [
                'subscription' => $subscription,
                'is_active' => $subscription ? $subscription->isValid() : false,
                'remaining_letters' => $subscription ? $subscription->remainingLetters() : 0,
                'days_remaining' => $subscription ? $subscription->daysRemaining() : 0,
            ],
        ]);
    }

    /**
     * قائمة الباقات المتاحة
     */
    public function plans()
    {
        $plans = [
            [
                'id' => 'one_time',
                'name' => 'الباقة المرنة',
                'description' => '100 خطاب',
                'price' => 99,
                'currency' => 'SAR',
                'letters_limit' => 100,
                'duration_days' => null,
                'features' => [
                    '100 خطاب',
                    'جميع الميزات',
                    'دعم فني',
                    'بدون انتهاء',
                ],
            ],
            [
                'id' => 'monthly',
                'name' => 'الباقة الشهرية',
                'description' => 'خطابات غير محدودة',
                'price' => 49,
                'currency' => 'SAR',
                'letters_limit' => null,
                'duration_days' => 30,
                'features' => [
                    'خطابات غير محدودة',
                    'جميع الميزات',
                    'دعم فني على مدار الساعة',
                    'تجديد شهري',
                ],
            ],
            [
                'id' => 'yearly',
                'name' => 'الباقة السنوية',
                'description' => 'خطابات غير محدودة + توفير 20%',
                'price' => 470,
                'currency' => 'SAR',
                'letters_limit' => null,
                'duration_days' => 365,
                'features' => [
                    'خطابات غير محدودة',
                    'جميع الميزات',
                    'دعم فني على مدار الساعة',
                    'توفير 20%',
                    'تجديد سنوي',
                ],
            ],
        ];

        return response()->json([
            'success' => true,
            'data' => $plans,
        ]);
    }

    /**
     * الاشتراك في باقة
     */
    public function subscribe(Request $request)
    {
        $request->validate([
            'plan' => 'required|in:one_time,monthly,yearly',
            'payment_method' => 'required|string',
        ]);

        $companyId = Auth::user()->company_id;

        // إلغاء الاشتراكات القديمة
        Subscription::where('company_id', $companyId)
            ->where('is_active', true)
            ->update(['is_active' => false]);

        // إنشاء اشتراك جديد
        $planDetails = $this->getPlanDetails($request->plan);
        
        $subscription = Subscription::create([
            'company_id' => $companyId,
            'plan' => $request->plan,
            'price' => $planDetails['price'],
            'letters_limit' => $planDetails['letters_limit'],
            'letters_used' => 0,
            'start_date' => now(),
            'end_date' => $planDetails['duration_days'] 
                ? now()->addDays($planDetails['duration_days']) 
                : null,
            'is_active' => true,
            'payment_method' => $request->payment_method,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم الاشتراك بنجاح',
            'data' => $subscription,
        ], 201);
    }

    /**
     * إلغاء الاشتراك
     */
    public function cancel()
    {
        $subscription = Subscription::where('company_id', Auth::user()->company_id)
            ->where('is_active', true)
            ->first();

        if (!$subscription) {
            return response()->json([
                'success' => false,
                'message' => 'لا يوجد اشتراك نشط',
            ], 404);
        }

        $subscription->update([
            'is_active' => false,
            'cancelled_at' => now(),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'تم إلغاء الاشتراك بنجاح',
        ]);
    }

    /**
     * سجل الاشتراكات
     */
    public function history()
    {
        $subscriptions = Subscription::where('company_id', Auth::user()->company_id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $subscriptions,
        ]);
    }

    /**
     * الحصول على تفاصيل الباقة
     */
    private function getPlanDetails($plan)
    {
        $plans = [
            'one_time' => ['price' => 99, 'letters_limit' => 100, 'duration_days' => null],
            'monthly' => ['price' => 49, 'letters_limit' => null, 'duration_days' => 30],
            'yearly' => ['price' => 470, 'letters_limit' => null, 'duration_days' => 365],
        ];

        return $plans[$plan];
    }
}
