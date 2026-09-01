@php
    $isEdit = isset($banner);
    $actionType = old('action_type', $isEdit ? $banner->action_type : 'none');
@endphp

@if($errors->any())
    <div class="alert alert-danger">
        <ul class="mb-0">
            @foreach($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<div class="row g-4">
    <div class="col-lg-7">
        <div class="mb-3">
            <label class="form-label fw-semibold">Title *</label>
            <textarea name="title" class="form-control" rows="2" required
                      placeholder="PATIENTS ARE OUR&#10;PRIORITY">{{ old('title', $banner->title ?? '') }}</textarea>
            <div class="form-text">Use a new line for multi-line banner titles.</div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Button text *</label>
            <input type="text" name="button_text" class="form-control" required
                   value="{{ old('button_text', $banner->button_text ?? 'Book Now') }}">
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label fw-semibold">Background color</label>
                <input type="color" name="bg_color" class="form-control form-control-color w-100"
                       value="{{ old('bg_color', $banner->bg_color ?? '#E3F2FD') }}">
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label fw-semibold">Sort order</label>
                <input type="number" name="sort_order" class="form-control" min="0"
                       value="{{ old('sort_order', $banner->sort_order ?? 0) }}">
                <div class="form-text">Lower numbers show first.</div>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Status</label>
            <select name="is_active" class="form-select">
                <option value="1" @selected((string) old('is_active', $isEdit ? (int) $banner->is_active : 1) === '1')>Active</option>
                <option value="0" @selected((string) old('is_active', $isEdit ? (int) $banner->is_active : 1) === '0')>Inactive</option>
            </select>
        </div>
    </div>

    <div class="col-lg-5">
        <div class="mb-3">
            <label class="form-label fw-semibold">Banner image</label>
            <input type="file" name="image" class="form-control" accept="image/*">
            <div class="form-text">JPG/PNG/WEBP up to 4MB.</div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Or image URL</label>
            <input type="url" name="image_url" class="form-control"
                   placeholder="https://..."
                   value="{{ old('image_url', $banner->image_url ?? '') }}">
        </div>

        @if($isEdit && $banner->resolved_image_url)
            <div class="mb-3">
                <img src="{{ $banner->resolved_image_url }}" alt="preview"
                     class="img-fluid rounded border mb-2" style="max-height: 140px; object-fit: cover;">
                @if($banner->image_path)
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="remove_image" value="1" id="remove_image">
                        <label class="form-check-label" for="remove_image">Remove uploaded image</label>
                    </div>
                @endif
            </div>
        @endif
    </div>
</div>

<hr>

<h5 class="mb-3">Interactive options</h5>
<div class="row g-3">
    <div class="col-md-6">
        <label class="form-label fw-semibold">When button is tapped *</label>
        <select name="action_type" id="action_type" class="form-select" required>
            @foreach($actionTypes as $value => $label)
                <option value="{{ $value }}" @selected($actionType === $value)>{{ $label }}</option>
            @endforeach
        </select>
    </div>

    <div class="col-md-6" id="action_value_wrap">
        <label class="form-label fw-semibold" id="action_value_label">Action value</label>
        <input type="text" name="action_value" id="action_value" class="form-control"
               list="app_routes_list"
               value="{{ old('action_value', $banner->action_value ?? '') }}">
        <datalist id="app_routes_list">
            @foreach($appRoutes as $route => $label)
                <option value="{{ $route }}">{{ $label }}</option>
            @endforeach
        </datalist>
        <div class="form-text" id="action_value_help"></div>
    </div>

    <div class="col-md-6" id="new_tab_wrap">
        <div class="form-check mt-4">
            <input class="form-check-input" type="checkbox" name="open_in_new_tab" value="1" id="open_in_new_tab"
                   @checked(old('open_in_new_tab', $banner->open_in_new_tab ?? false))>
            <label class="form-check-label" for="open_in_new_tab">
                Open in new browser tab (external links)
            </label>
        </div>
    </div>
</div>

<script>
(function () {
    const typeEl = document.getElementById('action_type');
    const valueWrap = document.getElementById('action_value_wrap');
    const valueInput = document.getElementById('action_value');
    const valueLabel = document.getElementById('action_value_label');
    const valueHelp = document.getElementById('action_value_help');
    const newTabWrap = document.getElementById('new_tab_wrap');

    const help = {
        none: '',
        app_route: 'Pick an app screen (e.g. /subscription-pack or /doctors).',
        external_url: 'Full website URL starting with https:// (e.g. https://www.nirogisathi.com)',
        phone: 'Phone number with country code, e.g. +919876543210 — opens the dialer.',
        whatsapp: 'WhatsApp number with country code digits only, e.g. 919876543210',
    };

    const labels = {
        none: 'Action value',
        app_route: 'App route',
        external_url: 'Website URL',
        phone: 'Phone number to call',
        whatsapp: 'WhatsApp number',
    };

    function syncActionUi() {
        const type = typeEl.value;
        const showValue = type !== 'none';
        valueWrap.style.display = showValue ? '' : 'none';
        newTabWrap.style.display = type === 'external_url' ? '' : 'none';
        valueInput.required = showValue;
        valueLabel.textContent = labels[type] || 'Action value';
        valueHelp.textContent = help[type] || '';
        if (!showValue) {
            valueInput.value = '';
        }
    }

    typeEl.addEventListener('change', syncActionUi);
    syncActionUi();
})();
</script>
