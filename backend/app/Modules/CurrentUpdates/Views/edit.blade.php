@extends('layouts.admin')
@section('title', 'Edit Current Update')
@section('content')
<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('current-updates.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Edit Current Update</h3>
        <span></span>
    </div>
    <div class="card-body">
        <form method="POST" action="{{ route('current-updates.update', $update->id) }}">
            @csrf
            @method('PUT')
            @include('CurrentUpdates::_form')
            <div class="mt-4 d-flex gap-2">
                <button class="btn btn-primary" type="submit">Update</button>
                <a href="{{ route('current-updates.index') }}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
@endsection
