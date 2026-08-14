

<?php $__env->startSection('title', 'Employee Details'); ?>
<?php $__env->startSection('page-title', 'Employee Details'); ?>

<?php $__env->startSection('content'); ?>

<div class="card shadow-sm">

    
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="<?php echo e(route('employees.index')); ?>"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Employee Profile
        </h3>

        <a href="<?php echo e(route('employees.edit', $employee->id)); ?>"
           class="btn btn-warning">
            Edit Employee
        </a>

    </div>


    
    <div class="card-body">

        <div class="row">

            
            <div class="col-md-3 text-center">

                <img
                    src="<?php echo e($employee->photo
                        ? asset('storage/' . $employee->photo)
                        : 'https://ui-avatars.com/api/?name=' . urlencode($employee->name)); ?>"
                    class="img-fluid rounded-circle border shadow"
                    width="180"
                    height="180"
                >

            </div>


            
            <div class="col-md-9">

                <table class="table table-bordered">

                    <tr>
                        <th width="220">Employee ID</th>
                        <td>
                            <span class="badge bg-dark">
                                <?php echo e($employee->employee_id); ?>

                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>Full Name</th>
                        <td><?php echo e($employee->name); ?></td>
                    </tr>

                    <tr>
                        <th>Mobile</th>
                        <td><?php echo e($employee->mobile); ?></td>
                    </tr>

                    <tr>
                        <th>Email</th>
                        <td><?php echo e($employee->email ?? '-'); ?></td>
                    </tr>

                    <tr>
                        <th>Staff Role</th>
                        <td>
                            <span class="badge bg-info">
                                <?php echo e(ucfirst($employee->designation)); ?>

                            </span>
                        </td>
                    </tr>

                    <?php
                        $selectedRole = collect($staffRoles)->firstWhere('name', $employee->designation);
                    ?>

                    <?php if($selectedRole): ?>
                        <tr>
                            <th>Role Description</th>
                            <td><?php echo e($selectedRole['description']); ?></td>
                        </tr>
                    <?php endif; ?>

                    <tr>
                        <th>Joining Date</th>
                        <td>
                            <?php echo e($employee->joining_date ?? '-'); ?>

                        </td>
                    </tr>

                    <tr>
                        <th>Status</th>
                        <td>
                            <span class="badge <?php echo e($employee->status ? 'bg-success' : 'bg-danger'); ?>">
                                <?php echo e($employee->status ? 'Active' : 'Inactive'); ?>

                            </span>
                        </td>
                    </tr>

                    <tr>
                        <th>Created At</th>
                        <td>
                            <?php echo e($employee->created_at->format('d M Y h:i A')); ?>

                        </td>
                    </tr>

                </table>

            </div>

        </div>

    </div>

</div>

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\nirogisathi-v3\backend\app\Modules/Employees/Views/show.blade.php ENDPATH**/ ?>