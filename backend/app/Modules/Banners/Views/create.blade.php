@extends('layouts.admin')

@section('title', 'Add Banner')
@section('page-title', 'Add Banner')

@section('content')

<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('banners.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Add Homepage Banner</h3>
        <span></span>
    </div>

    <div class="card-body">
        <form action="{{ route('banners.store') }}" method="POST" enctype="multipart/form-data">
            @csrf
            @include('Banners::_form')
            <div class="mt-4 d-flex gap-2">
                <button type="submit" class="btn btn-primary">Save Banner</button>
                <a href="{{ route('banners.index') }}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

@endsection
