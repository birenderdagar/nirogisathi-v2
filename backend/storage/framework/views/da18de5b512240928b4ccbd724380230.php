

<?php $__env->startSection('title', 'Users'); ?>
<?php $__env->startSection('page-title', 'User Management'); ?>

<?php $__env->startSection('content'); ?>


<div class="card shadow-sm">

    
    <div class="card-header d-flex justify-content-between align-items-center">

        
        <a href="<?php echo e(route('admin.dashboard')); ?>"
        class="btn btn-secondary btn-sm">
        ← Dashboard
        </a>

        
        <h3 class="card-title mb-0">
            Users Management
        </h3>

        
        <a href="<?php echo e(route('admin.users.create')); ?>"
           class="btn btn-primary">
            + Add User
        </a>

    </div>


    
    <div class="card-body table-responsive">

        <table class="table table-hover table-bordered align-middle">

            
            <thead class="table-dark">
                <tr>
                    <th>User ID</th>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Mobile</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Assigned Employee</th>
                    <th>Login Method</th>
                    <th>MPIN</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th width="330">Actions</th>
                </tr>
            </thead>


            
            <tbody>

                <?php $__empty_1 = true; $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>

                    <?php
                        $loginMethod = ($user->mpin && $user->otp_verified_at)
                            ? 'OTP + MPIN'
                            : ($user->otp_verified_at ? 'OTP Only' : 'Not Verified');

                        $mpinStatus = $user->mpin ? 'Set' : 'Not Set';

                        $status = $user->status ?? 'active';
                    ?>

                    <tr>

                        
                                    <td>
                                    <span class="badge bg-dark">
                                     <?php echo e($user->user_id); ?>

                                     </span>
                                    </td>
                        
                            <td>

                                <?php if($user->photo): ?>

                                    <img
                                        src="<?php echo e($user->photo_url); ?>"
                                        width="45"
                                        height="45"
                                        class="rounded-circle border"
                                        style="object-fit:cover;"
                                    >

                                <?php else: ?>

                                    <img
                                        src="https://ui-avatars.com/api/?name=<?php echo e(urlencode($user->name)); ?>"
                                        width="45"
                                        height="45"
                                        class="rounded-circle border"
                                    >

                                <?php endif; ?>

                            </td>

                        
                        <td><?php echo e($user->name); ?></td>

                        
                        <td><?php echo e($user->mobile); ?></td>

                        
                        <td><?php echo e($user->email ?? '-'); ?></td>

                        
                        <td>
                            <span class="badge bg-info">
                                <?php echo e(ucfirst($user->role)); ?>

                            </span>
                        </td>

                        
                        <td>
                            <span class="badge bg-secondary text-dark">
                                <?php echo e(optional($user->assignedEmployee)->name ?? $user->employee_id ?? '-'); ?>

                            </span>
                        </td>

                        
                        <td>
                            <span class="badge bg-primary">
                                <?php echo e($loginMethod); ?>

                            </span>
                        </td>

                        
                        <td>
                            <span class="badge <?php echo e($mpinStatus === 'Set' ? 'bg-success' : 'bg-warning'); ?>">
                                <?php echo e($mpinStatus); ?>

                            </span>
                        </td>

                        
                        <td>
                            <span class="badge <?php echo e($status === 'active' ? 'bg-success' : 'bg-danger'); ?>">
                                <?php echo e(ucfirst($status)); ?>

                            </span>
                        </td>

                        
                        <td>
                            <?php echo e($user->created_at->format('d M Y')); ?>

                        </td>


                        
                        <td class="d-flex gap-1 flex-wrap">

                            
                            <a href="<?php echo e(route('admin.users.edit', $user->id)); ?>"
                               class="btn btn-sm btn-info">
                                View
                            </a>

                            
                            <a href="<?php echo e(route('admin.users.edit', $user->id)); ?>"
                               class="btn btn-sm btn-warning">
                                Edit
                            </a>

                            
                            <form action="<?php echo e(route('admin.users.toggle-status', $user->id)); ?>"
                                  method="POST">

                                <?php echo csrf_field(); ?>
                                <?php echo method_field('PATCH'); ?>

                                <button type="submit"
                                        class="btn btn-sm btn-dark">

                                    <?php echo e($status === 'active'
                                        ? 'Block'
                                        : 'Unblock'); ?>


                                </button>
                            </form>


                            
                            <button
                            class="btn btn-sm btn-danger delete-user"
                            data-id="<?php echo e($user->id); ?>">
                            Delete
                            </button>

                        </td>

                    </tr>

                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>

                    
                    <tr>
                        <td colspan="10"
                            class="text-center text-muted">
                            No users found.
                        </td>
                    </tr>

                <?php endif; ?>

            </tbody>

        </table>

    </div>

</div>
</div>


<script>
document.querySelectorAll('.delete-user').forEach(btn => {

    btn.addEventListener('click', function () {

        if (!confirm('Delete this user?')) return;

        let id = this.getAttribute('data-id');

        fetch(`/admin/users/${id}`, {
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

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\others\Nirogi Sathi\website contants\new app backup\back end backup\nirogisathibackend_3\nirogisathibackend\app\Modules/Users/Views/index.blade.php ENDPATH**/ ?>