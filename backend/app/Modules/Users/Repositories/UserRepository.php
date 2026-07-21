<?php

namespace App\Modules\Users\Repositories;

use App\Modules\Users\Models\User;

class UserRepository
{
    public function getAll()
    {
        return User::latest()->paginate(15);
    }

    public function create(array $data)
    {
        return User::create($data);
    }

    public function update(User $user, array $data)
    {
        return $user->update($data);
    }

    public function delete(User $user)
    {
        return $user->delete();
    }
}