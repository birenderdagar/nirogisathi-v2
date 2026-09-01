@extends('layouts.admin')
@section('title', 'Assign Subscription')
@section('content')
<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="{{ route('user-subscriptions.index') }}" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Assign Subscription</h3>
        <span></span>
    </div>
    <div class="card-body">
        <form method="POST" action="{{ route('user-subscriptions.store') }}">
            @csrf
            @include('UserSubscriptions::_form')
            <div class="mt-4 d-flex gap-2">
                <button class="btn btn-primary" type="submit">Save</button>
                <a href="{{ route('user-subscriptions.index') }}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
@endsection
