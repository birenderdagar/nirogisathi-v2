
<?php $__env->startSection('title', 'Assign Subscription'); ?>
<?php $__env->startSection('content'); ?>
<div class="card shadow-sm">
    <div class="card-header d-flex justify-content-between align-items-center">
        <a href="<?php echo e(route('user-subscriptions.index')); ?>" class="btn btn-secondary">← Back</a>
        <h3 class="mb-0">Assign Subscription</h3>
        <span></span>
    </div>
    <div class="card-body">
        <form method="POST" action="<?php echo e(route('user-subscriptions.store')); ?>">
            <?php echo csrf_field(); ?>
            <?php echo $__env->make('UserSubscriptions::_form', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?>
            <div class="mt-4 d-flex gap-2">
                <button class="btn btn-primary" type="submit">Save</button>
                <a href="<?php echo e(route('user-subscriptions.index')); ?>" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH D:\nirogisathi-v3\backend\app\Modules/UserSubscriptions/Views/create.blade.php ENDPATH**/ ?>