<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nirogi Sathi Enterprise Dashboard</title>

<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body class="bg-[#f4f7fb] font-sans">

<div class="flex min-h-screen">

<!-- =========================================================
BLOCK 1: SIDEBAR (FULL UPDATED WITH ROUTES)
========================================================= -->
<aside class="w-72 bg-[#071220] text-white p-6 flex flex-col shadow-2xl">

    <!-- BLOCK 1.1: LOGO -->
    <div class="flex items-center gap-3 mb-10">
        <img src="<?php echo e(asset('images/logo.png')); ?>" class="w-12 h-12 rounded-xl" alt="Logo">
        <div>
            <h1 class="font-bold text-xl">Nirogi Sathi</h1>
            <p class="text-xs text-slate-400">Healthcare Enterprise</p>
        </div>
    </div>

    <!-- BLOCK 1.2: MAIN MENU -->
    <div class="space-y-7 text-sm">

        <!-- DASHBOARD -->
        <div>
            <p class="text-slate-400 mb-3 uppercase font-bold">Main</p>

            <div class="space-y-2">

                <a href="<?php echo e(route('admin.dashboard')); ?>"
                   class="block px-4 py-3 bg-cyan-500 rounded-xl hover:bg-cyan-600 transition">
                    📊 Dashboard
                </a>

                <!-- ✅ USERS (ACTIVE LINK ADDED) -->
                <a href="<?php echo e(route('admin.users.index')); ?>"
                  class="block px-4 py-3 bg-cyan-500 rounded-xl hover:bg-cyan-600 transition">
                    🧑‍🤝‍🧑 Users
                </a>

                <a href="#"
                   class="block px-4 py-3 hover:bg-slate-800 rounded-xl transition">
                    📄 Layouts
                </a>

            </div>
        </div>

        <!-- HEALTHCARE MODULES -->
        <div>
            <p class="text-slate-400 mb-3 uppercase font-bold">Health Care</p>

            <div class="space-y-2">

                

                <a href="#"
                   class="block px-4 py-3 hover:bg-slate-800 rounded-xl transition">
                    🩺 Doctors
                </a>

                <a href="#"
                   class="block px-4 py-3 hover:bg-slate-800 rounded-xl transition">
                    📅 Appointments
                </a>

                <a href="#"
                   class="block px-4 py-3 hover:bg-slate-800 rounded-xl transition">
                    🧪 Laboratory
                </a>

                <a href="#"
                   class="block px-4 py-3 hover:bg-slate-800 rounded-xl transition">
                    💊 Pharmacy
                </a>

            </div>
        </div>

        <!-- MANAGEMENT -->
        <div>
            <p class="text-slate-400 mb-3 uppercase font-bold">Management</p>

            <div class="space-y-2">

                <a href="<?php echo e(route('employees.index')); ?>"
                class="block px-4 py-3 hover:bg-cyan-500 rounded-xl transition">
                👨‍💼 Employees
                </a>

                <a href="#"
                   class="block px-4 py-3 hover:bg-slate-800 rounded-xl transition">
                    🔔 Notifications
                </a>

                <a href="<?php echo e(route('settings.index')); ?>"
                class="block w-full text-left px-4 py-3 hover:bg-slate-800 rounded-xl transition">

                ⚙️ Settings

                </a>
                </button>

            </div>
        </div>

    </div>
</aside>

<!-- =========================================================
BLOCK 2: MAIN CONTENT AREA
========================================================= -->
<main class="flex-1 p-8 overflow-auto">

<!-- =========================================================
BLOCK 2.1: TOP HEADER (WELCOME + SEARCH + LOGOUT)
========================================================= -->
<div class="bg-white rounded-2xl p-5 flex justify-between items-center shadow-sm mb-8">

    <!-- BLOCK 2.1.1: WELCOME TEXT -->
    <div>
        <h2 class="text-3xl font-bold">
            Welcome, <?php echo e($adminName ?? 'Admin'); ?>

        </h2>

        <p class="text-slate-500">
            <?php echo e($adminPost ?? 'Administrator'); ?> ·
            <span id="currentDateTime">
                <?php echo e(now()->format('l, d M Y • h:i A')); ?>

            </span>
        </p>

        <!-- BLOCK 2.1.2: LIVE CLOCK SCRIPT -->
        <script>
        (function(){
            function formatDateTime(date){
                const days=['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
                const months=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];

                const day = days[date.getDay()];
                const d = String(date.getDate()).padStart(2,'0');
                const m = months[date.getMonth()];
                const y = date.getFullYear();

                let h = date.getHours();
                const ampm = h >= 12 ? 'PM' : 'AM';
                h = h % 12 || 12;

                const hh = String(h).padStart(2,'0');
                const min = String(date.getMinutes()).padStart(2,'0');

                return `${day}, ${d} ${m} ${y} • ${hh}:${min} ${ampm}`;
            }

            function updateDateTime(){
                const el = document.getElementById('currentDateTime');
                if(el) el.textContent = formatDateTime(new Date());
            }

            updateDateTime();
            setInterval(updateDateTime, 1000);
        })();
        </script>
    </div>

    <!-- BLOCK 2.1.3: SEARCH + PROFILE + LOGOUT -->
    <div class="flex items-center gap-4">

        <!-- SEARCH BOX -->
        <input
            class="px-5 py-3 rounded-xl border w-80"
            placeholder="Search anything...">

        <!-- PROFILE ICON -->
        <div class="w-12 h-12 rounded-full bg-slate-300"></div>

        <!-- LOGOUT -->
        <form method="POST" action="<?php echo e(route('logout')); ?>">
            <?php echo csrf_field(); ?>
            <button type="submit"
                class="px-5 py-2 bg-red-500 text-white rounded-xl hover:bg-red-600 transition">
                🚪 Logout
            </button>
        </form>

    </div>

