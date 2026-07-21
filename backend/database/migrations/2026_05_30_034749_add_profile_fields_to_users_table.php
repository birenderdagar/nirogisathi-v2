<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * RUN MIGRATION
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {

            // ADD ONLY IF COLUMN DOES NOT EXIST

            if (!Schema::hasColumn('users', 'dob')) {
                $table->date('dob')->nullable();
            }

            if (!Schema::hasColumn('users', 'gender')) {
                $table->string('gender')->nullable();
            }

            if (!Schema::hasColumn('users', 'blood_group')) {
                $table->string('blood_group')->nullable();
            }

            if (!Schema::hasColumn('users', 'weight')) {
                $table->string('weight')->nullable();
            }

            if (!Schema::hasColumn('users', 'height')) {
                $table->string('height')->nullable();
            }

            if (!Schema::hasColumn('users', 'address')) {
                $table->text('address')->nullable();
            }
        });
    }

    /**
     * ROLLBACK
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {

            $columns = [];

            if (Schema::hasColumn('users', 'dob')) {
                $columns[] = 'dob';
            }

            if (Schema::hasColumn('users', 'gender')) {
                $columns[] = 'gender';
            }

            if (Schema::hasColumn('users', 'blood_group')) {
                $columns[] = 'blood_group';
            }

            if (Schema::hasColumn('users', 'weight')) {
                $columns[] = 'weight';
            }

            if (Schema::hasColumn('users', 'height')) {
                $columns[] = 'height';
            }

            if (Schema::hasColumn('users', 'address')) {
                $columns[] = 'address';
            }

            if (!empty($columns)) {
                $table->dropColumn($columns);
            }
        });
    }
};