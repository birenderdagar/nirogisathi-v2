<?php

namespace App\Modules\CurrentUpdates\Models;

use Illuminate\Database\Eloquent\Model;

class CurrentUpdate extends Model
{
    protected $table = 'current_updates';

    protected $fillable = [
        'value',
        'label',
        'bg_color',
        'text_color',
        'sort_order',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderBy('id');
    }
}
