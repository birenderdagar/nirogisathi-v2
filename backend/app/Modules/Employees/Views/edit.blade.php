@extends('layouts.admin')

@section('title', 'Edit Employee')
@section('page-title', 'Edit Employee')

@section('content')

<div class="card shadow-sm">

    {{-- HEADER --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="{{ route('employees.index') }}"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Edit Employee
        </h3>

        <span></span>

    </div>


    {{-- BODY --}}
    <div class="card-body">

        <form action="{{ route('employees.update', $employee->id) }}"
              method="POST"
              enctype="multipart/form-data">

            @csrf
            @method('PUT')


            <div class="row">

                {{-- LEFT --}}
                <div class="col-md-4 text-center">

                    <img
                        src="{{ $employee->photo
                            ? asset('storage/' . $employee->photo)
                            : 'https://ui-avatars.com/api/?name=' . urlencode($employee->name) }}"
                        class="img-fluid rounded-circle border shadow mb-3"
                        width="180"
                        height="180"
                    >

                    <div class="mb-3">
                        <label class="form-label">
                            Employee Photo
                        </label>

                        <input type="file"
                               name="photo"
                               class="form-control">
                    </div>

                </div>


                {{-- RIGHT --}}
                <div class="col-md-8">

                    <div class="mb-3">

                        <label class="form-label">
                            Employee ID
                        </label>

                        <input type="text"
                               class="form-control"
                               value="{{ $employee->employee_id }}"
                               readonly>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Full Name
                        </label>

                        <input type="text"
                               name="name"
                               class="form-control"
                               value="{{ $employee->name }}"
                               required>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Mobile
                        </label>

                        <input type="text"
                               name="mobile"
                               class="form-control"
                               value="{{ $employee->mobile }}"
                               required>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Email
                        </label>

                        <input type="email"
                               name="email"
                               class="form-control"
                               value="{{ $employee->email }}">

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Staff Role
                        </label>

                        <select name="designation"
                                class="form-control"
                                required>
                            @foreach($staffRoles as $role)
                                <option value="{{ $role['name'] }}"
                                    {{ old('designation', $employee->designation) === $role['name'] ? 'selected' : '' }}>
                                    {{ $role['name'] }}
                                </option>
                            @endforeach
                        </select>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Status
                        </label>

                        <select name="status"
                                class="form-control">

                            <option value="1"
                                {{ $employee->status ? 'selected' : '' }}>
                                Active
                            </option>

                            <option value="0"
                                {{ !$employee->status ? 'selected' : '' }}>
                                Inactive
                            </option>

                        </select>

                    </div>


                    <button type="submit"
                            class="btn btn-primary">

                        Update Employee

                    </button>

                </div>

            </div>

        </form>

    </div>

</div>

@endsection