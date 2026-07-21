<?php

namespace App\Modules\Employees\Services;

use App\Modules\Employees\Repositories\EmployeeRepository;

class EmployeeService
{
    public function __construct(
        protected EmployeeRepository $repo
    ) {}

    public function getAll()
    {
        return $this->repo->all();
    }

    public function store(array $data)
    {
        return $this->repo->create($data);
    }

    public function update($employee,array $data)
    {
        return $this->repo->update($employee,$data);
    }

    public function delete($employee)
    {
        return $this->repo->delete($employee);
    }
}