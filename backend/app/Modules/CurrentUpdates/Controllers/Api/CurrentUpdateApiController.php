<?php

namespace App\Modules\CurrentUpdates\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Modules\CurrentUpdates\Models\CurrentUpdate;

class CurrentUpdateApiController extends Controller
{
    public function index()
    {
        $updates = CurrentUpdate::active()->ordered()->get()->map(function (CurrentUpdate $update) {
            return [
                'id' => $update->id,
                'value' => $update->value,
                'label' => $update->label,
                'bg_color' => $update->bg_color,
                'text_color' => $update->text_color,
                'sort_order' => $update->sort_order,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $updates,
        ]);
    }
}
