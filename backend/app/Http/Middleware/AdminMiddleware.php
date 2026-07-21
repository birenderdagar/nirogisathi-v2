<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        // safer check
        if (!session()->has('admin_logged_in') || session('admin_logged_in') !== true) {
            return redirect()->route('login');
        }

        return $next($request);
    }
}