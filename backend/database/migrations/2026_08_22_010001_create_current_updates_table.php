<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('current_updates', function (Blueprint $table) {
            $table->id();
            $table->string('value', 50);
            $table->string('label');
            $table->string('bg_color', 20)->default('#EFF6FF');
            $table->string('text_color', 20)->default('#1D4ED8');
            $table->unsignedInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        DB::table('current_updates')->insert([
            [
                'value' => '20',
                'label' => "Healthcare\nGivers",
                'bg_color' => '#EFF6FF',
                'text_color' => '#1D4ED8',
                'sort_order' => 1,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'value' => '200',
                'label' => "Clients\nServed",
                'bg_color' => '#ECFDF5',
                'text_color' => '#15803D',
                'sort_order' => 2,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'value' => '35',
                'label' => "Doctors\nOnboard",
                'bg_color' => '#F0FDFA',
                'text_color' => '#0F766E',
                'sort_order' => 3,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'value' => '5',
                'label' => "Hospitals\nOnboard",
                'bg_color' => '#FFF7ED',
                'text_color' => '#C2410C',
                'sort_order' => 4,
                'is_active' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }

    public function down(): void
    {
        Schema::dropIfExists('current_updates');
    }
};
