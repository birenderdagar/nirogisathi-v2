<?php

namespace App\Modules\Employees\Actions;

use App\Modules\Employees\Models\Employee;

class CreateEmployee
{
    public function execute(array $data)
    {
        $photoPath = null;

        if (!empty($data['photo'])) {
            $photoPath = $data['photo']
                ->store('employees', 'public');
        }

        $last = Employee::latest()->first();

        $next = $last
            ? ((int) substr($last->employee_id, 3)) + 1
            : 1;

        $employeeId = 'NE-' . str_pad(
            $next,
            4,
            '0',
            STR_PAD_LEFT
        );

        return Employee::create([

            'employee_id' => $employeeId,

            'photo' => $photoPath,

            'name' => $data['name'],

            'mobile' => $data['mobile'],

            'email' => $data['email'] ?? null,

            'designation' => $data['designation'],

            'joining_date' => now(),

            'status' => $data['status'] ?? true

        ]);
    }
}