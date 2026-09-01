
<?php $__env->startSection('title', 'User Subscriptions'); ?>
<?php $__env->startSection('content'); ?>
<div class="card shadow-sm">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-2">
        <a href="<?php echo e(route('admin.dashboard')); ?>" class="btn btn-secondary btn-sm">← Dashboard</a>
        <div class="text-center">
            <h3 class="mb-0">User Subscriptions</h3>
            <small class="text-muted">
                Auto-synced from Users · <?php echo e($totalUsers); ?> users · <?php echo e($activeCount); ?> active plans
            </small>
        </div>
        <a href="<?php echo e(route('user-subscriptions.create')); ?>" class="btn btn-primary">+ Assign Plan</a>
    </div>
    <div class="card-body">
        <?php if(session('success')): ?>
            <div class="alert alert-success"><?php echo e(session('success')); ?></div>
        <?php endif; ?>

        <form method="GET" class="row g-2 mb-3">
            <div class="col-md-8">
                <input type="text" name="q" value="<?php echo e($search); ?>" class="form-control"
                       placeholder="Search users by name, mobile, user ID, email...">
            </div>
            <div class="col-md-4 d-flex gap-2">
                <button class="btn btn-outline-primary" type="submit">Search</button>
                <a href="<?php echo e(route('user-subscriptions.index')); ?>" class="btn btn-outline-secondary">Reset</a>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Plan</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Period</th>
                        <th width="180">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php $__empty_1 = true; $__currentLoopData = $rows; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $row): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <?php
                            $user = $row['user'];
                            $sub = $row['subscription'];
                            $isActive = $row['is_active'];
                        ?>
                        <tr>
                            <td>
                                <div class="fw-semibold"><?php echo e($user->name); ?></div>
                                <small class="text-muted d-block"><?php echo e($user->user_id); ?> · <?php echo e($user->mobile); ?></small>
                                <?php if($user->email): ?>
                                    <small class="text-muted"><?php echo e($user->email); ?></small>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($sub): ?>
                                    <div><?php echo e($sub->plan_name); ?></div>
                                    <small class="text-muted"><?php echo e($sub->plan_slug); ?></small>
                                <?php else: ?>
                                    <span class="text-muted">No plan yet</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($sub): ?>
                                    <?php echo e($sub->price_display ?? ('₹' . number_format((float) $sub->price, 2))); ?>

                                <?php else: ?>
                                    —
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($isActive): ?>
                                    <span class="badge bg-success">Active</span>
                                <?php elseif($sub): ?>
                                    <span class="badge bg-secondary"><?php echo e(ucfirst($sub->status)); ?></span>
                                <?php else: ?>
                                    <span class="badge bg-warning text-dark">Not subscribed</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($sub): ?>
                                    <small>
                                        <?php echo e(optional($sub->starts_at)->format('d M Y')); ?>

                                        →
                                        <?php echo e(optional($sub->ends_at)->format('d M Y')); ?>

                                    </small>
                                <?php else: ?>
                                    —
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if($sub): ?>
                                    <a href="<?php echo e(route('user-subscriptions.edit', $sub->id)); ?>" class="btn btn-sm btn-warning">Edit</a>
                                    <form action="<?php echo e(route('user-subscriptions.destroy', $sub->id)); ?>" method="POST" class="d-inline"
                                          onsubmit="return confirm('Remove this subscription record?')">
                                        <?php echo csrf_field(); ?>
                                        <?php echo method_field('DELETE'); ?>
                                        <button class="btn btn-sm btn-danger">Del</button>
                                    </form>
                                <?php else: ?>
                                    <a href="<?php echo e(route('user-subscriptions.create', ['user_id' => $user->id])); ?>"
                                       class="btn btn-sm btn-primary">Assign Plan</a>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <tr>
                            <td colspan="6" class="text-center text-muted">
                                No users found. Create a user first under Users — they will appear here automatically.
                            </td>
                        </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\nirogisathi-v3\backend\app\Modules/UserSubscriptions/Views/index.blade.php ENDPATH**/ ?>