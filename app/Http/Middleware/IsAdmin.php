<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class IsAdmin
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();
        if (is_null($user)) {
            return redirect()->route('login');
        }
        elseif (!$user->isSuperAdmin() && $user->access_level != 1) {
            return redirect()->route('dashboard')->with('error', 'ليس لديك صلاحية الوصول');
        }
        return $next($request);
    }
}