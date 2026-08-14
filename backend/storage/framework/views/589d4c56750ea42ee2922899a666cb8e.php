

<?php $__env->startSection('title', 'Employees'); ?>
<?php $__env->startSection('page-title', 'Employee Management'); ?>

<?php $__env->startSection('content'); ?>

<div class="card shadow-sm">

    
    <div class="card-header d-flex justify-content-between align-items-center">

        
        <a href="<?php echo e(route('admin.dashboard')); ?>"
           class="btn btn-secondary btn-sm">
            ← Dashboard
        </a>

        
        <h3 class="card-title mb-0">
            Employees Management
        </h3>

        
        <a href="<?php echo e(route('employees.create')); ?>"
           class="btn btn-primary">
            + Add Employee
        </a>

    </div>


    
    <div class="card-body table-responsive">

        <table class="table table-hover table-bordered align-middle">

            
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


            
            <tbody>

                <?php $__empty_1 = true; $__currentLoopData = $employees; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $employee): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>

                <tr>

                    
                    <td>
                        <span class="badge bg-dark">
                            <?php echo e($employee->employee_id); ?>

                        </span>
                    </td>


                    
                    <td>
                        <img
                            src="<?php echo e($employee->photo
                                ? asset('storage/' . $employee->photo)
                                : 'https://ui-avatars.com/api/?name=' . urlencode($employee->name)); ?>"
                            width="45"
                            height="45"
                            class="rounded-circle border"
                        >
                    </td>


                    
                    <td><?php echo e($employee->name); ?></td>

                    
                    <td><?php echo e($employee->mobile); ?></td>

                    
                    <td><?php echo e($employee->email ?? '-'); ?></td>

                    
                    <td>
                        <span class="badge bg-info">
                            <?php echo e(ucfirst($employee->designation)); ?>

                        </span>
                    </td>

                    
                    <td>
                        <span class="badge <?php echo e($employee->status ? 'bg-success' : 'bg-danger'); ?>">
                            <?php echo e($employee->status ? 'Active' : 'Inactive'); ?>

                        </span>
                    </td>

                    
                    <td>
                        <?php echo e($employee->created_at->format('d M Y')); ?>

                    </td>


                    
                    <td class="d-flex gap-1 flex-wrap">

                        
                        <a href="<?php echo e(route('employees.show', $employee->id)); ?>"
                        class="btn btn-sm btn-info">
                            View
                        </a>

                        
                        <a href="<?php echo e(route('employees.edit', $employee->id)); ?>"
                        class="btn btn-sm btn-warning">
                            Edit
                        </a>

                        
                        <form action="<?php echo e(route('employees.toggle-status', $employee->id)); ?>"
                            method="POST">

                            <?php echo csrf_field(); ?>
                            <?php echo method_field('PATCH'); ?>

                            <button type="submit"
                                    class="btn btn-sm btn-dark">

                                <?php echo e($employee->status ? 'Block' : 'Unblock'); ?>


                            </button>

                        </form>

                        
                        <form action="<?php echo e(route('employees.destroy', $employee->id)); ?>"
                            method="POST">

                            <?php echo csrf_field(); ?>
                            <?php echo method_field('DELETE'); ?>

                            <button type="submit"
                                    class="btn btn-sm btn-danger"
                                    onclick="return confirm('Delete this employee?')">
                                Delete
                            </button>

                        </form>

                    </td>

                </tr>

                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>

                <tr>
                    <td colspan="9"
                        class="text-center text-muted">
                        No Employees Found
                    </td>
                </tr>

                <?php endif; ?>

            </tbody>

        </table>

    </div>

</div>



<script>
document.querySelectorAll('.delete-employee').forEach(btn => {

    btn.addEventListener('click', function () {

        if (!confirm('Delete this employee?')) return;

        let id = this.getAttribute('data-id');

        fetch(`/employees/${id}`, {

            method: 'DELETE',

            headers: {
                'X-CSRF-TOKEN': '<?php echo e(csrf_token()); ?>',
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

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\nirogisathi-v3\backend\app\Modules/Employees/Views/index.blade.php ENDPATH**/ ?>