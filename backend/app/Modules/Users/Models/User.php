<?php

namespace App\Modules\Users\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use App\Modules\Employees\Models\Employee;
use App\Modules\UserSubscriptions\Models\UserSubscription;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    protected $table = 'users';

    protected $fillable = [

        'name',
        'mobile',
        'mpin',
        'email',
        'photo',
        'status',
        'role',
        'employee_id',
        'user_id',

        // PROFILE

        'dob',
        'gender',
        'blood_group',
        'weight',
        'height',
        'address',
    ];

    protected $hidden = [

        'mpin',
        'remember_token',

    ];

    protected $appends = [
        'photo_url'
    ];

    /*
    |--------------------------------------------------------------------------
    | PHOTO URL
    |--------------------------------------------------------------------------
    */
    public function getPhotoUrlAttribute()
    {
        if (!$this->photo) {
            return null;
        }

        return asset('storage/' . $this->photo);
    }

    /*
    |--------------------------------------------------------------------------
    | ASSIGNED EMPLOYEE
    |--------------------------------------------------------------------------
    */
    public function assignedEmployee()
    {
        return $this->belongsTo(
            Employee::class,
            'employee_id',
            'employee_id'
        );
    }

    public function subscriptions()
    {
        return $this->hasMany(UserSubscription::class);
    }
}