<?php

use Illuminate\Support\Facades\Route;
use App\Modules\CurrentUpdates\Controllers\CurrentUpdateController;

Route::middleware(['admin'])->prefix('current-updates')->group(function () {
    Route::get('/', [CurrentUpdateController::class, 'index'])->name('current-updates.index');
    Route::get('/create', [CurrentUpdateController::class, 'create'])->name('current-updates.create');
    Route::post('/store', [CurrentUpdateController::class, 'store'])->name('current-updates.store');
    Route::get('/{id}/edit', [CurrentUpdateController::class, 'edit'])->name('current-updates.edit');
    Route::put('/{id}', [CurrentUpdateController::class, 'update'])->name('current-updates.update');
    Route::delete('/{id}', [CurrentUpdateController::class, 'destroy'])->name('current-updates.destroy');
    Route::patch('/{id}/toggle-status', [CurrentUpdateController::class, 'toggleStatus'])->name('current-updates.toggle-status');
});
