<?php

namespace App\Modules\Subscriptions\Controllers;

use App\Http\Controllers\Controller;
use App\Modules\Subscriptions\Models\Subscription;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class SubscriptionController extends Controller
{
    public function index()
    {
        $subscriptions = Subscription::ordered()->get();
        return view('Subscriptions::index', compact('subscriptions'));
    }

    public function create()
    {
        return view('Subscriptions::create', [
            'appRoutes' => Subscription::APP_ROUTES,
            'icons' => Subscription::ICONS,
        ]);
    }

    public function store(Request $request)
    {
        Subscription::create($this->validated($request));

        return redirect()
            ->route('subscriptions.index')
            ->with('success', 'Subscription plan added successfully');
    }

    public function show($id)
    {
        $subscription = Subscription::findOrFail($id);
        return view('Subscriptions::show', compact('subscription'));
    }

    public function edit($id)
    {
        $subscription = Subscription::findOrFail($id);
        return view('Subscriptions::edit', [
            'subscription' => $subscription,
            'appRoutes' => Subscription::APP_ROUTES,
            'icons' => Subscription::ICONS,
        ]);
    }

    public function update(Request $request, $id)
    {
        $subscription = Subscription::findOrFail($id);
        $subscription->update($this->validated($request, $subscription->id));

        return redirect()
            ->route('subscriptions.index')
            ->with('success', 'Subscription plan updated successfully');
    }

    public function destroy($id)
    {
        Subscription::findOrFail($id)->delete();

        return redirect()
            ->route('subscriptions.index')
            ->with('success', 'Subscription plan deleted successfully');
    }

    public function toggleStatus($id)
    {
        $subscription = Subscription::findOrFail($id);
        $subscription->is_active = !$subscription->is_active;
        $subscription->save();

        return back()->with('success', 'Status updated');
    }

    private function validated(Request $request, ?int $id = null): array
    {
        $data = $request->validate([
            'name' => 'required|string|max:120',
            'slug' => 'nullable|string|max:120|unique:subscriptions,slug,' . ($id ?? 'NULL') . ',id',
            'price_display' => 'required|string|max:50',
            'billing_label' => 'nullable|string|max:120',
            'pay_button_text' => 'nullable|string|max:80',
            'icon' => 'nullable|string|max:40',
            'price' => 'nullable|numeric|min:0',
            'accent_color' => 'nullable|string|max:20',
            'app_route' => 'nullable|string|max:120',
            'description' => 'nullable|string|max:500',
            'features_text' => 'nullable|string',
            'sort_order' => 'nullable|integer|min:0|max:9999',
            'is_active' => 'nullable|boolean',
        ]);

        $data['slug'] = Str::slug($data['slug'] ?: $data['name']);
        if ($data['slug'] === '') {
            $data['slug'] = 'plan-' . time();
        }
        // Always use canonical app route so Flutter never hits unknown paths.
        $data['app_route'] = '/subscription-plan/' . $data['slug'];
        $data['accent_color'] = $data['accent_color'] ?: '#F97316';
        $data['icon'] = $data['icon'] ?: 'awesome';
        $data['billing_label'] = $data['billing_label'] ?: $data['price_display'] . ' per Month';
        $data['pay_button_text'] = $data['pay_button_text'] ?: ('Pay ' . $data['price_display']);
        $data['price'] = $data['price'] ?? 0;
        $data['sort_order'] = (int) ($data['sort_order'] ?? 0);
        $data['is_active'] = $request->boolean('is_active', true);
        $data['features'] = Subscription::parseFeaturesText((string) $request->input('features_text', ''));
        unset($data['features_text']);

        return $data;
    }
}
