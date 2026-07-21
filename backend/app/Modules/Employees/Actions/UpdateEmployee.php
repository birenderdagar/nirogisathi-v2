<?php

namespace App\Modules\Employees\Actions;

use App\Modules\Employees\Services\EmployeeService;

class UpdateEmployee
{
    public function __construct(
        protected EmployeeService $service
    ) {}

    public function execute($employee,array $data)
    {
        return $this->service->update($employee,$data);
    }
}