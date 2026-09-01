@extends('layouts.admin')

@section('title', 'Banner Details')
@section('page-title', 'Banner Details')

@section('content')

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('banners.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Banner Details</h3>
        <a href="{{ route('banners.edit', $banner->id) }}" class="btn btn-warning">Edit</a>
    </div>

    <div class="card-body">
        <div class="row g-4">
            <div class="col-md-5">
                @if($banner->resolved_image_url)
                    <img src="{{ $banner->resolved_image_url }}"
                         alt="banner"
                         class="img-fluid rounded border"
                         style="width: 100%; max-height: 260px; object-fit: cover;">
                @endif
                <div class="mt-3 p-3 rounded" style="background: {{ $banner->bg_color }};">
                    <div class="fw-bold" style="white-space: pre-line; color: #00456A;">{{ $banner->title }}</div>
                    <button class="btn btn-sm mt-2" style="background:#00456A;color:#fff;" type="button">
                        {{ $banner->button_text }}
                    </button>
                </div>
            </div>
            <div class="col-md-7">
                <table class="table table-bordered">
                    <tr>
                        <th width="180">Status</th>
                        <td>
                            <span class="badge {{ $banner->is_active ? 'bg-success' : 'bg-secondary' }}">
                                {{ $banner->is_active ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>Sort order</th>
                        <td>{{ $banner->sort_order }}</td>
                    </tr>
                    <tr>
                        <th>Interaction</th>
                        <td>{{ $banner->action_label }}</td>
                    </tr>
                    <tr>
                        <th>Action value</th>
                        <td>{{ $banner->action_value ?: '—' }}</td>
                    </tr>
                    <tr>
                        <th>Open in new tab</th>
                        <td>{{ $banner->open_in_new_tab ? 'Yes' : 'No' }}</td>
                    </tr>
                    <tr>
                        <th>Created</th>
                        <td>{{ $banner->created_at?->format('d M Y H:i') }}</td>
                    </tr>
                    <tr>
                        <th>Updated</th>
                        <td>{{ $banner->updated_at?->format('d M Y H:i') }}</td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>

@endsection
