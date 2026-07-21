<?php

namespace App\Modules\Settings\Providers;

use Illuminate\Support\ServiceProvider;

class SettingsServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        $this->loadViewsFrom(
            app_path('Modules/Settings/Views'),
            'settings'
        );
    }
}