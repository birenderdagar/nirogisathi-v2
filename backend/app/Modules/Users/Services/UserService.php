<?php

namespace App\Modules\Users\Services;

use App\Modules\Users\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UserService
{
    /*
    |--------------------------------------------------------------------------
    | GET ALL USERS
    |--------------------------------------------------------------------------
    */
    public function all()
    {
        return User::with('assignedEmployee')
            ->latest()
            ->get();
    }

    /*
    |--------------------------------------------------------------------------
    | FIND USER
    |--------------------------------------------------------------------------
    */
    public function find($id)
    {
        return User::with('assignedEmployee')
            ->findOrFail($id);
    }

    /*
    |--------------------------------------------------------------------------
    | CREATE USER
    |--------------------------------------------------------------------------
    */
    public function create(array $data)
    {
        /*
        |--------------------------------------------------------------------------
        | AUTO USER ID
        |--------------------------------------------------------------------------
        */
        $lastUser = User::latest('id')->first();

        $nextId = $lastUser
            ? $lastUser->id + 1
            : 1;

        $prefix = isset($data['prefix']) && trim($data['prefix']) !== ''
            ? strtoupper(trim($data['prefix']))
            : 'NS';

        $userId = $prefix . str_pad(
            $nextId,
            3,
            '0',
            STR_PAD_LEFT
        );

        /*
        |--------------------------------------------------------------------------
        | PHOTO UPLOAD
        |--------------------------------------------------------------------------
        */
        $photo = null;

        if (request()->hasFile('photo')) {

            $photo = request()
                ->file('photo')
                ->store('users', 'public');
        }

        /*
        |--------------------------------------------------------------------------
        | CREATE USER
        |--------------------------------------------------------------------------
        */
        $user = User::create([

            'user_id' => $userId,

            'photo' => $photo,

            'name' => $data['name'] ?? null,

            'mobile' => $data['mobile'] ?? null,

            'email' => $data['email'] ?? null,

            'role' => $data['role'] ?? 'user',

            'status' => $data['status'] ?? 'active',

            'employee_id' => $data['employee_id'] ?? null,

            'mpin' => isset($data['mpin'])
                ? Hash::make($data['mpin'])
                : null,

            /*
            |--------------------------------------------------------------------------
            | PROFILE FIELDS
            |--------------------------------------------------------------------------
            */
            'dob' => $data['dob'] ?? null,

            'gender' => $data['gender'] ?? null,

            'blood_group' => $data['blood_group'] ?? null,

            'weight' => $data['weight'] ?? null,

            'height' => $data['height'] ?? null,

            'address' => $data['address'] ?? null,
        ]);

        /*
        |--------------------------------------------------------------------------
        | ACTIVITY LOG
        |--------------------------------------------------------------------------
        */
        $this->logActivity(
            $user->id,
            'created',
            'New user created'
        );

        return $user;
    }

    /*
    |--------------------------------------------------------------------------
    | UPDATE USER
    |--------------------------------------------------------------------------
    */
    public function update($id, array $data)
    {
        $user = User::findOrFail($id);

        /*
        |--------------------------------------------------------------------------
        | KEEP OLD PHOTO
        |--------------------------------------------------------------------------
        */
        $photo = $user->photo;

        /*
        |--------------------------------------------------------------------------
        | NEW PHOTO UPLOAD
        |--------------------------------------------------------------------------
        */
        if (request()->hasFile('photo')) {

            $photo = request()
                ->file('photo')
                ->store('users', 'public');
        }

        /*
        |--------------------------------------------------------------------------
        | UPDATE USER
        |--------------------------------------------------------------------------
        */
        $user->update([

            'photo' => $photo,

            'name' => $data['name'] ?? $user->name,

            'mobile' => $data['mobile'] ?? $user->mobile,

            'email' => $data['email'] ?? $user->email,

            'role' => $data['role'] ?? $user->role,

            'status' => $data['status'] ?? $user->status,

            'employee_id' => $data['employee_id']
                ?? $user->employee_id,

            /*
            |--------------------------------------------------------------------------
            | PROFILE FIELDS
            |--------------------------------------------------------------------------
            */
            'dob' => $data['dob']
                ?? $user->dob,

            'gender' => $data['gender']
                ?? $user->gender,

            'blood_group' => $data['blood_group']
                ?? $user->blood_group,

            'weight' => $data['weight']
                ?? $user->weight,

            'height' => $data['height']
                ?? $user->height,

            'address' => $data['address']
                ?? $user->address,
        ]);

        /*
        |--------------------------------------------------------------------------
        | ACTIVITY LOG
        |--------------------------------------------------------------------------
        */
        $this->logActivity(
            $id,
            'updated',
            'User updated'
        );

        return $user;
    }

    /*
    |--------------------------------------------------------------------------
    | DELETE USER
    |--------------------------------------------------------------------------
    */
    public function delete($id)
    {
        $user = User::findOrFail($id);

        $user->delete();

        $this->logActivity(
            $id,
            'deleted',
            'User deleted'
        );

        return true;
    }

    /*
    |--------------------------------------------------------------------------
    | BLOCK / UNBLOCK USER
    |--------------------------------------------------------------------------
    */
    public function toggleStatus($id)
    {
        $user = User::findOrFail($id);

        $user->status = $user->status === 'active'
            ? 'blocked'
            : 'active';

        $user->save();

        $this->logActivity(
            $id,
            'status_changed',
            'User status changed'
        );

        return $user;
    }

    /*
    |--------------------------------------------------------------------------
    | RESTORE USER
    |--------------------------------------------------------------------------
    */
    public function restore($id)
    {
        $user = User::withTrashed()
            ->findOrFail($id);

        $user->restore();

        $this->logActivity(
            $id,
            'restored',
            'User restored'
        );

        return $user;
    }

    /*
    |--------------------------------------------------------------------------
    | FORCE DELETE
    |--------------------------------------------------------------------------
    */
    public function forceDelete($id)
    {
        $user = User::withTrashed()
            ->findOrFail($id);

        $user->forceDelete();

        return true;
    }

    /*
    |--------------------------------------------------------------------------
    | ACTIVITY LOGGER
    |--------------------------------------------------------------------------
    */
    public function logActivity(
        $userId,
        $action,
        $description = null
    ) {
        DB::table('activity_logs')->insert([

            'user_id' => $userId,

            'action' => $action,

            'module' => 'users',

            'description' => $description,

            'created_at' => now(),

            'updated_at' => now(),
        ]);
    }
}