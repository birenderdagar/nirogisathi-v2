@extends('layouts.admin')

@section('title', 'Employee Details')
@section('page-title', 'Employee Details')

@section('content')

<div class="card shadow-sm">

    {{-- HEADER --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="{{ route('employees.index') }}"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Employee Profile
        </h3>

        <a href="{{ route('employees.edit', $employee->id) }}"
           class="btn btn-warning">
            Edit Employee
        </a>

    </div>


    {{-- BODY --}}
    <div class="card-body">

        <div class="row">

            {{-- PHOTO --}}
            <div class="col-md-3 text-center">

                <img
                    src="{{ $employee->photo
                        ? asset('storage/' . $employee->photo)
                        : 'https://ui-avatars.com/api/?name=' . urlencode($employee->name) }}"
                    class="img-fluid rounded-circle border shadow"
                    width="180"
                    height="180"
                >

            </div>


            {{-- DETAILS --}}
            <div class="col-md-9">

                <table class="table table-bordered">

                    <tr>
                        <th width="220">Employee ID</th>
                        <td>
                            <span class="badge bg-dark">
                                {{ $employee->employee_id }}
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>Full Name</th>
                        <td>{{ $employee->name }}</td>
                    </tr>

                    <tr>
                        <th>Mobile</th>
                        <td>{{ $employee->mobile }}</td>
                    </tr>

                    <tr>
                        <th>Email</th>
                        <td>{{ $employee->email ?? '-' }}</td>
                    </tr>

                    <tr>
                        <th>Staff Role</th>
                        <td>
                            <span class="badge bg-info">
                                {{ ucfirst($employee->designation) }}
                            </span>
                        </td>
                    </tr>

                    @php
                        $selectedRole = collect($staffRoles)->firstWhere('name', $employee->designation);
                    @endphp

                    @if($selectedRole)
                        <tr>
                            <th>Role Description</th>
                            <td>{{ $selectedRole['description'] }}</td>
                        </tr>
                    @endif

                    <tr>
                        <th>Joining Date</th>
                        <td>
                            {{ $employee->joining_date ?? '-' }}
                        </td>
                    </tr>

                    <tr>
                        <th>Status</th>
                        <td>
                            <span class="badge {{ $employee->status ? 'bg-success' : 'bg-danger' }}">
                                {{ $employee->status ? 'Active' : 'Inactive' }}
                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>Created At</th>
                        <td>
                            {{ $employee->created_at->format('d M Y h:i A') }}
                        </td>
                    </tr>

                </table>

            </div>

        </div>

    </div>

</div>

@endsection