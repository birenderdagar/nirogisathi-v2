@extends('layouts.admin')
@section('title', 'Subscription Details')
@section('content')
<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('subscriptions.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">{{ $subscription->name }}</h3>
        <a href="{{ route('subscriptions.edit', $subscription->id) }}" class="btn btn-warning">Edit</a>
    </div>
    <div class="card-body">
        <table class="table table-bordered mb-4">
            <tr><th width="180">Slug</th><td>{{ $subscription->slug }}</td></tr>
            <tr><th>Price chip</th><td>{{ $subscription->price_display }}</td></tr>
            <tr><th>Billing label</th><td>{{ $subscription->billing_label }}</td></tr>
            <tr><th>Pay button</th><td>{{ $subscription->pay_button_text }}</td></tr>
            <tr><th>Route</th><td><code>{{ $subscription->app_route }}</code></td></tr>
            <tr><th>Status</th><td>{{ $subscription->is_active ? 'Active' : 'Inactive' }}</td></tr>
        </table>

        <h5>Feature sections (lock system)</h5>
        @forelse($subscription->feature_sections as $section)
            <div class="border rounded p-3 mb-3">
                <div class="fw-bold text-primary mb-2">{{ $section['title'] }}</div>
                @foreach($section['items'] as $item)
                    <div class="d-flex gap-2 mb-1">
                        <span>{{ !empty($item['is_locked']) ? '🔒' : '✅' }}</span>
                        <span>{{ $item['text'] }}</span>
                    </div>
                @endforeach
            </div>
        @empty
            <p class="text-muted">No features configured.</p>
        @endforelse
    </div>
</div>
@endsection
