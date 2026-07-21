<?php

namespace App\Modules\Settings\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class SettingsController extends Controller
{
    public function index()
    {
        return view('settings::index', [
            'staffRoles' => $this->loadStaffRoles(),
            'permissions' => $this->permissionDefinitions(),
        ]);
    }

    public function save(Request $request)
    {
        $validated = $request->validate([
            'staff_roles' => 'nullable|string',
        ]);

        $roles = json_decode($validated['staff_roles'] ?? '[]', true);

        if (!is_array($roles)) {
            $roles = [];
        }

        $cleanRoles = [];

        foreach ($roles as $role) {
            if (!is_array($role)) {
                continue;
            }

            $cleanRoles[] = [
                'name' => trim($role['name'] ?? ''),
                'description' => trim($role['description'] ?? 'Custom permissions'),
                'permissions' => array_merge(
                    array_fill_keys(array_keys($this->permissionDefinitions()), false),
                    array_filter($role['permissions'] ?? [], fn ($value) => is_bool($value) ? $value : filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE))
                ),
            ];
        }

        $path = storage_path('app/settings/staff_roles.json');

        if (!is_dir(dirname($path))) {
            mkdir(dirname($path), 0755, true);
        }

        file_put_contents($path, json_encode($cleanRoles, JSON_PRETTY_PRINT));

        return back()->with(
            'success',
            'Settings Updated Successfully'
        );
    }

    private function loadStaffRoles(): array
    {
        $path = storage_path('app/settings/staff_roles.json');

        if (!file_exists($path)) {
            return [
                [
                    'name' => 'Administrator',
                    'description' => 'Full system access',
                    'permissions' => array_fill_keys(array_keys($this->permissionDefinitions()), true),
                ],
            ];
        }

        $data = json_decode(file_get_contents($path), true);

        if (!is_array($data)) {
            return [];
        }

        return $data;
    }

    private function permissionDefinitions(): array
    {
        return [
            'dashboard_access' => [
                'label' => 'Dashboard Access',
                'description' => 'Access control panel',
            ],
            'employee_management' => [
                'label' => 'Employee Management',
                'description' => 'Manage employees',
            ],
            'reports_access' => [
                'label' => 'Reports Access',
                'description' => 'View reports',
            ],
            'settings_access' => [
                'label' => 'Settings Access',
                'description' => 'Manage settings',
            ],
        ];
    }
}
