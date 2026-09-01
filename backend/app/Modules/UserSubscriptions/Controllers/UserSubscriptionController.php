<?php

namespace App\Modules\UserSubscriptions\Controllers;

use App\Http\Controllers\Controller;
use App\Modules\Subscriptions\Models\Subscription;
use App\Modules\UserSubscriptions\Models\UserSubscription;
use App\Modules\Users\Models\User;
use Illuminate\Http\Request;

class UserSubscriptionController extends Controller
{
    public function index(Request $request)
    {
        $search = trim((string) $request->get('q', ''));

        $usersQuery = User::with(['subscriptions' => function ($q) {
            $q->latest('starts_at');
        }])->latest();

        if ($search !== '') {
            $usersQuery->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                    ->orWhere('mobile', 'like', "%{$search}%")
                    ->orWhere('user_id', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $users = $usersQuery->get()->map(function (User $user) {
            $active = $user->subscriptions
                ->first(fn (UserSubscription $sub) => $sub->is_active);

            $latest = $active ?: $user->subscriptions->first();

            return [
                'user' => $user,
                'subscription' => $latest,
                'is_active' => (bool) $active,
            ];
        });

        return view('UserSubscriptions::index', [
            'rows' => $users,
            'search' => $search,
            'totalUsers' => $users->count(),
            'activeCount' => $users->where('is_active', true)->count(),
        ]);
    }

    public function create(Request $request)
    {
        return view('UserSubscriptions::create', array_merge(
            $this->formData(),
            ['preselectedUserId' => $request->get('user_id')]
        ));
    }

    public function store(Request $request)
    {
        $data = $this->validated($request);
        $this->activateForUser($data);

        return redirect()
            ->route('user-subscriptions.index')
            ->with('success', 'User subscription saved successfully');
    }

    public function edit($id)
    {
        $item = UserSubscription::findOrFail($id);

        return view('UserSubscriptions::edit', array_merge(
            $this->formData(),
            ['item' => $item]
        ));
    }

    public function update(Request $request, $id)
    {
        $item = UserSubscription::findOrFail($id);
        $data = $this->validated($request, $item->id);

        if (($data['status'] ?? '') === 'active') {
            UserSubscription::where('user_id', $data['user_id'])
                ->where('id', '!=', $item->id)
                ->where('status', 'active')
                ->update(['status' => 'expired', 'ends_at' => now()]);
        }

        $item->update($data);

        return redirect()
            ->route('user-subscriptions.index')
            ->with('success', 'User subscription updated');
    }

    public function destroy($id)
    {
        UserSubscription::findOrFail($id)->delete();

        return redirect()
            ->route('user-subscriptions.index')
            ->with('success', 'User subscription deleted');
    }

    private function formData(): array
    {
        return [
            // Always live from Users module — new users appear automatically.
            'users' => User::orderBy('name')->get(['id', 'name', 'mobile', 'user_id', 'employee_id', 'email', 'status']),
            'plans' => Subscription::ordered()->get(),
        ];
    }

    private function validated(Request $request, ?int $id = null): array
    {
        $data = $request->validate([
            'user_id' => 'required|exists:users,id',
            'subscription_id' => 'nullable|exists:subscriptions,id',
            'status' => 'required|in:active,expired,cancelled',
            'payment_method' => 'nullable|string|max:80',
            'payment_ref' => 'nullable|string|max:120',
            'starts_at' => 'nullable|date',
            'ends_at' => 'nullable|date|after_or_equal:starts_at',
        ]);

        $plan = null;
        if (!empty($data['subscription_id'])) {
            $plan = Subscription::find($data['subscription_id']);
        }

        $user = User::findOrFail($data['user_id']);

        $data['plan_name'] = $plan?->name ?? $request->input('plan_name', 'Custom');
        $data['plan_slug'] = $plan?->slug ?? $request->input('plan_slug', 'custom');
        $data['price'] = $plan?->price ?? 0;
        $data['price_display'] = $plan?->price_display;
        $data['billing_label'] = $plan?->billing_label;
        $data['features'] = $plan?->feature_sections ?? [];
        // Employee is managed only in Users module.
        $data['assigned_employee_id'] = $user->employee_id;
        $data['starts_at'] = $data['starts_at'] ?? now();
        $data['ends_at'] = $data['ends_at'] ?? now()->addMonth();

        return $data;
    }

    private function activateForUser(array $data): UserSubscription
    {
        if (($data['status'] ?? 'active') === 'active') {
            UserSubscription::where('user_id', $data['user_id'])
                ->where('status', 'active')
                ->update(['status' => 'expired', 'ends_at' => now()]);
        }

        return UserSubscription::create($data);
    }
}
