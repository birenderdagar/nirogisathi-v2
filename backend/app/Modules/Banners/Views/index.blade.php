@extends('layouts.admin')

@section('title', 'Banners')
@section('page-title', 'Homepage Banners')

@section('content')

@if(session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
@endif

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('admin.dashboard') }}" class="btn btn-secondary btn-sm">← Dashboard</a>
        <h3 class="card-title mb-0">Homepage Banners</h3>
        <a href="{{ route('banners.create') }}" class="btn btn-primary">+ Add Banner</a>
    </div>

    <div class="card-body table-responsive">
        <table class="table table-hover table-bordered align-middle">
            <thead class="table-dark">
                <tr>
                    <th width="70">Order</th>
                    <th width="90">Image</th>
                    <th>Title</th>
                    <th>CTA</th>
                    <th>Interaction</th>
                    <th>Status</th>
                    <th width="280">Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($banners as $banner)
                    <tr>
                        <td>
                            <span class="badge bg-dark">{{ $banner->sort_order }}</span>
                        </td>
                        <td>
                            @if($banner->resolved_image_url)
                                <img src="{{ $banner->resolved_image_url }}"
                                     alt="banner"
                                     width="70"
                                     height="45"
                                     class="rounded border"
                                     style="object-fit: cover;">
                            @else
                                <span class="text-muted">No image</span>
                            @endif
                        </td>
                        <td>
                            <div class="fw-semibold">{{ $banner->title }}</div>
                            <small class="text-muted">{{ $banner->bg_color }}</small>
                        </td>
                        <td>{{ $banner->button_text }}</td>
                        <td>
                            <div>{{ $banner->action_label }}</div>
                            @if($banner->action_value)
                                <small class="text-muted">{{ \Illuminate\Support\Str::limit($banner->action_value, 40) }}</small>
                            @endif
                        </td>
                        <td>
                            <span class="badge {{ $banner->is_active ? 'bg-success' : 'bg-secondary' }}">
                                {{ $banner->is_active ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                        <td class="d-flex gap-1 flex-wrap">
                            <a href="{{ route('banners.show', $banner->id) }}" class="btn btn-sm btn-info">View</a>
                            <a href="{{ route('banners.edit', $banner->id) }}" class="btn btn-sm btn-warning">Edit</a>
                            <form action="{{ route('banners.toggle-status', $banner->id) }}" method="POST">
                                @csrf
                                @method('PATCH')
                                <button type="submit" class="btn btn-sm btn-dark">
                                    {{ $banner->is_active ? 'Disable' : 'Enable' }}
                                </button>
                            </form>
                            <form action="{{ route('banners.destroy', $banner->id) }}" method="POST"
                                  onsubmit="return confirm('Delete this banner?')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" class="text-center text-muted py-4">
                            No banners yet. Click <strong>Add Banner</strong> to create one.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>

@endsection
