<?php

namespace App\Modules\Auth\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Modules\Users\Models\User;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // Validate request
        $request->validate([
            'mobile' => 'required|string',
            'mpin'   => 'required|string|min:4|max:6',
        ]);

        // Find user
        $user = User::where('mobile', $request->mobile)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User not found'
            ], 401);
        }

        // Verify MPIN
        if (!Hash::check($request->mpin, $user->mpin)) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid MPIN'
            ], 401);
        }

        // Delete old tokens
        $user->tokens()->delete();

        // Create fresh Sanctum token
        $token = $user->createToken('mobile-token')->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login successful',
            'token'   => $token,

                        'user' => [
                'id'            => $user->id,
                'user_id'       => $user->user_id,
                'name'          => $user->name,
                'mobile'        => $user->mobile,
                'email'         => $user->email,

                // ✅ PROFILE FIELDS
                'dob'           => $user->dob,
                'age'           => $user->age,
                'gender'        => $user->gender,
                'blood_group'   => $user->blood_group,
                'weight'        => $user->weight,
                'height'        => $user->height,

                // ✅ PHOTO
                'photo'         => $user->photo,

                // ✅ OTHER
                'role'          => $user->role,
                'status'        => $user->status,
                'employee_id'   => $user->employee_id,
            ]
        ], 200);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout successful'
        ]);
    }

    public function profile(Request $request)
    {
        return response()->json([
            'success' => true,
            'user'    => $request->user()
        ]);
    }
}