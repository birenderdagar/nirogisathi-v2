<?php

namespace App\Modules\Banners\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Banner extends Model
{
    protected $table = 'banners';

    protected $fillable = [
        'title',
        'button_text',
        'image_path',
        'image_url',
        'bg_color',
        'action_type',
        'action_value',
        'open_in_new_tab',
        'sort_order',
        'is_active',
    ];

    protected $casts = [
        'open_in_new_tab' => 'boolean',
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    public const ACTION_TYPES = [
        'none' => 'No action (display only)',
        'app_route' => 'Open app screen (interactive)',
        'external_url' => 'Open website URL',
        'phone' => 'Call phone number',
        'whatsapp' => 'Open WhatsApp chat',
    ];

    public const APP_ROUTES = [
        '/subscription-pack' => 'Subscription packs',
        '/my-health-team' => 'My Health Team',
        '/hospitals' => 'Hospitals',
        '/doctors' => 'Doctors',
        '/doctor-categories' => 'Doctor categories',
        '/health-locker' => 'Health Locker',
        '/plan-your-day' => 'Day Planner',
        '/insurance' => 'Insurance',
        '/orders' => 'Orders',
        '/cart' => 'Cart',
        '/contact' => 'Contact us',
        '/faq' => 'FAQ',
        '/notifications' => 'Notifications',
        '/edit-profile' => 'Edit profile',
    ];

    public function getResolvedImageUrlAttribute(): ?string
    {
        if ($this->image_path) {
            return asset('storage/' . $this->image_path);
        }

        if ($this->image_url) {
            return $this->image_url;
        }

        return null;
    }

    public function getActionLabelAttribute(): string
    {
        return self::ACTION_TYPES[$this->action_type] ?? $this->action_type;
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderByDesc('id');
    }

    protected static function booted(): void
    {
        static::deleting(function (Banner $banner) {
            if ($banner->image_path && Storage::disk('public')->exists($banner->image_path)) {
                Storage::disk('public')->delete($banner->image_path);
            }
        });
    }
}
