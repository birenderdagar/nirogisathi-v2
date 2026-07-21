<?php

namespace App\Modules\Employees\DTOs;

class EmployeeDTO
{
    public function __construct(
        public string $employee_id,
        public string $name,
        public string $email,
        public string $phone,
        public string $designation,
        public bool $status
    ) {}
}