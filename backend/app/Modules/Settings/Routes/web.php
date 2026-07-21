<?php

use Illuminate\Support\Facades\Route;
use App\Modules\Settings\Controllers\SettingsController;

Route::prefix('settings')->group(function () {

    Route::get('/', [SettingsController::class, 'index'])
        ->name('settings.index');

    Route::post('/save', [SettingsController::class, 'save'])
        ->name('settings.save');

});