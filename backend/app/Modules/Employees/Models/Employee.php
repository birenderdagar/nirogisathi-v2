<?php

namespace App\Modules\Employees\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

use App\Models\Role;

class Employee extends Model
{
    use HasFactory;

    protected $table = 'employees';

    protected $fillable = [

        'employee_id',

        'photo',

        'name',

        'mobile',

        'email',

        'designation',

        'joining_date',

        'status'

    ];

    /*
    |--------------------------------------------------------------------------
    | ROLES RELATIONSHIP
    |--------------------------------------------------------------------------
    */

    public function roles()
    {
        return $this->belongsToMany(

            Role::class,

            'employee_role',

            'employee_id',

            'role_id'

        );
    }

    /*
    |--------------------------------------------------------------------------
    | CHECK ROLE
    |--------------------------------------------------------------------------
    */

    public function hasRole($role)
    {
        return $this->roles
                    ->contains('slug', $role);
    }

    /*
    |--------------------------------------------------------------------------
    | CHECK PERMISSION
    |--------------------------------------------------------------------------
    */

    public function hasPermission($permission)
    {
        return $this->roles()

            ->whereHas('permissions', function ($query) use ($permission) {

                $query->where('slug', $permission);

            })

            ->exists();
    }
}