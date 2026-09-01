<?php

use Illuminate\Support\Facades\Route;
use App\Modules\UserSubscriptions\Controllers\UserSubscriptionController;

Route::middleware(['admin'])->prefix('admin')->group(function () {
    Route::get('/user-subscriptions', [UserSubscriptionController::class, 'index'])
        ->name('user-subscriptions.index');
    Route::get('/user-subscriptions/create', [UserSubscriptionController::class, 'create'])
        ->name('user-subscriptions.create');
    Route::post('/user-subscriptions', [UserSubscriptionController::class, 'store'])
        ->name('user-subscriptions.store');
    Route::get('/user-subscriptions/{id}/edit', [UserSubscriptionController::class, 'edit'])
        ->name('user-subscriptions.edit');
    Route::put('/user-subscriptions/{id}', [UserSubscriptionController::class, 'update'])
        ->name('user-subscriptions.update');
    Route::delete('/user-subscriptions/{id}', [UserSubscriptionController::class, 'destroy'])
        ->name('user-subscriptions.destroy');
});
