<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\View;
class AppServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        /*
        |--------------------------------------------------------------------------
        | Module View Namespaces
        |--------------------------------------------------------------------------
        */

        View::addNamespace(
            'admin',
            app_path('Modules/Admin/Views')
        );

        View::addNamespace(
            'auth',
            app_path('Modules/Auth/Views')
        );

        View::addNamespace(
            'users',
            app_path('Modules/Users/Views')
        );

        /*
        |--------------------------------------------------------------------------
        | Load Module Routes
        |--------------------------------------------------------------------------
        */

        if (file_exists(app_path('Modules/Users/Routes/web.php'))) {
            require app_path('Modules/Users/Routes/web.php');
        }

        /*
        ||--------------------------------------------------------------------------
        || employee module routes 
        ||--------------------------------------------------------------------------
        */
        View::addNamespace(
            'Employees',
            app_path('Modules/Employees/Views')
        );

        /*
        ||--------------------------------------------------------------------------
        || settings module routes
        ||--------------------------------------------------------------------------
        */
        View::addNamespace(
            'Settings',
            app_path('Modules/Settings/Views')
        );

        // Module routes are loaded from routes/web.php to avoid duplicate
        // route names and conflicting middleware behavior.
        // if (file_exists(app_path('Modules/Admin/Routes/web.php'))) {
        //     require app_path('Modules/Admin/Routes/web.php');
        // }

        // if (file_exists(app_path('Modules/Auth/Routes/web.php'))) {
        //     require app_path('Modules/Auth/Routes/web.php');
        // }
    }
}