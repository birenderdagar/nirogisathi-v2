<?php

namespace Database\Factories;

use App\Modules\Users\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    protected $model = User::class;

    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'mobile' => fake()->numerify('9#########'),
            'email' => fake()->unique()->safeEmail(),
            'password' => Hash::make('password'),
            'mpin' => fake()->numerify('####'),
            'remember_token' => Str::random(10),
            'email_verified_at' => now(),
        ];
    }
}
