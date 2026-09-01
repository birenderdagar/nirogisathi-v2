<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('subscriptions', function (Blueprint $table) {
            if (!Schema::hasColumn('subscriptions', 'billing_label')) {
                $table->string('billing_label')->nullable()->after('price_display');
            }
            if (!Schema::hasColumn('subscriptions', 'pay_button_text')) {
                $table->string('pay_button_text')->nullable()->after('billing_label');
            }
            if (!Schema::hasColumn('subscriptions', 'icon')) {
                $table->string('icon', 40)->default('awesome')->after('pay_button_text');
            }
        });

        $lockerText = 'Digital health locker helps to manage all health records and to create health history that will helps doctors to find your disease or health history and diagnose the patient easy and quickly.';
        $hospitalItems = [
            'We have a support system and large network in Govt. & private hospitals/labs to give a hassle free service to our clients .',
            'We provide discounts on all private lab tests and hospital charges .',
            'We helps in hectic process of registratin queue, medicine queue and other clerical work in govt .',
            'Hospitals as well as to book a appointment, medicines and helps to find an expert doctor for any particular disease in private sectors .',
        ];

        $basicFeatures = [
            [
                'title' => 'Routine Screening',
                'items' => [
                    ['text' => '3 timed in a year (may be very according to need.', 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Digital Health Locker',
                'items' => [
                    ['text' => $lockerText, 'is_locked' => true],
                ],
            ],
            [
                'title' => 'Gov./Private Hospital Support',
                'items' => array_map(
                    fn ($text) => ['text' => $text, 'is_locked' => true],
                    $hospitalItems
                ),
            ],
        ];

        $standardFeatures = [
            [
                'title' => 'Routine Screening',
                'items' => [
                    ['text' => '3 timed in a year (may be very according to need.', 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Digital Health Locker',
                'items' => [
                    ['text' => $lockerText, 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Gov./Private Hospital Support',
                'items' => array_map(
                    fn ($text) => ['text' => $text, 'is_locked' => true],
                    $hospitalItems
                ),
            ],
        ];

        $premiumFeatures = [
            [
                'title' => 'Routine Screening',
                'items' => [
                    ['text' => '3 timed in a year (may be very according to need.', 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Digital Health Locker',
                'items' => [
                    ['text' => $lockerText, 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Gov./Private Hospital Support',
                'items' => array_map(
                    fn ($text) => ['text' => $text, 'is_locked' => false],
                    $hospitalItems
                ),
            ],
            [
                'title' => 'Monitoring after Doctor consultation and reminders',
                'items' => [
                    [
                        'text' => 'After any treatment or doctor consultation we strongly belive to monitor the patient for improment or any side effect of medicines.we set reminders for further tests andmedicines. We provide both physical and emotional support. In addition to helping patients with personal care.We makes a real difference in people\'s lives by providing essential care and support during their time of need.',
                        'is_locked' => false,
                    ],
                ],
            ],
            [
                'title' => 'Costomize Health tips,costomize diet plans',
                'items' => [
                    ['text' => 'once in a month.', 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Personal Yoga Trainer',
                'items' => [
                    ['text' => 'four season in a month.', 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Personal Health Coach',
                'items' => [
                    ['text' => 'four season in a month.', 'is_locked' => false],
                ],
            ],
            [
                'title' => 'Physiotherapy Seasons',
                'items' => [
                    ['text' => 'two season in a month.', 'is_locked' => false],
                ],
            ],
        ];

        DB::table('subscriptions')->where('slug', 'basic')->update([
            'name' => 'BASIC',
            'billing_label' => '150/- per Month',
            'pay_button_text' => 'Pay 150/-',
            'price_display' => '₹150.00',
            'price' => 150,
            'accent_color' => '#F97316',
            'icon' => 'awesome',
            'app_route' => '/subscription-pack',
            'description' => '150/- per Month',
            'features' => json_encode($basicFeatures),
            'updated_at' => now(),
        ]);

        DB::table('subscriptions')->where('slug', 'standard')->update([
            'name' => 'Standard',
            'billing_label' => '1500/- per Month',
            'pay_button_text' => 'Pay 1500/-',
            'price_display' => '₹1500.00',
            'price' => 1500,
            'accent_color' => '#EF4444',
            'icon' => 'vintage',
            'app_route' => '/standard-subscription',
            'description' => '1500/- per Month',
            'features' => json_encode($standardFeatures),
            'updated_at' => now(),
        ]);

        DB::table('subscriptions')->where('slug', 'premium')->update([
            'name' => 'Premium',
            'billing_label' => '4500/- per Month',
            'pay_button_text' => 'Pay 4500/-',
            'price_display' => '₹4500.00',
            'price' => 4500,
            'accent_color' => '#F59E0B',
            'icon' => 'vintage',
            'app_route' => '/premium-subscription',
            'description' => '4500/- per Month',
            'features' => json_encode($premiumFeatures),
            'updated_at' => now(),
        ]);
    }

    public function down(): void
    {
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->dropColumn(['billing_label', 'pay_button_text', 'icon']);
        });
    }
};
