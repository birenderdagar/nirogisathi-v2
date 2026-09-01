<?php

namespace App\Modules\UserSubscriptions\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Modules\Employees\Models\Employee;
use App\Modules\Subscriptions\Models\Subscription;
use App\Modules\UserSubscriptions\Models\UserSubscription;
use App\Modules\Users\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class UserSubscriptionApiController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | CURRENT USER SUBSCRIPTION
    |--------------------------------------------------------------------------
    */
    public function current(Request $request)
    {
        $user = $this->resolveUser($request);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User not found'], 404);
        }

        $active = UserSubscription::with('assignedEmployee')
            ->where('user_id', $user->id)
            ->active()
            ->latest('starts_at')
            ->first();

        return response()->json([
            'success' => true,
            'data' => [
                'has_active_subscription' => (bool) $active,
                'subscription' => $active ? $this->transformSubscription($active) : null,
                'health_assistant' => $this->transformAssistant($user, $active),
            ],
        ]);
    }

    /*
    |--------------------------------------------------------------------------
    | ACTIVATE AFTER PAYMENT
    |--------------------------------------------------------------------------
    */
    public function activate(Request $request)
    {
        $data = $request->validate([
            'user_id' => 'required',
            'subscription_id' => 'nullable|exists:subscriptions,id',
            'plan_slug' => 'nullable|string|max:120',
            'payment_method' => 'nullable|string|max:80',
            'payment_ref' => 'nullable|string|max:120',
        ]);

        $user = $this->resolveUser($request);
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User not found'], 404);
        }

        $plan = null;
        if (!empty($data['subscription_id'])) {
            $plan = Subscription::find($data['subscription_id']);
        } elseif (!empty($data['plan_slug'])) {
            $plan = Subscription::where('slug', $data['plan_slug'])->first();
        }

        if (!$plan) {
            return response()->json(['success' => false, 'message' => 'Subscription plan not found'], 404);
        }

        UserSubscription::where('user_id', $user->id)
            ->where('status', 'active')
            ->update(['status' => 'expired', 'ends_at' => now()]);

        $item = UserSubscription::create([
            'user_id' => $user->id,
            'subscription_id' => $plan->id,
            'plan_name' => $plan->name,
            'plan_slug' => $plan->slug,
            'price' => $plan->price,
            'price_display' => $plan->price_display,
            'billing_label' => $plan->billing_label,
            'features' => $plan->feature_sections,
            'status' => 'active',
            'payment_method' => $data['payment_method'] ?? 'upi',
            'payment_ref' => $data['payment_ref'] ?? ('PAY-' . Str::upper(Str::random(10))),
            'assigned_employee_id' => $user->employee_id,
            'starts_at' => now(),
            'ends_at' => now()->addMonth(),
        ]);

        $item->load('assignedEmployee');

        return response()->json([
            'success' => true,
            'message' => 'Subscription activated',
            'data' => [
                'has_active_subscription' => true,
                'subscription' => $this->transformSubscription($item),
                'health_assistant' => $this->transformAssistant($user, $item),
            ],
        ]);
    }

    private function resolveUser(Request $request): ?User
    {
        $raw = $request->input('user_id') ?? $request->input('id');
        if ($raw === null || $raw === '') {
            return null;
        }

        if (is_numeric($raw)) {
            return User::find((int) $raw);
        }

        return User::where('user_id', $raw)->first();
    }

    private function transformSubscription(UserSubscription $item): array
    {
        return [
            'id' => $item->id,
            'plan_name' => $item->plan_name,
            'plan_slug' => $item->plan_slug,
            'price' => (float) $item->price,
            'price_display' => $item->price_display,
            'billing_label' => $item->billing_label,
            'features' => $item->features ?? [],
            'status' => $item->status,
            'payment_method' => $item->payment_method,
            'payment_ref' => $item->payment_ref,
            'starts_at' => optional($item->starts_at)->toIso8601String(),
            'ends_at' => optional($item->ends_at)->toIso8601String(),
            'is_active' => $item->is_active,
        ];
    }

    private function transformAssistant(User $user, ?UserSubscription $active): ?array
    {
        if (!$active || !$active->is_active) {
            return null;
        }

        $employeeId = $user->employee_id;
        if (!$employeeId) {
            return [
                'name' => 'Health Assistant',
                'title' => 'Your Personal Health Assistant',
                'employee_id' => null,
                'mobile' => null,
                'photo_url' => null,
                'rating' => '4.8/5',
            ];
        }

        $employee = Employee::where('employee_id', $employeeId)->first();
        if (!$employee) {
            return null;
        }

        return [
            'name' => $employee->name,
            'title' => 'Your Personal Health Assistant',
            'employee_id' => $employee->employee_id,
            'mobile' => $employee->mobile,
            'email' => $employee->email,
            'photo_url' => $employee->photo
                ? asset('storage/' . $employee->photo)
                : null,
            'rating' => '4.8/5',
        ];
    }
}
