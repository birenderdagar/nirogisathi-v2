<?php

namespace App\Modules\Banners\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Modules\Banners\Models\Banner;

class BannerApiController extends Controller
{
    public function index()
    {
        $banners = Banner::active()->ordered()->get()->map(function (Banner $banner) {
            return [
                'id' => $banner->id,
                'title' => $banner->title,
                'button_text' => $banner->button_text,
                'image_url' => $banner->resolved_image_url,
                'image_path' => $banner->image_path,
                'bg_color' => $banner->bg_color,
                'action_type' => $banner->action_type,
                'action_value' => $banner->action_value,
                'open_in_new_tab' => $banner->open_in_new_tab,
                'sort_order' => $banner->sort_order,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $banners,
        ]);
    }
}
