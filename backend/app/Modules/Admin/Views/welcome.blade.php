<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Nirogi Sathi™</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gradient-to-r from-blue-900 via-cyan-700 to-blue-500 min-h-screen text-white">

<!-- Navbar -->
<nav class="flex justify-between items-center px-12 py-6">

    <!-- Logo -->
    <div class="flex items-center gap-3">
        <img src="{{ asset('images/logo.png') }}"
             class="w-14 h-14 rounded-full shadow-lg"
             alt="Logo">

        <h1 class="text-3xl font-bold">Nirogi Sathi™</h1>
    </div>

    <!-- Buttons (ONLY LOGIN) -->
    <div class="space-x-4">

        <a href="/login"
           class="px-5 py-2 border rounded-lg hover:bg-white hover:text-blue-900 transition">
            Login
        </a>

    </div>

</nav>

<!-- Hero -->
<div class="container mx-auto px-12 py-20 flex items-center justify-between">

    <!-- Left Content -->
    <div class="max-w-xl">

        <h2 class="text-6xl font-bold mb-6">
            Smart Healthcare Platform
        </h2>

        <p class="text-xl text-gray-200 mb-8">
            Manage patients, doctors, appointments and hospitals
            with one powerful healthcare system.
        </p>

        <div class="bg-white/20 backdrop-blur-md p-6 rounded-2xl">
            <ul class="space-y-3 text-lg">
                <li>✔ Fast Appointment Booking</li>
                <li>✔ Secure Patient Records</li>
                <li>✔ Doctor Management</li>
                <li>✔ Real-time Analytics</li>
            </ul>
        </div>

    </div>

    <!-- Right Image -->
    <div class="relative">

        <img src="{{ asset('images/welcome.png') }}"
             class="w-[550px] rounded-3xl shadow-2xl"
             alt="Welcome">

    </div>

</div>

<!-- Footer -->
<footer class="text-center py-6 text-gray-200">
    © 2026 Nirogi Sathi™ Healthcare System
</footer>

</body>