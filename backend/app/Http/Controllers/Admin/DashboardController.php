return view('admin.dashboard', [
    'usersCount' => UserService::count(),
    'doctorsCount' => DoctorService::count(),
]);
    }

    public function preview(): View
    {
        return view('admin.preview');
    }

    public function store(Request $request): RedirectResponse
    {
        // handle form submission
        return redirect()->route('admin.dashboard');
    }
}