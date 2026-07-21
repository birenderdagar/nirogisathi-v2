<?php

namespace App\Modules\Employees\Repositories;

use App\Modules\Employees\Models\Employee;

class EmployeeRepository
{
    public function all()
    {
        return Employee::latest()->paginate(20);
    }

    public function create(array $data)
    {
        return Employee::create($data);
    }

    public function update(Employee $employee, array $data)
    {
        return $employee->update($data);
    }

    public function delete(Employee $employee)
    {
        return $employee->delete();
    }
}