</div>

<!-- =========================================================
BLOCK 2.2: KPI CARDS
========================================================= -->
<div class="grid grid-cols-4 gap-6 mb-8">

<?php $__currentLoopData = [
['🧑‍⚕️ Users',$usersCount,'Total Registered'],
['✅ Active',$activeUsers,'Live Accounts'],
['⛔ Blocked',$blockedUsers,'Restricted'],
['📈 Growth',$usersCount,'Database']
]; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $card): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

<div class="bg-white rounded-2xl p-6 shadow-sm border">
    <p class="text-slate-500"><?php echo e($card[0]); ?></p>
    <h3 class="text-3xl font-bold"><?php echo e($card[1]); ?></h3>
    <span class="text-green-500"><?php echo e($card[2]); ?></span>
</div>

<?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

</div>

<!-- =========================================================
BLOCK 2.3: CHART SECTION
========================================================= -->
<div class="grid grid-cols-3 gap-8 mb-8">

    <div class="col-span-2 bg-white rounded-2xl p-6 shadow-sm">
        <h3 class="font-bold mb-4">Users Analytics</h3>
        <canvas id="statsChart"></canvas>
    </div>

    <div class="bg-white rounded-2xl p-6 shadow-sm">
        <h3 class="font-bold mb-4">Appointments</h3>

        <?php $__currentLoopData = ['A','B','C','D']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $p): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
        <div class="py-3 border-b flex justify-between">
            <span>User <?php echo e($p); ?></span>
            <button class="text-cyan-500">Approve</button>
        </div>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

    </div>

</div>


<div class="grid grid-cols-6 gap-5 mb-8">


    
    <a href="<?php echo e(route('admin.users.index')); ?>"
       class="bg-white rounded-2xl p-6 text-center shadow-sm hover:shadow-lg transition block cursor-pointer">

        <div class="text-3xl mb-3">👥</div>
        <div class="font-semibold text-slate-700">Users</div>

    </a>


    
    <div class="bg-white rounded-2xl p-6 text-center shadow-sm hover:shadow-lg">
        <div class="text-3xl mb-3">👩‍⚕️</div>
        <div class="font-semibold">Doctors</div>
    </div>


    
    <div class="bg-white rounded-2xl p-6 text-center shadow-sm hover:shadow-lg">
        <div class="text-3xl mb-3">🧪</div>
        <div class="font-semibold">Labs</div>
    </div>


    
    <div class="bg-white rounded-2xl p-6 text-center shadow-sm hover:shadow-lg">
        <div class="text-3xl mb-3">💊</div>
        <div class="font-semibold">Pharmacy</div>
    </div>


    
    <div class="bg-white rounded-2xl p-6 text-center shadow-sm hover:shadow-lg">
        <div class="text-3xl mb-3">📅</div>
        <div class="font-semibold">Visits</div>
    </div>


    
    <div class="bg-white rounded-2xl p-6 text-center shadow-sm hover:shadow-lg">
        <div class="text-3xl mb-3">📁</div>
        <div class="font-semibold">Reports</div>
    </div>

</div>

<div class="grid grid-cols-3 gap-8">

    
    <a href="<?php echo e(route('admin.dashboard')); ?>"
       class="bg-white rounded-2xl p-6 shadow-sm hover:shadow-lg block">

        <h3 class="font-bold mb-4">
            Patient Reports
        </h3>

        <?php $__currentLoopData = ['John','David','Mike']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $p): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
            <div class="py-3 border-b">
                <?php echo e($p); ?>

            </div>
        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

    </a>


    
    <a href="<?php echo e(route('admin.dashboard')); ?>"
       class="bg-white rounded-2xl p-6 shadow-sm hover:shadow-lg block">

        <h3 class="font-bold mb-4">
            Visit Chart
        </h3>

        <canvas id="visitChart"></canvas>

    </a>


    
    <a href="<?php echo e(route('admin.dashboard')); ?>"
       class="bg-white rounded-2xl p-6 shadow-sm hover:shadow-lg block">

        <h3 class="font-bold mb-4">
            Doctors
        </h3>

        <?php $__currentLoopData = ['Dr A','Dr B','Dr C']; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $d): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>

            <div class="py-3 border-b flex justify-between">

                <span><?php echo e($d); ?></span>

                <span class="text-green-500">
                    Available
                </span>

            </div>

        <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>

    </a>

</div>
<!-- =========================================================
BLOCK 3: CHART SCRIPTS
========================================================= -->
<script>
new Chart(document.getElementById('statsChart'), {
    type: 'line',
    data: {
        labels: [
            'Jan','Feb','Mar','Apr','May','Jun',
            'Jul','Aug','Sep','Oct','Nov','Dec'
        ],
        datasets: [{
            label: 'Registered Users',
            data: <?php echo json_encode($monthlyUsers); ?>,
            tension: 0.4,
            fill: true
        }]
    }
});

new Chart(document.getElementById('visitChart'), {
    type: 'doughnut',
    data: {
        labels: ['Male','Female'],
        datasets: [{ data: <?php echo json_encode($genderData); ?> }]
    }
});
</script>




</body>
</html><?php /**PATH D:\others\Nirogi Sathi\website contants\new app backup\back end backup\nirogisathibackend_3\nirogisathibackend\app\Modules/Admin/Views/dashboard.blade.php ENDPATH**/ ?>