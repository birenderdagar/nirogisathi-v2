<?php

namespace App\Modules\Users\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Modules\Users\Models\User;
use Illuminate\Http\Request;

class UserApiController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | USER LIST
    |--------------------------------------------------------------------------
    */
    public function index()
    {
        $users = User::latest()->get();

        return response()->json([

            'status' => true,

            'data' => $users

        ]);
    }

    /*
    |--------------------------------------------------------------------------
    | USER PROFILE
    |--------------------------------------------------------------------------
    */
    public function profile(Request $request)
    {
        $id = $request->user_id;

        $user = User::find($id);

        if (!$user) {

            return response()->json([

                'status' => false,

                'message' => 'User not found'

            ], 404);
        }

        return response()->json([

            'status' => true,

            'data' => [

                'id' => $user->id,
                'user_id' => $user->user_id,
                'name' => $user->name,
                'mobile' => $user->mobile,
                'email' => $user->email,
                'photo' => $user->photo_url,

                'dob' => $user->dob,
                'gender' => $user->gender,
                'blood_group' => $user->blood_group,
                'weight' => $user->weight,
                'height' => $user->height,
                'address' => $user->address,

                'role' => $user->role,
                'employee_id' => $user->employee_id,
                'status' => $user->status,
            ]
        ]);
    }

    /*
    |--------------------------------------------------------------------------
    | UPDATE PROFILE
    |--------------------------------------------------------------------------
    */
    public function updateProfile(Request $request)
{
    try {

        $user = User::find($request->user_id);

        if (!$user) {

            return response()->json([
                'status' => false,
                'message' => 'User not found'
            ], 404);
        }

        /*
        |--------------------------------------------------------------------------
        | PHOTO UPLOAD
        |--------------------------------------------------------------------------
        */
        if ($request->hasFile('photo')) {

            $file = $request->file('photo');

            $filename = time() . '_' . $file->getClientOriginalName();

            $file->storeAs(
                'users',
                $filename,
                'public'
            );

            $user->photo = 'users/' . $filename;
        }

        /*
        |--------------------------------------------------------------------------
        | UPDATE USER
        |--------------------------------------------------------------------------
        */

        $user->name = $request->name ?? $user->name;

        $user->mobile = $request->mobile ?? $user->mobile;

        $user->email = $request->email ?? $user->email;

        $user->dob = $request->dob ?? $user->dob;

        $user->gender = $request->gender ?? $user->gender;

        $user->blood_group = $request->blood_group ?? $user->blood_group;

        $user->weight = $request->weight ?? $user->weight;

        $user->height = $request->height ?? $user->height;

        $user->address = $request->address ?? $user->address;

        $user->save();

        return response()->json([

            'status' => true,

            'message' => 'Profile updated successfully',

            'data' => [

                'id' => $user->id,

                'user_id' => $user->user_id,

                'photo' => $user->photo
                    ? asset('storage/' . $user->photo)
                    : null,

                'name' => $user->name,

                'mobile' => $user->mobile,

                'email' => $user->email,

                'dob' => $user->dob,

                'gender' => $user->gender,

                'blood_group' => $user->blood_group,

                'weight' => $user->weight,

                'height' => $user->height,

                'address' => $user->address,

            ]

        ]);

    } catch (\Exception $e) {

        return response()->json([

            'status' => false,

            'message' => $e->getMessage()

        ], 500);
    }
}
}