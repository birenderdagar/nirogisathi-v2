

<?php $__env->startSection('title', 'Edit Employee'); ?>
<?php $__env->startSection('page-title', 'Edit Employee'); ?>

<?php $__env->startSection('content'); ?>

<div class="card shadow-sm">

    
    <div class="card-header d-flex justify-content-between align-items-center">

        <a href="<?php echo e(route('employees.index')); ?>"
           class="btn btn-secondary">
            ← Back
        </a>

        <h3 class="mb-0">
            Edit Employee
        </h3>

        <span></span>

    </div>


    
    <div class="card-body">

        <form action="<?php echo e(route('employees.update', $employee->id)); ?>"
              method="POST"
              enctype="multipart/form-data">

            <?php echo csrf_field(); ?>
            <?php echo method_field('PUT'); ?>


            <div class="row">

                
                <div class="col-md-4 text-center">

                    <img
                        src="<?php echo e($employee->photo
                            ? asset('storage/' . $employee->photo)
                            : 'https://ui-avatars.com/api/?name=' . urlencode($employee->name)); ?>"
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


                
                <div class="col-md-8">

                    <div class="mb-3">

                        <label class="form-label">
                            Employee ID
                        </label>

                        <input type="text"
                               class="form-control"
                               value="<?php echo e($employee->employee_id); ?>"
                               readonly>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Full Name
                        </label>

                        <input type="text"
                               name="name"
                               class="form-control"
                               value="<?php echo e($employee->name); ?>"
                               required>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Mobile
                        </label>

                        <input type="text"
                               name="mobile"
                               class="form-control"
                               value="<?php echo e($employee->mobile); ?>"
                               required>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Email
                        </label>

                        <input type="email"
                               name="email"
                               class="form-control"
                               value="<?php echo e($employee->email); ?>">

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Staff Role
                        </label>

                        <select name="designation"
                                class="form-control"
                                required>
                            <?php $__currentLoopData = $staffRoles; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $role): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                <option value="<?php echo e($role['name']); ?>"
                                    <?php echo e(old('designation', $employee->designation) === $role['name'] ? 'selected' : ''); ?>>
                                    <?php echo e($role['name']); ?>

                                </option>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                        </select>

                    </div>


                    <div class="mb-3">

                        <label class="form-label">
                            Status
                        </label>

                        <select name="status"
                                class="form-control">

                            <option value="1"
                                <?php echo e($employee->status ? 'selected' : ''); ?>>
                                Active
                            </option>

                            <option value="0"
                                <?php echo e(!$employee->status ? 'selected' : ''); ?>>
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

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\nirogisathi-v3\backend\app\Modules/Employees/Views/edit.blade.php ENDPATH**/ ?>