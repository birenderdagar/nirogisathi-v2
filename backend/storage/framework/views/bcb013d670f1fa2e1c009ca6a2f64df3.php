

<?php $__env->startSection('title', 'Edit User'); ?>
<?php $__env->startSection('page-title', 'Edit User'); ?>

<?php $__env->startSection('content'); ?>

<div class="card shadow-sm">

    
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="<?php echo e(route('admin.users.index')); ?>"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Edit User
        </h3>

        <span></span>

    </div>


    
    <div class="card-body">

        <form action="<?php echo e(route('admin.users.update', $user->id)); ?>"
              method="POST"
              enctype="multipart/form-data">

            <?php echo csrf_field(); ?>
            <?php echo method_field('PUT'); ?>


            
            <div class="mb-3">
                <label class="form-label">
                    Profile Photo
                </label>

                <input type="file"
                       name="photo"
                       class="form-control">

                <?php if($user->photo): ?>
                    <img src="<?php echo e(asset('storage/'.$user->photo)); ?>"
                         width="70"
                         class="mt-2 rounded">
                <?php endif; ?>
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    User ID
                </label>

                <input type="text"
                       class="form-control"
                       value="<?php echo e($user->user_id); ?>"
                       readonly>
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    Full Name
                </label>

                <input type="text"
                       name="name"
                       class="form-control"
                       value="<?php echo e($user->name); ?>"
                       required>
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    Mobile
                </label>

                <input type="text"
                       name="mobile"
                       class="form-control"
                       value="<?php echo e($user->mobile); ?>"
                       required>
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    Email
                </label>

                <input type="email"
                       name="email"
                       class="form-control"
                       value="<?php echo e($user->email); ?>">
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    Assign Existing Employee
                </label>

                <div class="input-group">
                    <select id="employee-selector"
                            class="form-control">
                        <option value="">Select an employee</option>

                        <?php $__empty_1 = true; $__currentLoopData = $employees; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $employee): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                            <option value="<?php echo e($employee->employee_id); ?>"
                                    data-name="<?php echo e($employee->name); ?>"
                                    data-mobile="<?php echo e($employee->mobile); ?>"
                                    data-email="<?php echo e($employee->email); ?>"
                                    <?php echo e($user->employee_id === $employee->employee_id ? 'selected' : ''); ?>>
                                <?php echo e($employee->name); ?>

                                (<?php echo e($employee->employee_id); ?>)
                            </option>
                        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                            <option value="" disabled>
                                No saved employees available
                            </option>
                        <?php endif; ?>
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
                       value="<?php echo e(old('employee_id', $user->employee_id)); ?>">
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    Role
                </label>

                <select name="role"
                        class="form-control">

                    <option value="user"
                        <?php echo e($user->role == 'user' ? 'selected' : ''); ?>>
                        User
                    </option>

                    <option value="employee"
                        <?php echo e($user->role == 'employee' ? 'selected' : ''); ?>>
                        Employee
                    </option>

                    <option value="admin"
                        <?php echo e($user->role == 'admin' ? 'selected' : ''); ?>>
                        Admin
                    </option>

                </select>
            </div>


            
            <div class="mb-3">
                <label class="form-label">
                    Status
                </label>

                <select name="status"
                        class="form-control">

                    <option value="active"
                        <?php echo e($user->status == 'active' ? 'selected' : ''); ?>>
                        Active
                    </option>

                    <option value="blocked"
                        <?php echo e($user->status == 'blocked' ? 'selected' : ''); ?>>
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

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\others\Nirogi Sathi\website contants\new app backup\back end backup\nirogisathibackend_3\nirogisathibackend\app\Modules/Users/Views/edit.blade.php ENDPATH**/ ?>