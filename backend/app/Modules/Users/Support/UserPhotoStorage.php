<?php

namespace App\Modules\Users\Support;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class UserPhotoStorage
{
    public static function store(
        UploadedFile $file,
        string $name,
        string $userId,
        ?string $oldPhoto = null
    ): string {
        $extension = strtolower($file->getClientOriginalExtension() ?: 'jpg');
        $filename = Str::slug($name) . '-' . Str::lower($userId) . '.' . $extension;
        $path = 'users/' . $filename;

        if ($oldPhoto && $oldPhoto !== $path && Storage::disk('public')->exists($oldPhoto)) {
            Storage::disk('public')->delete($oldPhoto);
        }

        if (Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }

        $file->storeAs('users', $filename, 'public');

        return $path;
    }
}
