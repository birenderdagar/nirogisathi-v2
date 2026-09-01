@extends('layouts.admin')
@section('title', 'Subscriptions')
@section('content')
@if(session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
@endif
<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('admin.dashboard') }}" class="btn btn-secondary btn-sm">← Dashboard</a>
        <h3 class="card-title mb-0">Subscription Plans</h3>
        <a href="{{ route('subscriptions.create') }}" class="btn btn-primary">+ Add Plan</a>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Order</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Route</th>
                    <th>Status</th>
                    <th width="300">Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($subscriptions as $plan)
                    <tr>
                        <td><span class="badge bg-dark">{{ $plan->sort_order }}</span></td>
                        <td>
                            <span class="fw-semibold">{{ $plan->name }}</span>
                            <div><small class="text-muted">{{ $plan->slug }}</small></div>
                        </td>
                        <td>
                            <span class="badge" style="background:{{ $plan->accent_color }};">{{ $plan->price_display }}</span>
                        </td>
                        <td><code>{{ $plan->app_route }}</code></td>
                        <td>
                            <span class="badge {{ $plan->is_active ? 'bg-success' : 'bg-secondary' }}">
                                {{ $plan->is_active ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                        <td class="d-flex gap-1 flex-wrap">
                            <a href="{{ route('subscriptions.show', $plan->id) }}" class="btn btn-sm btn-info">View</a>
                            <a href="{{ route('subscriptions.edit', $plan->id) }}" class="btn btn-sm btn-warning">Edit</a>
                            <form method="POST" action="{{ route('subscriptions.toggle-status', $plan->id) }}">
                                @csrf @method('PATCH')
                                <button class="btn btn-sm btn-dark">{{ $plan->is_active ? 'Disable' : 'Enable' }}</button>
                            </form>
                            <form method="POST" action="{{ route('subscriptions.destroy', $plan->id) }}" onsubmit="return confirm('Delete this plan?')">
                                @csrf @method('DELETE')
                                <button class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="6" class="text-center text-muted">No subscription plans yet.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection
