<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('banners', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('button_text')->default('Learn More');
            $table->string('image_path')->nullable();
            $table->string('image_url')->nullable();
            $table->string('bg_color', 20)->default('#E3F2FD');
            $table->string('action_type')->default('none'); // none, app_route, external_url, phone, whatsapp
            $table->string('action_value')->nullable();
            $table->boolean('open_in_new_tab')->default(false);
            $table->unsignedInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('banners');
    }
};
