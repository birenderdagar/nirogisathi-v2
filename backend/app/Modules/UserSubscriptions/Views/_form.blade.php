@php
    $selectedUserId = old(
        'user_id',
        $item->user_id ?? ($preselectedUserId ?? '')
    );
@endphp

@if($errors->any())
    <div class="alert alert-danger">
        <ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul>
    </div>
@endif

<div class="row g-3">
    <div class="col-md-6">
        <label class="form-label fw-semibold">User * <small class="text-muted">(from Users module)</small></label>
        <select name="user_id" class="form-select" required>
            <option value="">Select user</option>
            @foreach($users as $user)
                <option value="{{ $user->id }}"
                    @selected((string) $selectedUserId === (string) $user->id)>
                    {{ $user->name }} ({{ $user->mobile }}) — {{ $user->user_id }}
                    @if(($user->status ?? 'active') !== 'active') [{{ $user->status }}] @endif
                </option>
            @endforeach
        </select>
        <div class="form-text">
            Assign employees only in <strong>Users</strong> module. New users appear here automatically.
        </div>
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Plan *</label>
        <select name="subscription_id" class="form-select" required>
            <option value="">Select plan</option>
            @foreach($plans as $plan)
                <option value="{{ $plan->id }}"
                    @selected((string) old('subscription_id', $item->subscription_id ?? '') === (string) $plan->id)>
                    {{ $plan->name }} — {{ $plan->price_display }}
                </option>
            @endforeach
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Status *</label>
        <select name="status" class="form-select" required>
            @foreach(['active','expired','cancelled'] as $status)
                <option value="{{ $status }}" @selected(old('status', $item->status ?? 'active') === $status)>
                    {{ ucfirst($status) }}
                </option>
            @endforeach
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Payment method</label>
        <input type="text" name="payment_method" class="form-control"
               value="{{ old('payment_method', $item->payment_method ?? 'admin') }}" placeholder="upi / card / admin">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Payment ref</label>
        <input type="text" name="payment_ref" class="form-control"
               value="{{ old('payment_ref', $item->payment_ref ?? '') }}">
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Starts at</label>
        <input type="datetime-local" name="starts_at" class="form-control"
               value="{{ old('starts_at', isset($item) && $item->starts_at ? $item->starts_at->format('Y-m-d\\TH:i') : '') }}">
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Ends at</label>
        <input type="datetime-local" name="ends_at" class="form-control"
               value="{{ old('ends_at', isset($item) && $item->ends_at ? $item->ends_at->format('Y-m-d\\TH:i') : '') }}">
    </div>
</div>
