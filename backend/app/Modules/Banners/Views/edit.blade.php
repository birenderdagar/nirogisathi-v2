@extends('layouts.admin')

@section('title', 'Edit Banner')
@section('page-title', 'Edit Banner')

@section('content')

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('banners.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Edit Banner</h3>
        <span></span>
    </div>

    <div class="card-body">
        <form action="{{ route('banners.update', $banner->id) }}" method="POST" enctype="multipart/form-data">
            @csrf
            @method('PUT')
            @include('Banners::_form')
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary">Update Banner</button>
                <a href="{{ route('banners.index') }}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

@endsection
