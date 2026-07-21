<?php

namespace App\Modules\Employees\Actions;

use App\Modules\Employees\Services\EmployeeService;

class DeleteEmployee
{
    public function __construct(
        protected EmployeeService $service
    ) {}

    public function execute($employee)
    {
        return $this->service->delete($employee);
    }
}