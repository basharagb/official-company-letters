<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class CheckSetupCompleted
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        // تحقق من أن المستخدم مسجل دخول
        if (Auth::check()) {
            $company = Auth::user()->company;
            
            // إذا لم تكن الشركة موجودة أو لم يكتمل الإعداد
            if (!$company || !$company->setup_completed) {
                // السماح بالوصول لصفحات الإعداد وتسجيل الخروج
                $allowedRoutes = [
                    'company.setup',
                    'company.setup.step1',
                    'company.setup.step2',
                    'company.setup.step3',
                    'logout'
                ];
                
                if (!in_array($request->route()->getName(), $allowedRoutes)) {
                    return redirect()->route('company.setup');
                }
            }
        }
        
        return $next($request);
    }
}
