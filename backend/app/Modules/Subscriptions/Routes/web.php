<?php

use Illuminate\Support\Facades\Route;
use App\Modules\Subscriptions\Controllers\SubscriptionController;

Route::middleware(['admin'])->prefix('subscriptions')->group(function () {
    Route::get('/', [SubscriptionController::class, 'index'])->name('subscriptions.index');
    Route::get('/create', [SubscriptionController::class, 'create'])->name('subscriptions.create');
    Route::post('/store', [SubscriptionController::class, 'store'])->name('subscriptions.store');
    Route::get('/{id}', [SubscriptionController::class, 'show'])->name('subscriptions.show');
    Route::get('/{id}/edit', [SubscriptionController::class, 'edit'])->name('subscriptions.edit');
    Route::put('/{id}', [SubscriptionController::class, 'update'])->name('subscriptions.update');
    Route::delete('/{id}', [SubscriptionController::class, 'destroy'])->name('subscriptions.destroy');
    Route::patch('/{id}/toggle-status', [SubscriptionController::class, 'toggleStatus'])->name('subscriptions.toggle-status');
});
