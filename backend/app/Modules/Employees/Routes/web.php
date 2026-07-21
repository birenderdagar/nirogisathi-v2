<?php

use Illuminate\Support\Facades\Route;
use App\Modules\Employees\Controllers\EmployeeController;

Route::prefix('employees')->group(function () {

    Route::get(
        '/',
        [EmployeeController::class, 'index']
    )->name('employees.index');


    Route::get(
        '/create',
        [EmployeeController::class, 'create']
    )->name('employees.create');


    Route::post(
        '/store',
        [EmployeeController::class, 'store']
    )->name('employees.store');


    Route::get(
        '/{id}',
        [EmployeeController::class, 'show']
    )->name('employees.show');


    Route::get(
        '/{id}/edit',
        [EmployeeController::class, 'edit']
    )->name('employees.edit');


    Route::put(
        '/{id}',
        [EmployeeController::class, 'update']
    )->name('employees.update');


    Route::delete(
        '/{id}',
        [EmployeeController::class, 'destroy']
    )->name('employees.destroy');


    Route::patch(
        '/{id}/toggle-status',
        [EmployeeController::class, 'toggleStatus']
    )->name('employees.toggle-status');

});