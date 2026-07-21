@extends('layouts.admin')

@section('title', 'Edit User')
@section('page-title', 'Edit User')

@section('content')

<div class="card shadow-sm">

    {{-- HEADER --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="{{ route('admin.users.index') }}"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Edit User
        </h3>

        <span></span>

    </div>


    {{-- BODY --}}
    <div class="card-body">

        <form action="{{ route('admin.users.update', $user->id) }}"
              method="POST"
              enctype="multipart/form-data">

            @csrf
            @method('PUT')


            {{-- PHOTO --}}
            <div class="mb-3">
                <label class="form-label">
                    Profile Photo
                </label>

                <input type="file"
                       name="photo"
                       class="form-control">

                @if($user->photo)
                    <img src="{{ asset('storage/'.$user->photo) }}"
                         width="70"
                         class="mt-2 rounded">
                @endif
            </div>


            {{-- USER ID --}}
            <div class="mb-3">
                <label class="form-label">
                    User ID
                </label>

                <input type="text"
                       class="form-control"
                       value="{{ $user->user_id }}"
                       readonly>
            </div>


            {{-- NAME --}}
            <div class="mb-3">
                <label class="form-label">
                    Full Name
                </label>

                <input type="text"
                       name="name"
                       class="form-control"
                       value="{{ $user->name }}"
                       required>
            </div>


            {{-- MOBILE --}}
            <div class="mb-3">
                <label class="form-label">
                    Mobile
                </label>

                <input type="text"
                       name="mobile"
                       class="form-control"
                       value="{{ $user->mobile }}"
                       required>
            </div>


            {{-- EMAIL --}}
            <div class="mb-3">
                <label class="form-label">
                    Email
                </label>

                <input type="email"
                       name="email"
                       class="form-control"
                       value="{{ $user->email }}">
            </div>


            {{-- ASSIGN EXISTING EMPLOYEE --}}
            <div class="mb-3">
                <label class="form-label">
                    Assign Existing Employee
                </label>

                <div class="input-group">
                    <select id="employee-selector"
                            class="form-control">
                        <option value="">Select an employee</option>

                        @forelse($employees as $employee)
                            <option value="{{ $employee->employee_id }}"
                                    data-name="{{ $employee->name }}"
                                    data-mobile="{{ $employee->mobile }}"
                                    data-email="{{ $employee->email }}"
                                    {{ $user->employee_id === $employee->employee_id ? 'selected' : '' }}>
                                {{ $employee->name }}
                                ({{ $employee->employee_id }})
                            </option>
                        @empty
                            <option value="" disabled>
                                No saved employees available
                            </option>
                        @endforelse
                    </select>

                    <button type="button"
                            id="apply-employee"
                            class="btn btn-outline-primary">
                        Assign Selected Employee
                    </button>
                </div>

                <input type="hidden"
                       name="employee_id"
                       id="employee_id"
                       value="{{ old('employee_id', $user->employee_id) }}">
            </div>


            {{-- ROLE --}}
            <div class="mb-3">
                <label class="form-label">
                    Role
                </label>

                <select name="role"
                        class="form-control">

                    <option value="user"
                        {{ $user->role == 'user' ? 'selected' : '' }}>
                        User
                    </option>

                    <option value="employee"
                        {{ $user->role == 'employee' ? 'selected' : '' }}>
                        Employee
                    </option>

                    <option value="admin"
                        {{ $user->role == 'admin' ? 'selected' : '' }}>
                        Admin
                    </option>

                </select>
            </div>


            {{-- STATUS --}}
            <div class="mb-3">
                <label class="form-label">
                    Status
                </label>

                <select name="status"
                        class="form-control">

                    <option value="active"
                        {{ $user->status == 'active' ? 'selected' : '' }}>
                        Active
                    </option>

                    <option value="blocked"
                        {{ $user->status == 'blocked' ? 'selected' : '' }}>
                        Blocked
                    </option>

                </select>
            </div>


            <button type="submit"
                    class="btn btn-primary">
                Update User
            </button>

        </form>

    </div>

</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const selector = document.getElementById('employee-selector');
        const button = document.getElementById('apply-employee');
        const hiddenInput = document.getElementById('employee_id');
        const roleField = document.querySelector('select[name="role"]');

        if (!selector || !button) {
            return;
        }

        button.addEventListener('click', function () {
            const selected = selector.options[selector.selectedIndex];

            if (!selected || !selected.value) {
                alert('Please select an employee first.');
                return;
            }

            hiddenInput.value = selected.value;

            if (roleField) {
                roleField.value = 'employee';
            }
        });
    });
</script>

@endsection