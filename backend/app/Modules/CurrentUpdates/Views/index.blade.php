@extends('layouts.admin')

@section('title', 'Current Updates')

@section('content')
@if(session('success'))
    <div class="alert alert-success">{{ session('success') }}</div>
@endif

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('admin.dashboard') }}" class="btn btn-secondary btn-sm">← Dashboard</a>
        <h3 class="card-title mb-0">Current Updates</h3>
        <a href="{{ route('current-updates.create') }}" class="btn btn-primary">+ Add Update</a>
    </div>
    <div class="card-body table-responsive">
        <table class="table table-bordered table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Order</th>
                    <th>Value</th>
                    <th>Label</th>
                    <th>Colors</th>
                    <th>Status</th>
                    <th width="260">Actions</th>
                </tr>
            </thead>
            <tbody>
                @forelse($updates as $update)
                    <tr>
                        <td><span class="badge bg-dark">{{ $update->sort_order }}</span></td>
                        <td class="fw-bold">{{ $update->value }}</td>
                        <td style="white-space: pre-line;">{{ $update->label }}</td>
                        <td>
                            <span class="badge" style="background:{{ $update->bg_color }};color:{{ $update->text_color }};border:1px solid {{ $update->text_color }};">
                                Preview
                            </span>
                        </td>
                        <td>
                            <span class="badge {{ $update->is_active ? 'bg-success' : 'bg-secondary' }}">
                                {{ $update->is_active ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                        <td class="d-flex gap-1 flex-wrap">
                            <a href="{{ route('current-updates.edit', $update->id) }}" class="btn btn-sm btn-warning">Edit</a>
                            <form method="POST" action="{{ route('current-updates.toggle-status', $update->id) }}">
                                @csrf @method('PATCH')
                                <button class="btn btn-sm btn-dark">{{ $update->is_active ? 'Disable' : 'Enable' }}</button>
                            </form>
                            <form method="POST" action="{{ route('current-updates.destroy', $update->id) }}" onsubmit="return confirm('Delete this update?')">
                                @csrf @method('DELETE')
                                <button class="btn btn-sm btn-danger">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="6" class="text-center text-muted">No updates yet.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>
</div>
@endsection
