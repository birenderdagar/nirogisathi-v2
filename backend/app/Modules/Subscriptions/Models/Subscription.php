<?php

namespace App\Modules\Subscriptions\Models;

use Illuminate\Database\Eloquent\Model;

class Subscription extends Model
{
    protected $table = 'subscriptions';

    protected $fillable = [
        'name',
        'slug',
        'price_display',
        'billing_label',
        'pay_button_text',
        'icon',
        'price',
        'accent_color',
        'app_route',
        'description',
        'features',
        'sort_order',
        'is_active',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'features' => 'array',
        'is_active' => 'boolean',
        'sort_order' => 'integer',
    ];

    public const APP_ROUTES = [
        '/subscription-pack' => 'Basic pack page',
        '/standard-subscription' => 'Standard pack page',
        '/premium-subscription' => 'Premium pack page',
        '/subscription' => 'My subscription',
    ];

    public const ICONS = [
        'awesome' => 'Sparkle (Basic)',
        'vintage' => 'Vintage (Standard/Premium)',
    ];

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderBy('id');
    }

    /**
     * Normalize features into sectioned format used by the app lock UI.
     */
    public function getFeatureSectionsAttribute(): array
    {
        $features = $this->features ?? [];
        if ($features === []) {
            return [];
        }

        // Already sectioned: [{title, items:[{text,is_locked}]}]
        if (isset($features[0]) && is_array($features[0]) && array_key_exists('title', $features[0])) {
            return array_map(function ($section) {
                $items = $section['items'] ?? [];
                return [
                    'title' => $section['title'] ?? 'Features',
                    'items' => array_map(function ($item) {
                        if (is_string($item)) {
                            return ['text' => $item, 'is_locked' => false];
                        }
                        return [
                            'text' => $item['text'] ?? '',
                            'is_locked' => (bool) ($item['is_locked'] ?? false),
                        ];
                    }, $items),
                ];
            }, $features);
        }

        // Legacy flat string list
        return [[
            'title' => 'Features',
            'items' => array_map(
                fn ($text) => ['text' => (string) $text, 'is_locked' => false],
                $features
            ),
        ]];
    }

    public static function featuresToText(?array $features): string
    {
        if (!$features) {
            return '';
        }

        $lines = [];
        foreach ($features as $section) {
            if (!is_array($section) || !isset($section['title'])) {
                // legacy flat
                if (is_string($section)) {
                    $lines[] = '- unlock: ' . $section;
                }
                continue;
            }
            $lines[] = '# ' . $section['title'];
            foreach ($section['items'] ?? [] as $item) {
                if (is_string($item)) {
                    $lines[] = '- unlock: ' . $item;
                    continue;
                }
                $lock = !empty($item['is_locked']) ? 'lock' : 'unlock';
                $lines[] = '- ' . $lock . ': ' . ($item['text'] ?? '');
            }
            $lines[] = '';
        }

        return trim(implode("\n", $lines));
    }

    public static function parseFeaturesText(string $text): array
    {
        $sections = [];
        $current = null;

        foreach (preg_split('/\r\n|\r|\n/', $text) as $rawLine) {
            $line = trim($rawLine);
            if ($line === '') {
                continue;
            }

            if (str_starts_with($line, '#')) {
                if ($current) {
                    $sections[] = $current;
                }
                $current = [
                    'title' => trim(ltrim($line, '# ')),
                    'items' => [],
                ];
                continue;
            }

            if (!$current) {
                $current = ['title' => 'Features', 'items' => []];
            }

            if (preg_match('/^-\s*(lock|unlock)\s*:\s*(.+)$/i', $line, $m)) {
                $current['items'][] = [
                    'text' => trim($m[2]),
                    'is_locked' => strtolower($m[1]) === 'lock',
                ];
                continue;
            }

            // Plain bullet fallback = unlocked
            $plain = ltrim($line, '- ');
            $current['items'][] = [
                'text' => $plain,
                'is_locked' => false,
            ];
        }

        if ($current) {
            $sections[] = $current;
        }

        return $sections;
    }
}
