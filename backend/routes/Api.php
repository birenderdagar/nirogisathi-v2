<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Modules\Users\Controllers\Api\UserApiController;
use App\Modules\Banners\Controllers\Api\BannerApiController;
use App\Modules\CurrentUpdates\Controllers\Api\CurrentUpdateApiController;
use App\Modules\Subscriptions\Controllers\Api\SubscriptionApiController;
use App\Modules\UserSubscriptions\Controllers\Api\UserSubscriptionApiController;


/*
|--------------------------------------------------------------------------
| AUTH API ROUTES
|--------------------------------------------------------------------------
*/

Route::post(
    '/login',
    [AuthController::class, 'login']
);

Route::post(
    '/logout',
    [AuthController::class, 'logout']
);


/*
|--------------------------------------------------------------------------
| BANNERS API
|--------------------------------------------------------------------------
*/

Route::get('/banners', [BannerApiController::class, 'index']);
Route::get('/current-updates', [CurrentUpdateApiController::class, 'index']);
Route::get('/subscriptions', [SubscriptionApiController::class, 'index']);
Route::get('/subscriptions/{slug}', [SubscriptionApiController::class, 'show']);

Route::post('/my-subscription', [UserSubscriptionApiController::class, 'current']);
Route::post('/my-subscription/activate', [UserSubscriptionApiController::class, 'activate']);

/*
|--------------------------------------------------------------------------
| USERS API ROUTES
|--------------------------------------------------------------------------
| Flutter + Admin Sync APIs
|--------------------------------------------------------------------------
*/

Route::prefix('users')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | GET ALL USERS
    |--------------------------------------------------------------------------
    */
    Route::get(
        '/',
        [UserApiController::class, 'index']
    );


    /*
    |--------------------------------------------------------------------------
    | CREATE USER
    |--------------------------------------------------------------------------
    */
    Route::post(
        '/create',
        [UserApiController::class, 'store']
    );


    /*
    |--------------------------------------------------------------------------
    | GET SINGLE USER
    |--------------------------------------------------------------------------
    */
    Route::get(
        '/{id}',
        [UserApiController::class, 'show']
    );


    /*
    |--------------------------------------------------------------------------
    | UPDATE USER PROFILE
    |--------------------------------------------------------------------------
    */
    Route::post(
        '/update-profile',
        [UserApiController::class, 'updateProfile']
    );


    /*
    |--------------------------------------------------------------------------
    | GET USER PROFILE
    |--------------------------------------------------------------------------
    */
    Route::post(
        '/profile',
        [UserApiController::class, 'profile']
    );


    /*
    |--------------------------------------------------------------------------
    | DELETE USER
    |--------------------------------------------------------------------------
    */
    Route::delete(
        '/{id}',
        [UserApiController::class, 'destroy']
    );

});