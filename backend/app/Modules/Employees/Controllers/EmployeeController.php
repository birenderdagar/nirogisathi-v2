<?php

namespace App\Modules\Employees\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Modules\Employees\Models\Employee;
use App\Modules\Employees\Actions\CreateEmployee;

class EmployeeController extends Controller
{
    /**
     * Employee List
     */
    public function index()
    {
        $employees = Employee::latest()->get();

        return view(
            'Employees::index',
            compact('employees')
        );
    }

    /**
     * Create Employee Page
     */
    public function create()
    {
        return view('Employees::create', [
            'staffRoles' => $this->loadStaffRoles(),
        ]);
    }

    /**
     * Store Employee
     */
    public function store(Request $request, CreateEmployee $createEmployee)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'mobile' => 'required|unique:employees',
            'email' => 'nullable|email',
            'designation' => 'required|string|max:255',
            'status' => 'required|boolean',
            'photo' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        $validated['photo'] = $request->file('photo');

        $createEmployee->execute($validated);

        return redirect()
            ->route('employees.index')
            ->with('success', 'Employee Added Successfully');
    }

    /**
     * View Employee
     */
    public function show($id)
    {
        $employee = Employee::findOrFail($id);

        return view(
            'Employees::show',
            [
                'employee' => $employee,
                'staffRoles' => $this->loadStaffRoles(),
            ]
        );
    }

    /**
     * Edit Employee Page
     */
    public function edit($id)
    {
        $employee = Employee::findOrFail($id);

        return view(
            'Employees::edit',
            [
                'employee' => $employee,
                'staffRoles' => $this->loadStaffRoles(),
            ]
        );
    }

    /**
     * Update Employee
     */
    public function update(Request $request, $id)
    {
        $employee = Employee::findOrFail($id);

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'mobile' => 'required|unique:employees,mobile,' . $id,
            'email' => 'nullable|email',
            'designation' => 'required|string|max:255',
            'status' => 'required|boolean',
            'photo' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
        ]);

        if ($request->hasFile('photo')) {
            if (
                $employee->photo &&
                Storage::disk('public')->exists($employee->photo)
            ) {
                Storage::disk('public')->delete($employee->photo);
            }

            $validated['photo'] = $request
                ->file('photo')
                ->store('employees', 'public');
        }

        $employee->update($validated);

        return redirect()
            ->route('employees.index')
            ->with('success', 'Employee Updated Successfully');
    }

    private function loadStaffRoles(): array
    {
        $path = storage_path('app/settings/staff_roles.json');

        if (!file_exists($path)) {
            return [
                [
                    'name' => 'Administrator',
                    'description' => 'Full system access',
                    'permissions' => [],
                ],
            ];
        }

        $roles = json_decode(file_get_contents($path), true);

        return is_array($roles) ? $roles : [];
    }

    /**
     * Delete Employee
     */
    public function destroy($id)
    {
        $employee = Employee::findOrFail($id);

        if (
            $employee->photo &&
            Storage::disk('public')->exists($employee->photo)
        ) {
            Storage::disk('public')->delete($employee->photo);
        }

        $employee->delete();

        return response()->json([
            'success' => true,
            'message' => 'Employee Deleted Successfully',
        ]);
    }

    /**
     * Block / Unblock Employee
     */
    public function toggleStatus($id)
    {
        $employee = Employee::findOrFail($id);

        $employee->status = !$employee->status;
        $employee->save();

        return redirect()
            ->back()
            ->with('success', 'Employee Status Updated');
    }
}
