@extends('layouts.admin')

@section('title', 'Users')
@section('page-title', 'User Management')

@section('content')

{{-- =========================
    USERS CARD
========================= --}}
<div class="card shadow-sm">

    {{-- =========================
        CARD HEADER
    ========================= --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        {{-- BACK BUTTON --}}
        <a href="{{ route('admin.dashboard') }}"
        class="btn btn-secondary btn-sm">
        ← Dashboard
        </a>

        {{-- PAGE TITLE --}}
        <h3 class="card-title mb-0">
            Users Management
        </h3>

        {{-- ADD USER BUTTON --}}
        <a href="{{ route('admin.users.create') }}"
           class="btn btn-primary">
            + Add User
        </a>

    </div>


    {{-- =========================
        CARD BODY
    ========================= --}}
    <div class="card-body table-responsive">

        <table class="table table-hover table-bordered align-middle">

            {{-- TABLE HEADER --}}
            <thead class="table-dark">
                <tr>
                    <th>User ID</th>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Assigned Employee</th>
                    <th>Login Method</th>
                    <th>MPIN</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th width="330">Actions</th>
                </tr>
            </thead>


            {{-- TABLE BODY --}}
            <tbody>

                @forelse($users as $user)

                    @php
                        $loginMethod = ($user->mpin && $user->otp_verified_at)
                            ? 'OTP + MPIN'
                            : ($user->otp_verified_at ? 'OTP Only' : 'Not Verified');

                        $mpinStatus = $user->mpin ? 'Set' : 'Not Set';

                        $status = $user->status ?? 'active';
                    @endphp

                    <tr>

                        {{-- USER ID --}}
                                    <td>
                                    <span class="badge bg-dark">
                                     {{ $user->user_id }}
                                     </span>
                                    </td>
                        {{-- USER PHOTO --}}
                            <td>

                                @if($user->photo)

                                    <img
                                        src="{{ $user->photo_url }}"
                                        width="45"
                                        height="45"
                                        class="rounded-circle border"
                                        style="object-fit:cover;"
                                    >

                                @else

                                    <img
                                        src="https://ui-avatars.com/api/?name={{ urlencode($user->name) }}"
                                        width="45"
                                        height="45"
                                        class="rounded-circle border"
                                    >

                                @endif

                            </td>

                        {{-- NAME --}}
                        <td>{{ $user->name }}</td>

                        {{-- MOBILE --}}
                        <td>{{ $user->mobile }}</td>

                        {{-- EMAIL --}}
                        <td>{{ $user->email ?? '-' }}</td>

                        {{-- ROLE --}}
                        <td>
                            <span class="badge bg-info">
                                {{ ucfirst($user->role) }}
                            </span>
                        </td>

                        {{-- ASSIGNED EMPLOYEE --}}
                        <td>
                            <span class="badge bg-secondary text-dark">
                                {{ optional($user->assignedEmployee)->name ?? $user->employee_id ?? '-' }}
                            </span>
                        </td>

                        {{-- LOGIN METHOD --}}
                        <td>
                            <span class="badge bg-primary">
                                {{ $loginMethod }}
                            </span>
                        </td>

                        {{-- MPIN STATUS --}}
                        <td>
                            <span class="badge {{ $mpinStatus === 'Set' ? 'bg-success' : 'bg-warning' }}">
                                {{ $mpinStatus }}
                            </span>
                        </td>

                        {{-- ACCOUNT STATUS --}}
                        <td>
                            <span class="badge {{ $status === 'active' ? 'bg-success' : 'bg-danger' }}">
                                {{ ucfirst($status) }}
                            </span>
                        </td>

                        {{-- CREATED DATE --}}
                        <td>
                            {{ $user->created_at->format('d M Y') }}
                        </td>


                        {{-- =========================
                            ACTION BUTTONS
                        ========================= --}}
                        <td class="d-flex gap-1 flex-wrap">

                            {{-- VIEW USER --}}
                            <a href="{{ route('admin.users.edit', $user->id) }}"
                               class="btn btn-sm btn-info">
                                View
                            </a>

                            {{-- EDIT USER --}}
                            <a href="{{ route('admin.users.edit', $user->id) }}"
                               class="btn btn-sm btn-warning">
                                Edit
                            </a>

                            {{-- BLOCK / UNBLOCK USER --}}
                            <form action="{{ route('admin.users.toggle-status', $user->id) }}"
                                  method="POST">

                                @csrf
                                @method('PATCH')

                                <button type="submit"
                                        class="btn btn-sm btn-dark">

                                    {{ $status === 'active'
                                        ? 'Block'
                                        : 'Unblock' }}

                                </button>
                            </form>


                            {{-- DELETE USER --}}
                            <button
                            class="btn btn-sm btn-danger delete-user"
                            data-id="{{ $user->id }}">
                            Delete
                            </button>

                        </td>

                    </tr>

                @empty

                    {{-- NO USERS --}}
                    <tr>
                        <td colspan="10"
                            class="text-center text-muted">
                            No users found.
                        </td>
                    </tr>

                @endforelse

            </tbody>

        </table>

    </div>

</div>
</div>

{{-- DELETE USER AJAX SCRIPT --}}
<script>
document.querySelectorAll('.delete-user').forEach(btn => {

    btn.addEventListener('click', function () {

        if (!confirm('Delete this user?')) return;

        let id = this.getAttribute('data-id');

        fetch(`/admin/users/${id}`, {
            method: 'DELETE',

            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Accept': 'application/json'
            }

        })
        .then(res => res.json())
        .then(data => {

            if (data.success) {
                location.reload();
            }

        });

    });

});
</script>

@endsection
