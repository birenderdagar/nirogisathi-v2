<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Nirogi Sathi™</title>

    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gradient-to-br from-blue-900 via-cyan-700 to-blue-500 min-h-screen flex items-center justify-center">

    <div class="w-full max-w-5xl bg-white/10 backdrop-blur-xl rounded-3xl shadow-2xl overflow-hidden grid grid-cols-1 md:grid-cols-2">

        <!-- LEFT SIDE (INFO) -->
        <div class="p-10 text-white flex flex-col justify-center">

            <h1 class="text-4xl font-bold mb-4">
                Nirogi Sathi™
            </h1>

            <p class="text-lg text-gray-200 mb-6">
                Smart Healthcare Management System for Hospitals, Doctors & Patients
            </p>

            <div class="space-y-3 text-sm text-gray-100">
                <p>✔ Secure Medical Records</p>
                <p>✔ Fast Appointment System</p>
                <p>✔ Doctor & Patient Management</p>
                <p>✔ Real-time Analytics Dashboard</p>
            </div>

            <div class="mt-10">
                <img src="<?php echo e(asset('images/welcome.png')); ?>"
                     class="rounded-2xl shadow-lg"
                     alt="Healthcare">
            </div>

        </div>

        <!-- RIGHT SIDE (LOGIN FORM) -->
        <div class="bg-white p-10 flex flex-col justify-center">

            <h2 class="text-3xl font-bold text-gray-800 mb-2">
                Welcome Back
            </h2>

            <p class="text-gray-500 mb-6">
                Login to access your dashboard
            </p>

            <!-- SESSION ERROR -->
            <?php if($errors->any()): ?>
                <div class="bg-red-100 text-red-700 p-3 rounded mb-4 text-sm">
                    <?php echo e($errors->first()); ?>

                </div>
            <?php endif; ?>

            <form method="POST" action="<?php echo e(route('login.store')); ?>" class="space-y-4">
                <?php echo csrf_field(); ?>

                <!-- EMAIL -->
                <div>
                    <label class="text-sm font-semibold text-gray-600">Email</label>
                    <input type="email"
                           name="email"
                           required
                           class="w-full mt-1 px-4 py-3 border rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
                           placeholder="Enter email">
                </div>

                <!-- PASSWORD -->
                <div>
                    <label class="text-sm font-semibold text-gray-600">Password</label>
                    <input type="password"
                           name="password"
                           required
                           class="w-full mt-1 px-4 py-3 border rounded-xl focus:ring-2 focus:ring-blue-500 outline-none"
                           placeholder="Enter password">
                </div>

                <!-- REMEMBER -->
                <div class="flex items-center justify-between text-sm">
                    <label class="flex items-center gap-2">
                        <input type="checkbox" name="remember" class="accent-blue-600">
                        Remember me
                    </label>

                    <a href="/forgot-password" class="text-blue-600 hover:underline">
                        Forgot password?
                    </a>
                </div>

                <!-- BUTTON -->
                <button type="submit"
                        class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 rounded-xl transition">
                    Login
                </button>
            </form>

            <p class="text-xs text-gray-400 mt-6 text-center">
                © 2026 Nirogi Sathi™ Healthcare System
            </p>

        </div>

    </div>

</body>
</html><?php /**PATH D:\others\Nirogi Sathi\website contants\new app backup\back end backup\nirogisathibackend_3\nirogisathibackend\app\Modules/Auth/Views/login.blade.php ENDPATH**/ ?>