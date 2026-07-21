<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Modules\Users\Models\User;

class AuthController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | LOGIN
    |--------------------------------------------------------------------------
    */
    public function login(Request $request)
    {
        try {

            /*
            |--------------------------------------------------------------------------
            | VALIDATION
            |--------------------------------------------------------------------------
            */
            $request->validate([

                'mobile' => 'required',

                'mpin'   => 'required',

            ]);

            /*
            |--------------------------------------------------------------------------
            | FIND USER
            |--------------------------------------------------------------------------
            */
            $user = User::where(
                'mobile',
                $request->mobile
            )->first();

            /*
            |--------------------------------------------------------------------------
            | USER NOT FOUND
            |--------------------------------------------------------------------------
            */
            if (!$user) {

                return response()->json([

                    'status' => false,

                    'message' => 'User not found',

                ], 404);
            }

            /*
            |--------------------------------------------------------------------------
            | CHECK MPIN
            |--------------------------------------------------------------------------
            */
            if (!Hash::check(
                $request->mpin,
                $user->mpin
            )) {

                return response()->json([

                    'status' => false,

                    'message' => 'Invalid MPIN',

                ], 401);
            }

            /*
            |--------------------------------------------------------------------------
            | SUCCESS LOGIN
            |--------------------------------------------------------------------------
            */
            return response()->json([

                'status' => true,

                'message' => 'Login successful',

                'data' => [

                    'id' => $user->id,

                    'employee_id' => $user->employee_id,

                    'name' => $user->name,

                    'mobile' => $user->mobile,

                    'email' => $user->email,

                    'photo' => $user->photo
                        ? asset('storage/' . $user->photo)
                        : null,

                    'role' => $user->role,

                    'status' => $user->status,

                ]

            ]);

        } catch (\Exception $e) {

            return response()->json([

                'status' => false,

                'message' => $e->getMessage()

            ], 500);
        }
    }

    /*
    |--------------------------------------------------------------------------
    | LOGOUT
    |--------------------------------------------------------------------------
    */
    public function logout(Request $request)
    {
        return response()->json([

            'status' => true,

            'message' => 'Logout successful'

        ]);
    }
}