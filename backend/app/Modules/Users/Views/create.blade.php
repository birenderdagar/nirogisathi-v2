@extends('layouts.admin')

@section('title', 'Create User')
@section('page-title', 'Create User')

@section('content')

{{-- =========================
    CREATE USER CARD
========================= --}}
<div class="card shadow-sm">

    {{-- CARD HEADER --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="{{ route('admin.users.index') }}"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Create New User
        </h3>

        <span></span>

    </div>


    {{-- CARD BODY --}}
    <div class="card-body">

        <form action="{{ route('admin.users.store') }}"
              method="POST"
              enctype="multipart/form-data">

            @csrf


            


            {{-- PHOTO --}}
            <div class="mb-3">
                <label class="form-label">
                    Profile Photo
                </label>

                <input type="file"
                       name="photo"
                       class="form-control">
            </div>


            {{-- FULL NAME --}}
            <div class="mb-3">
                <label class="form-label">
                    Full Name
                </label>

                <input type="text"
                       name="name"
                       class="form-control"
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
                       required>
            </div>


            {{-- EMAIL --}}
            <div class="mb-3">
                <label class="form-label">
                    Email
                </label>

                <input type="email"
                       name="email"
                       class="form-control">
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
                                    data-email="{{ $employee->email }}">
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
                       value="{{ old('employee_id') }}">
            </div>


            {{-- MPIN --}}
            <div class="mb-3">
                <label class="form-label">
                    MPIN
                </label>

                <input type="password"
                       name="mpin"
                       class="form-control">
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
                });
            </script>


            {{-- ROLE --}}
            <div class="mb-3">
                <label class="form-label">
                    Role
                </label>

                <select name="role"
                        class="form-control">

                    <option value="user">User</option>
                    <option value="employee">Employee</option>
                    <option value="admin">Admin</option>

                </select>
            </div>


            {{-- STATUS --}}
            <div class="mb-3">
                <label class="form-label">
                    Status
                </label>

                <select name="status"
                        class="form-control">

                    <option value="active">Active</option>
                    <option value="blocked">Blocked</option>
                    <option value="suspended">Suspended</option>

                </select>
            </div>


            {{-- SUBMIT --}}
            <button type="submit"
                    class="btn btn-primary">

                Create User

            </button>

        </form>

    </div>

</div>

@endsection