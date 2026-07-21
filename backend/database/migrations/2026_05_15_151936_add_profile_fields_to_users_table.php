<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {

            $table->date('dob')->nullable();

            $table->string('gender')->nullable();

            $table->string('blood_group')->nullable();

            $table->string('weight')->nullable();

            $table->string('height')->nullable();

            $table->text('address')->nullable();

        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {

            $table->dropColumn([

                'dob',

                'gender',

                'blood_group',

                'weight',

                'height',

                'address'

            ]);

        });
    }
};