@php $isEdit = isset($update); @endphp

@if($errors->any())
    <div class="alert alert-danger">
        <ul class="mb-0">@foreach($errors->all() as $e)<li>{{ $e }}</li>@endforeach</ul>
    </div>
@endif

<div class="row g-3">
    <div class="col-md-4">
        <label class="form-label fw-semibold">Value *</label>
        <input type="text" name="value" class="form-control" required
               value="{{ old('value', $update->value ?? '') }}" placeholder="20">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Sort order</label>
        <input type="number" name="sort_order" class="form-control" min="0"
               value="{{ old('sort_order', $update->sort_order ?? 0) }}">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Status</label>
        <select name="is_active" class="form-select">
            <option value="1" @selected((string) old('is_active', $isEdit ? (int)$update->is_active : 1) === '1')>Active</option>
            <option value="0" @selected((string) old('is_active', $isEdit ? (int)$update->is_active : 1) === '0')>Inactive</option>
        </select>
    </div>
    <div class="col-12">
        <label class="form-label fw-semibold">Label *</label>
        <textarea name="label" class="form-control" rows="2" required
                  placeholder="Healthcare&#10;Givers">{{ old('label', $update->label ?? '') }}</textarea>
        <div class="form-text">Use a new line for two-line labels on the app.</div>
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Background color</label>
        <input type="color" name="bg_color" class="form-control form-control-color w-100"
               value="{{ old('bg_color', $update->bg_color ?? '#EFF6FF') }}">
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Text color</label>
        <input type="color" name="text_color" class="form-control form-control-color w-100"
               value="{{ old('text_color', $update->text_color ?? '#1D4ED8') }}">
    </div>
</div>
