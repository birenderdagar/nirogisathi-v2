<?php

namespace App\Modules\Subscriptions\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Modules\Subscriptions\Models\Subscription;

class SubscriptionApiController extends Controller
{
    public function index()
    {
        $plans = Subscription::active()->ordered()->get()->map(fn (Subscription $plan) => $this->transform($plan));

        return response()->json([
            'success' => true,
            'data' => $plans,
        ]);
    }

    public function show(string $slug)
    {
        $plan = Subscription::active()->where('slug', $slug)->firstOrFail();

        return response()->json([
            'success' => true,
            'data' => $this->transform($plan),
        ]);
    }

    private function transform(Subscription $plan): array
    {
        return [
            'id' => $plan->id,
            'name' => $plan->name,
            'slug' => $plan->slug,
            'price' => (float) $plan->price,
            'price_display' => $plan->price_display,
            'billing_label' => $plan->billing_label ?: $plan->description,
            'pay_button_text' => $plan->pay_button_text ?: ('Pay ' . $plan->price_display),
            'icon' => $plan->icon ?: 'awesome',
            'accent_color' => $plan->accent_color,
            'app_route' => '/subscription-plan/' . $plan->slug,
            'description' => $plan->description,
            'feature_sections' => $plan->feature_sections,
            'sort_order' => $plan->sort_order,
        ];
    }
}
