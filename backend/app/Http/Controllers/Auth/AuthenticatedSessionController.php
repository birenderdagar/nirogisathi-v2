<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\RedirectResponse;
use Illuminate\View\View;

class AuthenticatedSessionController extends Controller
{
    /**
     * Show Login Page
     */
    public function create(): View
    {
        return view('auth::login');
    }

    /**
     * Handle Admin Login
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->validate([
            'email'    => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $admin = DB::table('admins')
            ->where('email', $request->email)
            ->first();

        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return back()
                ->withErrors([
                    'email' => 'Invalid email or password',
                ])
                ->withInput();
        }

        /*
        |--------------------------------------------------------------------------
        | Logout default Laravel auth
        |--------------------------------------------------------------------------
        */
        Auth::logout();

        /*
        |--------------------------------------------------------------------------
        | Create Admin Session
        |--------------------------------------------------------------------------
        */
        $request->session()->put([
            'admin_logged_in' => true,
            'admin_id'        => $admin->id,
            'admin_name'      => $admin->name,
            'admin_email'     => $admin->email,
            'admin_role'      => 'admin',
        ]);

        /*
        |--------------------------------------------------------------------------
        | Regenerate Session
        |--------------------------------------------------------------------------
        */
        $request->session()->regenerate();
        /*
        |--------------------------------------------------------------------------
        | Redirect to Dashboard
        |--------------------------------------------------------------------------
        */
        return redirect()->route('admin.dashboard');
    }

    /**
     * Logout Admin
     */
    public function destroy(Request $request): RedirectResponse
    {
        Auth::logout();

        $request->session()->flush();

        $request->session()->invalidate();

        $request->session()->regenerateToken();

        return redirect()->route('login');
    }
}