@extends('layouts.admin')

@section('title', 'Create Employee')
@section('page-title', 'Create Employee')

@section('content')

<div class="card shadow-sm">

    {{-- CARD HEADER --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="{{ route('employees.index') }}"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Create New Employee
        </h3>

        <span></span>

    </div>


    {{-- CARD BODY --}}
    <div class="card-body">

        <form action="{{ route('employees.store') }}"
              method="POST"
              enctype="multipart/form-data">

            @csrf


            {{-- PHOTO --}}
            <div class="mb-3">
                <label class="form-label">
                    Employee Photo
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


            {{-- STAFF ROLE --}}
            <div class="mb-3">
                <label class="form-label">
                    Staff Role
                </label>

                <select name="designation"
                        class="form-control"
                        required>
                    @foreach($staffRoles as $role)
                        <option value="{{ $role['name'] }}"
                            {{ old('designation') === $role['name'] ? 'selected' : '' }}>
                            {{ $role['name'] }}
                        </option>
                    @endforeach
                </select>
            </div>


            {{-- STATUS --}}
            <div class="mb-3">
                <label class="form-label">
                    Status
                </label>

                <select name="status"
                        class="form-control">

                    <option value="1">Active</option>
                    <option value="0">Inactive</option>

                </select>
            </div>


            {{-- SUBMIT --}}
            <button type="submit"
                    class="btn btn-primary">

                Create Employee

            </button>

        </form>

    </div>

</div>

@endsection