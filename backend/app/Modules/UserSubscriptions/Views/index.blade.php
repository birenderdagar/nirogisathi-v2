@extends('layouts.admin')
@section('title', 'User Subscriptions')
@section('content')
<div class="card shadow-sm">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
        <a href="{{ route('admin.dashboard') }}" class="btn btn-secondary btn-sm">← Dashboard</a>
        <div class="text-center">
            <h3 class="mb-0">User Subscriptions</h3>
            <small class="text-muted">
                Auto-synced from Users · {{ $totalUsers }} users · {{ $activeCount }} active plans
            </small>
        </div>
        <a href="{{ route('user-subscriptions.create') }}" class="btn btn-primary">+ Assign Plan</a>
    </div>
    <div class="card-body">
        @if(session('success'))
            <div class="alert alert-success">{{ session('success') }}</div>
        @endif

        <form method="GET" class="row g-2 mb-3">
            <div class="col-md-8">
                <input type="text" name="q" value="{{ $search }}" class="form-control"
                       placeholder="Search users by name, mobile, user ID, email...">
            </div>
            <div class="col-md-4 d-flex gap-2">
                <button class="btn btn-outline-primary" type="submit">Search</button>
                <a href="{{ route('user-subscriptions.index') }}" class="btn btn-outline-secondary">Reset</a>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Plan</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Period</th>
                        <th width="180">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($rows as $row)
                        @php
                            $user = $row['user'];
                            $sub = $row['subscription'];
                            $isActive = $row['is_active'];
                        @endphp
                        <tr>
                            <td>
                                <div class="fw-semibold">{{ $user->name }}</div>
                                <small class="text-muted d-block">{{ $user->user_id }} · {{ $user->mobile }}</small>
                                @if($user->email)
                                    <small class="text-muted">{{ $user->email }}</small>
                                @endif
                            </td>
                            <td>
                                @if($sub)
                                    <div>{{ $sub->plan_name }}</div>
                                    <small class="text-muted">{{ $sub->plan_slug }}</small>
                                @else
                                    <span class="text-muted">No plan yet</span>
                                @endif
                            </td>
                            <td>
                                @if($sub)
                                    {{ $sub->price_display ?? ('₹' . number_format((float) $sub->price, 2)) }}
                                @else
                                    —
                                @endif
                            </td>
                            <td>
                                @if($isActive)
                                    <span class="badge bg-success">Active</span>
                                @elseif($sub)
                                    <span class="badge bg-secondary">{{ ucfirst($sub->status) }}</span>
                                @else
                                    <span class="badge bg-warning text-dark">Not subscribed</span>
                                @endif
                            </td>
                            <td>
                                @if($sub)
                                    <small>
                                        {{ optional($sub->starts_at)->format('d M Y') }}
                                        →
                                        {{ optional($sub->ends_at)->format('d M Y') }}
                                    </small>
                                @else
                                    —
                                @endif
                            </td>
                            <td>
                                @if($sub)
                                    <a href="{{ route('user-subscriptions.edit', $sub->id) }}" class="btn btn-sm btn-warning">Edit</a>
                                    <form action="{{ route('user-subscriptions.destroy', $sub->id) }}" method="POST" class="d-inline"
                                          onsubmit="return confirm('Remove this subscription record?')">
                                        @csrf
                                        @method('DELETE')
                                        <button class="btn btn-sm btn-danger">Del</button>
                                    </form>
                                @else
                                    <a href="{{ route('user-subscriptions.create', ['user_id' => $user->id]) }}"
                                       class="btn btn-sm btn-primary">Assign Plan</a>
                                @endif
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                No users found. Create a user first under Users — they will appear here automatically.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
