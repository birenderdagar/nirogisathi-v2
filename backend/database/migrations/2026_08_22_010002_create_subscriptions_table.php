<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('subscriptions', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('price_display');
            $table->decimal('price', 10, 2)->default(0);
            $table->string('accent_color', 20)->default('#F97316');
            $table->string('app_route')->default('/subscription-pack');
            $table->text('description')->nullable();
            $table->json('features')->nullable();
            $table->unsignedInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        DB::table('subscriptions')->insert([
            [
                'name' => 'Basic',
                'slug' => 'basic',
                'price_display' => '₹150.00',
                'price' => 150,
                'accent_color' => '#F97316',
                'app_route' => '/subscription-pack',
                'description' => '150/- per Month',
                'features' => json_encode([
                    'Routine Screening 3 times a year',
                    'Health assistant support',
                ]),
                'sort_order' => 1,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Standard',
                'slug' => 'standard',
                'price_display' => '₹1500.00',
                'price' => 1500,
                'accent_color' => '#EF4444',
                'app_route' => '/standard-subscription',
                'description' => '1500/- per Month',
                'features' => json_encode([
                    'Everything in Basic',
                    'Priority doctor booking',
                ]),
                'sort_order' => 2,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Premium',
                'slug' => 'premium',
                'price_display' => '₹4500.00',
                'price' => 4500,
                'accent_color' => '#F59E0B',
                'app_route' => '/premium-subscription',
                'description' => '4500/- per Month',
                'features' => json_encode([
                    'Everything in Standard',
                    'Dedicated health assistant',
                ]),
                'sort_order' => 3,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('subscriptions');
    }
};
