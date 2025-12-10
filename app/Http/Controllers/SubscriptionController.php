<?php

namespace App\Http\Controllers;

use App\Models\Subscription;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Carbon\Carbon;

class SubscriptionController extends Controller
{
    /**
     * عرض صفحة الاشتراكات
     */
    public function index()
    {
        $company = Auth::user()->company;
        
        $currentSubscription = $company?->subscriptions()
            ->where('status', 'active')
            ->first();
            
        $subscriptionHistory = $company?->subscriptions()
            ->orderBy('created_at', 'desc')
            ->get();

        return view('subscriptions.index', compact('currentSubscription', 'subscriptionHistory'));
    }

    /**
     * الاشتراك في خطة
     */
    public function subscribe(Request $request)
    {
        $request->validate([
            'type' => 'required|in:once,monthly,yearly',
        ]);

        $company = Auth::user()->company;
        
        if (!$company) {
            return redirect()->route('company.settings')
                ->with('error', 'يجب إنشاء شركة أولاً');
        }

        // تحديد تفاصيل الاشتراك
        $subscriptionDetails = $this->getSubscriptionDetails($request->type);

        // إلغاء الاشتراك السابق إن وجد
        $company->subscriptions()
            ->where('status', 'active')
            ->update(['status' => 'cancelled']);

        // إنشاء اشتراك جديد
        Subscription::create([
            'company_id' => $company->id,
            'type' => $request->type,
            'price' => $subscriptionDetails['price'],
            'start_date' => Carbon::now(),
            'end_date' => $subscriptionDetails['end_date'],
            'status' => 'active',
            'letters_limit' => $subscriptionDetails['letters_limit'],
            'letters_used' => 0,
        ]);

        return redirect()->route('subscriptions.index')
            ->with('success', 'تم الاشتراك بنجاح! شكراً لثقتك بنا.');
    }

    /**
     * الحصول على تفاصيل الاشتراك
     */
    private function getSubscriptionDetails(string $type): array
    {
        return match ($type) {
            'once' => [
                'price' => 199,
                'end_date' => null,
                'letters_limit' => 100,
            ],
            'monthly' => [
                'price' => 99,
                'end_date' => Carbon::now()->addMonth(),
                'letters_limit' => null,
            ],
            'yearly' => [
                'price' => 949,
                'end_date' => Carbon::now()->addYear(),
                'letters_limit' => null,
            ],
        };
    }

    /**
     * إلغاء الاشتراك
     */
    public function cancel()
    {
        $company = Auth::user()->company;
        
        $company->subscriptions()
            ->where('status', 'active')
            ->update(['status' => 'cancelled']);

        return redirect()->route('subscriptions.index')
            ->with('success', 'تم إلغاء الاشتراك بنجاح');
    }
}
