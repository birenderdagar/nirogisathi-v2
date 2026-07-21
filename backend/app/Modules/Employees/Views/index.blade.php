@extends('layouts.admin')

@section('title', 'Employees')
@section('page-title', 'Employee Management')

@section('content')

<div class="card shadow-sm">

    {{-- CARD HEADER --}}
    <div class="card-header d-flex justify-content-between align-items-center">

        {{-- BACK BUTTON --}}
        <a href="{{ route('admin.dashboard') }}"
           class="btn btn-secondary btn-sm">
            ← Dashboard
        </a>

        {{-- TITLE --}}
        <h3 class="card-title mb-0">
            Employees Management
        </h3>

        {{-- ADD BUTTON --}}
        <a href="{{ route('employees.create') }}"
           class="btn btn-primary">
            + Add Employee
        </a>

    </div>


    {{-- CARD BODY --}}
    <div class="card-body table-responsive">

        <table class="table table-hover table-bordered align-middle">

            {{-- TABLE HEADER --}}
            <thead class="table-dark">
                <tr>
                    <th>Employee ID</th>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>Staff Role</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th width="330">Actions</th>
                </tr>
            </thead>


            {{-- TABLE BODY --}}
            <tbody>

                @forelse($employees as $employee)

                <tr>

                    {{-- EMPLOYEE ID --}}
                    <td>
                        <span class="badge bg-dark">
                            {{ $employee->employee_id }}
                        </span>
                    </td>


                    {{-- PHOTO --}}
                    <td>
                        <img
                            src="{{ $employee->photo
                                ? asset('storage/' . $employee->photo)
                                : 'https://ui-avatars.com/api/?name=' . urlencode($employee->name) }}"
                            width="45"
                            height="45"
                            class="rounded-circle border"
                        >
                    </td>


                    {{-- NAME --}}
                    <td>{{ $employee->name }}</td>

                    {{-- MOBILE --}}
                    <td>{{ $employee->mobile }}</td>

                    {{-- EMAIL --}}
                    <td>{{ $employee->email ?? '-' }}</td>

                    {{-- DESIGNATION --}}
                    <td>
                        <span class="badge bg-info">
                            {{ ucfirst($employee->designation) }}
                        </span>
                    </td>

                    {{-- STATUS --}}
                    <td>
                        <span class="badge {{ $employee->status ? 'bg-success' : 'bg-danger' }}">
                            {{ $employee->status ? 'Active' : 'Inactive' }}
                        </span>
                    </td>

                    {{-- CREATED --}}
                    <td>
                        {{ $employee->created_at->format('d M Y') }}
                    </td>


                    {{-- ACTIONS --}}
                    <td class="d-flex gap-1 flex-wrap">

                        {{-- VIEW --}}
                        <a href="{{ route('employees.show', $employee->id) }}"
                        class="btn btn-sm btn-info">
                            View
                        </a>

                        {{-- EDIT --}}
                        <a href="{{ route('employees.edit', $employee->id) }}"
                        class="btn btn-sm btn-warning">
                            Edit
                        </a>

                        {{-- BLOCK / UNBLOCK --}}
                        <form action="{{ route('employees.toggle-status', $employee->id) }}"
                            method="POST">

                            @csrf
                            @method('PATCH')

                            <button type="submit"
                                    class="btn btn-sm btn-dark">

                                {{ $employee->status ? 'Block' : 'Unblock' }}

                            </button>

                        </form>

                        {{-- DELETE --}}
                        <form action="{{ route('employees.destroy', $employee->id) }}"
                            method="POST">

                            @csrf
                            @method('DELETE')

                            <button type="submit"
                                    class="btn btn-sm btn-danger"
                                    onclick="return confirm('Delete this employee?')">
                                Delete
                            </button>

                        </form>

                    </td>

                </tr>

                @empty

                <tr>
                    <td colspan="9"
                        class="text-center text-muted">
                        No Employees Found
                    </td>
                </tr>

                @endforelse

            </tbody>

        </table>

    </div>

</div>


{{-- DELETE EMPLOYEE AJAX --}}
<script>
document.querySelectorAll('.delete-employee').forEach(btn => {

    btn.addEventListener('click', function () {

        if (!confirm('Delete this employee?')) return;

        let id = this.getAttribute('data-id');

        fetch(`/employees/${id}`, {

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