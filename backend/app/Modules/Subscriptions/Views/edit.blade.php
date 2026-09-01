@extends('layouts.admin')
@section('title', 'Edit Subscription')
@section('content')
<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('subscriptions.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Edit Subscription Plan</h3>
        <span></span>
    </div>
    <div class="card-body">
        <form method="POST" action="{{ route('subscriptions.update', $subscription->id) }}">
            @csrf
            @method('PUT')
            @include('Subscriptions::_form')
            <div class="mt-4 d-flex gap-2">
                <button class="btn btn-primary" type="submit">Update Plan</button>
                <a href="{{ route('subscriptions.index') }}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
@endsection
