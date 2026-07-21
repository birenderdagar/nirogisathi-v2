<?php

namespace App\Modules\Users\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Modules\Users\Services\UserService;
use App\Modules\Employees\Models\Employee;

class UserController extends Controller
{
    protected UserService $service;

    public function __construct(UserService $service)
    {
        $this->service = $service;
    }

    /*
    |--------------------------------------------------------------------------
    | LIST USERS
    |--------------------------------------------------------------------------
    */
    public function index()
    {
        $users = $this->service->all();

        return view('users::index', compact('users'));
    }

    /*
    |--------------------------------------------------------------------------
    | CREATE PAGE
    |--------------------------------------------------------------------------
    */
    public function create()
    {
        $employees = Employee::select([
            'employee_id',
            'name',
            'mobile',
            'email'
        ])->orderBy('name')->get();

        return view('users::create', compact('employees'));
    }

    /*
    |--------------------------------------------------------------------------
    | STORE USER
    |--------------------------------------------------------------------------
    */
    /*
|--------------------------------------------------------------------------
| STORE USER
|--------------------------------------------------------------------------
*/
        public function store(Request $request)
        {
        $this->service->create($request->all());

        return redirect()
            ->route('admin.users.index')
            ->with('popup_success', 'User created successfully');
    }
    /*
    |--------------------------------------------------------------------------
    | EDIT PAGE
    |--------------------------------------------------------------------------
    */
    public function edit($id)
    {
        $user = $this->service->find($id);

        $employees = Employee::select([
            'employee_id',
            'name',
            'mobile',
            'email'
        ])->orderBy('name')->get();

        return view('users::edit', compact('user', 'employees'));
    }

    /*
    |--------------------------------------------------------------------------
    | UPDATE USER
    |--------------------------------------------------------------------------
    */
    /*
|--------------------------------------------------------------------------
| UPDATE USER
|--------------------------------------------------------------------------
*/
    public function update(Request $request, $id)
    {
    $this->service->update(
        $id,
        $request->all()
    );

    return redirect()
        ->route('admin.users.index')
        ->with(
            'popup_success',
            'User updated successfully'
        );
    }

    /*
    |--------------------------------------------------------------------------
    | DELETE USER (SOFT DELETE)
    |--------------------------------------------------------------------------
    */
    public function destroy($id)
{
    $this->service->delete($id);

    return response()->json([
        'success' => true,
        'message' => 'User deleted successfully'
    ]);
}
    /*
    |--------------------------------------------------------------------------
    | BLOCK / UNBLOCK USER
    |--------------------------------------------------------------------------
    */
    public function toggleStatus($id)
    {
        $this->service->toggleStatus($id);

        return redirect()
            ->route('admin.users.index')
            ->with('popup_success', 'User status toggled successfully');
    }

    /*
    |--------------------------------------------------------------------------
    | RESTORE USER
    |--------------------------------------------------------------------------
    */
    public function restore($id)
    {
        $this->service->restore($id);

        return redirect()
            ->route('admin.users.index')
            ->with('popup_success', 'User restored successfully');
    }

    /*
    |--------------------------------------------------------------------------
    | Delete permanently (if needed, not exposed in routes by default)
    |--------------------------------------------------------------------------
    */      
    public function forceDelete($id)
    {
        $this->service->forceDelete($id);

        return redirect()
            ->route('admin.users.index')
            ->with('popup_success', 'User permanently deleted');
    }
}