<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Database\Seeders\AdminSeeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 👤 Create default test user (OTP/MPIN system)
        User::updateOrCreate(
            ['mobile' => '9999999999'],
            [
                'user_id' => 'USER0001',
                'employee_id' => null,
                'name' => 'Test User',
                'email' => null,
                'mpin' => null,
                'role' => 'user',
            ]
        );

        // 👑 Create admin (email + password system)
        $this->call([
            AdminSeeder::class,
        ]);
    }
}