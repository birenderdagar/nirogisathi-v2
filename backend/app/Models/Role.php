<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

use App\Models\Permission;
use App\Modules\Employees\Models\Employee;

class Role extends Model
{
    use HasFactory;

    protected $fillable = [

        'name',
        'slug'

    ];

    /*
    |--------------------------------------------------------------------------
    | PERMISSIONS
    |--------------------------------------------------------------------------
    */

    public function permissions()
    {
        return $this->belongsToMany(
            Permission::class,
            'permission_role',
            'role_id',
            'permission_id'
        );
    }

    /*
    |--------------------------------------------------------------------------
    | EMPLOYEES
    |--------------------------------------------------------------------------
    */

    public function employees()
    {
        return $this->belongsToMany(
            Employee::class,
            'employee_role',
            'role_id',
            'employee_id'
        );
    }
}