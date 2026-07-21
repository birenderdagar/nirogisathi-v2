<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'Admin Panel')</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>

    {{-- NAVBAR --}}
    <nav class="navbar navbar-dark bg-dark px-3">
        <span class="navbar-brand">Admin Dashboard</span>
    </nav>

    {{-- MAIN CONTENT --}}
    <div class="container-fluid">
        @yield('content')
    </div>

</body>
</html>