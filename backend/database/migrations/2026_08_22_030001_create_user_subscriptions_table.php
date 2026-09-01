<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_subscriptions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('subscription_id')->nullable();
            $table->string('plan_name');
            $table->string('plan_slug');
            $table->decimal('price', 10, 2)->default(0);
            $table->string('price_display')->nullable();
            $table->string('billing_label')->nullable();
            $table->json('features')->nullable();
            $table->string('status')->default('active'); // active | expired | cancelled
            $table->string('payment_method')->nullable();
            $table->string('payment_ref')->nullable();
            $table->string('assigned_employee_id')->nullable();
            $table->timestamp('starts_at')->nullable();
            $table->timestamp('ends_at')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'status']);
            $table->index('plan_slug');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_subscriptions');
    }
};
