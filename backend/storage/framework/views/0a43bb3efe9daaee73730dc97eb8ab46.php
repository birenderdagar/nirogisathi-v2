<?php
    $selectedUserId = old(
        'user_id',
        $item->user_id ?? ($preselectedUserId ?? '')
    );
?>

<?php if($errors->any()): ?>
    <div class="alert alert-danger">
        <ul class="mb-0"><?php $__currentLoopData = $errors->all(); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $e): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?><li><?php echo e($e); ?></li><?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?></ul>
    </div>
<?php endif; ?>

<div class="row g-3">
    <div class="col-md-6">
        <label class="form-label fw-semibold">User * <small class="text-muted">(from Users module)</small></label>
        <select name="user_id" class="form-select" required>
            <option value="">Select user</option>
            <?php $__currentLoopData = $users; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $user): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <option value="<?php echo e($user->id); ?>"
                    <?php if((string) $selectedUserId === (string) $user->id): echo 'selected'; endif; ?>>
                    <?php echo e($user->name); ?> (<?php echo e($user->mobile); ?>) — <?php echo e($user->user_id); ?>

                    <?php if(($user->status ?? 'active') !== 'active'): ?> [<?php echo e($user->status); ?>] <?php endif; ?>
                </option>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </select>
        <div class="form-text">
            Assign employees only in <strong>Users</strong> module. New users appear here automatically.
        </div>
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Plan *</label>
        <select name="subscription_id" class="form-select" required>
            <option value="">Select plan</option>
            <?php $__currentLoopData = $plans; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $plan): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <option value="<?php echo e($plan->id); ?>"
                    <?php if((string) old('subscription_id', $item->subscription_id ?? '') === (string) $plan->id): echo 'selected'; endif; ?>>
                    <?php echo e($plan->name); ?> — <?php echo e($plan->price_display); ?>

                </option>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Status *</label>
        <select name="status" class="form-select" required>
            <?php $__currentLoopData = ['active','expired','cancelled']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $status): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                <option value="<?php echo e($status); ?>" <?php if(old('status', $item->status ?? 'active') === $status): echo 'selected'; endif; ?>>
                    <?php echo e(ucfirst($status)); ?>

                </option>
            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Payment method</label>
        <input type="text" name="payment_method" class="form-control"
               value="<?php echo e(old('payment_method', $item->payment_method ?? 'admin')); ?>" placeholder="upi / card / admin">
    </div>
    <div class="col-md-4">
        <label class="form-label fw-semibold">Payment ref</label>
        <input type="text" name="payment_ref" class="form-control"
               value="<?php echo e(old('payment_ref', $item->payment_ref ?? '')); ?>">
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Starts at</label>
        <input type="datetime-local" name="starts_at" class="form-control"
               value="<?php echo e(old('starts_at', isset($item) && $item->starts_at ? $item->starts_at->format('Y-m-d\\TH:i') : '')); ?>">
    </div>
    <div class="col-md-6">
        <label class="form-label fw-semibold">Ends at</label>
        <input type="datetime-local" name="ends_at" class="form-control"
               value="<?php echo e(old('ends_at', isset($item) && $item->ends_at ? $item->ends_at->format('Y-m-d\\TH:i') : '')); ?>">
    </div>
</div>
<?php /**PATH D:\nirogisathi-v3\backend\app\Modules/UserSubscriptions/Views/_form.blade.php ENDPATH**/ ?>