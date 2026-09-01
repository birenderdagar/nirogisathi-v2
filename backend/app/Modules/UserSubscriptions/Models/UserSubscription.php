<?php

namespace App\Modules\UserSubscriptions\Models;

use App\Modules\Employees\Models\Employee;
use App\Modules\Subscriptions\Models\Subscription;
use App\Modules\Users\Models\User;
use Illuminate\Database\Eloquent\Model;

class UserSubscription extends Model
{
    protected $table = 'user_subscriptions';

    protected $fillable = [
        'user_id',
        'subscription_id',
        'plan_name',
        'plan_slug',
        'price',
        'price_display',
        'billing_label',
        'features',
        'status',
        'payment_method',
        'payment_ref',
        'assigned_employee_id',
        'starts_at',
        'ends_at',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'features' => 'array',
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function plan()
    {
        return $this->belongsTo(Subscription::class, 'subscription_id');
    }

    public function assignedEmployee()
    {
        return $this->belongsTo(Employee::class, 'assigned_employee_id', 'employee_id');
    }

    public function scopeActive($query)
    {
        return $query->where('status', 'active')
            ->where(function ($q) {
                $q->whereNull('ends_at')->orWhere('ends_at', '>=', now());
            });
    }

    public function getIsActiveAttribute(): bool
    {
        if ($this->status !== 'active') {
            return false;
        }

        if ($this->ends_at && $this->ends_at->isPast()) {
            return false;
        }

        return true;
    }
}
