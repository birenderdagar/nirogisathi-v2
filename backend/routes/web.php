<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Modules\Admin\Controllers\AdminController;
use App\Modules\Employees\Controllers\EmployeeController;

/*
|--------------------------------------------------------------------------
| Welcome
|--------------------------------------------------------------------------
*/

Route::get('/', function () {
    return view('admin::welcome');
});

/*
|--------------------------------------------------------------------------
| AUTH
|--------------------------------------------------------------------------
*/

Route::get('/login', [AuthenticatedSessionController::class, 'create'])->name('login');
Route::post('/login', [AuthenticatedSessionController::class, 'store'])->name('login.store');
Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])->name('logout');

/*
|--------------------------------------------------------------------------
| DASHBOARD REDIRECT
|--------------------------------------------------------------------------
*/

Route::get('/dashboard', function () {
    return redirect()->route('admin.dashboard');
});

/*
|--------------------------------------------------------------------------
| ADMIN CORE ROUTES ONLY
|--------------------------------------------------------------------------
*/

Route::middleware(['admin'])->prefix('admin')->group(function () {

    Route::get('/', [AdminController::class, 'dashboard'])->name('admin.dashboard');

    Route::get('/preview', [AdminController::class, 'preview'])->name('admin.preview');
});

/*
|--------------------------------------------------------------------------
| MODULE ROUTES (OUTSIDE MIDDLEWARE GROUP)
|--------------------------------------------------------------------------
*/

require __DIR__.'/../app/Modules/Users/Routes/web.php';

/*
|--------------------------------------------------------------------------
| MODULE ROUTES (employee )
|--------------------------------------------------------------------------
*/      
require base_path(
'app/Modules/Employees/Routes/web.php'
);

/*
|--------------------------------------------------------------------------
| MODULE ROUTES (settings )
|--------------------------------------------------------------------------*/      
require base_path('app/Modules/Settings/Routes/web.php');

/*
|--------------------------------------------------------------------------
| MODULE ROUTES (roles and permissions )
|--------------------------------------------------------------------------*/      
Route::get('/employees', function () {
    return view('employees');
})->middleware('permission:view-employees');

/*
|--------------------------------------------------------------------------
| MODULE ROUTES (employees )
|--------------------------------------------------------------------------*/      


Route::get(
    '/employees',
    [EmployeeController::class, 'index']
)->name('employees.index');