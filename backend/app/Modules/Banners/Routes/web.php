<?php

use Illuminate\Support\Facades\Route;
use App\Modules\Banners\Controllers\BannerController;

Route::middleware(['admin'])->prefix('banners')->group(function () {
    Route::get('/', [BannerController::class, 'index'])->name('banners.index');
    Route::get('/create', [BannerController::class, 'create'])->name('banners.create');
    Route::post('/store', [BannerController::class, 'store'])->name('banners.store');
    Route::get('/{id}', [BannerController::class, 'show'])->name('banners.show');
    Route::get('/{id}/edit', [BannerController::class, 'edit'])->name('banners.edit');
    Route::put('/{id}', [BannerController::class, 'update'])->name('banners.update');
    Route::delete('/{id}', [BannerController::class, 'destroy'])->name('banners.destroy');
    Route::patch('/{id}/toggle-status', [BannerController::class, 'toggleStatus'])->name('banners.toggle-status');
});
