@php
    $isEdit = isset($subscription);
    $featuresText = old('features_text');
    if ($featuresText === null && $isEdit) {
        $featuresText = \App\Modules\Subscriptions\Models\Subscription::featuresToText($subscription->features);
    }
@endphp

@if($errors->any())
    <div class="alert alert-danger">
        <ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul>
    </div>
@endif

<div class="row g-3">
    <div class="col-md-6">
        <label class="form-label fw-semibold">Plan name *</label>
        <input type="text" name="name" class="form-control" required value="{{ old('name', $subscription->name ?? '') }}">
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Slug</label>
        <input type="text" name="slug" class="form-control" value="{{ old('slug', $subscription->slug ?? '') }}" placeholder="basic">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Homepage price chip *</label>
        <input type="text" name="price_display" class="form-control" required
               value="{{ old('price_display', $subscription->price_display ?? '') }}" placeholder="₹150.00">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Billing label</label>
        <input type="text" name="billing_label" class="form-control"
               value="{{ old('billing_label', $subscription->billing_label ?? '') }}" placeholder="150/- per Month">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Pay button text</label>
        <input type="text" name="pay_button_text" class="form-control"
               value="{{ old('pay_button_text', $subscription->pay_button_text ?? '') }}" placeholder="Pay 150/-">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Numeric price</label>
        <input type="number" step="0.01" name="price" class="form-control"
               value="{{ old('price', $subscription->price ?? 0) }}">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Accent color</label>
        <input type="color" name="accent_color" class="form-control form-control-color w-100"
               value="{{ old('accent_color', $subscription->accent_color ?? '#F97316') }}">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Header icon</label>
        <select name="icon" class="form-select">
            @foreach($icons as $value => $label)
                <option value="{{ $value }}" @selected(old('icon', $subscription->icon ?? 'awesome') === $value)>{{ $label }}</option>
            @endforeach
        </select>
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">App route</label>
        <input type="text" class="form-control" disabled
               value="/subscription-plan/{{ old('slug', $subscription->slug ?? '{slug}') }}">
        <input type="hidden" name="app_route"
               value="/subscription-plan/{{ old('slug', $subscription->slug ?? '') }}">
        <div class="form-text">Auto-generated from slug. App opens any plan via this path.</div>
    </div>
    <div class="col-md-3">
        <label class="form-label fw-semibold">Sort order</label>
        <input type="number" name="sort_order" class="form-control" min="0"
               value="{{ old('sort_order', $subscription->sort_order ?? 0) }}">
    </div>
    <div class="col-md-3">
        <label class="form-label fw-semibold">Status</label>
        <select name="is_active" class="form-select">
            <option value="1" @selected((string) old('is_active', $isEdit ? (int)$subscription->is_active : 1) === '1')>Active</option>
            <option value="0" @selected((string) old('is_active', $isEdit ? (int)$subscription->is_active : 1) === '0')>Inactive</option>
        </select>
    </div>
    <div class="col-12">
        <label class="form-label fw-semibold">Short description</label>
        <input type="text" name="description" class="form-control"
               value="{{ old('description', $subscription->description ?? '') }}">
    </div>
    <div class="col-12">
        <label class="form-label fw-semibold">Features (lock system)</label>
        <textarea name="features_text" class="form-control font-monospace" rows="16">{{ $featuresText }}</textarea>
        <div class="form-text">
            Use this format (same as app):<br>
            <code># Section title</code><br>
            <code>- unlock: Included feature text</code><br>
            <code>- lock: Locked feature text (shows lock icon)</code>
        </div>
    </div>
</div>
