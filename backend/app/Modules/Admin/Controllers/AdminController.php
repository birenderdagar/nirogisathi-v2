<?php

namespace App\Modules\Admin\Controllers;

use App\Http\Controllers\Controller;
use App\Modules\Users\Models\User;
use Illuminate\Support\Facades\Schema;

class AdminController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | ADMIN DASHBOARD CONTROLLER
    |--------------------------------------------------------------------------
    */

    public function dashboard()
    {
        /*
        |--------------------------------------------------------------------------
        | BLOCK 1 : TOTAL USERS
        |--------------------------------------------------------------------------
        */
        $usersCount = User::count();


        /*
        |--------------------------------------------------------------------------
        | BLOCK 2 : ACTIVE USERS
        |--------------------------------------------------------------------------
        */
        $activeUsers = User::where('status', 'active')->count();


        /*
        |--------------------------------------------------------------------------
        | BLOCK 3 : BLOCKED USERS
        |--------------------------------------------------------------------------
        */
        $blockedUsers = User::where('status', 'blocked')->count();


        /*
        |--------------------------------------------------------------------------
        | BLOCK 4 : MONTHLY USERS GRAPH DATA
        |--------------------------------------------------------------------------
        */

        $monthlyUsers = [];

        for ($month = 1; $month <= 12; $month++) {

            $monthlyUsers[] = User::whereMonth(
                'created_at',
                $month
            )->count();
        }


        /*
        |--------------------------------------------------------------------------
        | BLOCK 5 : GENDER CHART DATA
        |--------------------------------------------------------------------------
        |
        | If gender column exists -> use real data
        | Otherwise -> fallback sample data
        |
        |--------------------------------------------------------------------------
        */

        if (Schema::hasColumn('users', 'gender')) {

            $maleUsers = User::where('gender', 'male')->count();

            $femaleUsers = User::where('gender', 'female')->count();

            $genderData = [
                $maleUsers,
                $femaleUsers
            ];

        } else {

            $genderData = [60, 40];
        }


        /*
        |--------------------------------------------------------------------------
        | BLOCK 6 : USER KPI CHANGE %
        |--------------------------------------------------------------------------
        */

        $previousMonthUsers = User::whereMonth(
            'created_at',
            now()->subMonth()->month
        )->count();

        $currentMonthUsers = User::whereMonth(
            'created_at',
            now()->month
        )->count();

        $usersKpiChange = $previousMonthUsers > 0
            ? round(
                (($currentMonthUsers - $previousMonthUsers)
                / $previousMonthUsers) * 100
            ) . '%'
            : '0%';


        /*
        |--------------------------------------------------------------------------
        | BLOCK 7 : ADMIN DETAILS
        |--------------------------------------------------------------------------
        */

        $adminName = auth()->user()->name ?? 'Admin';

        $adminPost = auth()->user()->role ?? 'Administrator';


        /*
        |--------------------------------------------------------------------------
        | BLOCK 8 : RETURN DASHBOARD VIEW
        |--------------------------------------------------------------------------
        */

        return view('admin::dashboard', compact(

            'usersCount',
            'activeUsers',
            'blockedUsers',
            'monthlyUsers',
            'genderData',
            'usersKpiChange',
            'adminName',
            'adminPost'

        ));
    }
}