<?php

namespace App\Modules\Banners\Controllers;

use App\Http\Controllers\Controller;
use App\Modules\Banners\Models\Banner;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;

class BannerController extends Controller
{
    public function index()
    {
        $banners = Banner::ordered()->get();

        return view('Banners::index', compact('banners'));
    }

    public function create()
    {
        return view('Banners::create', [
            'actionTypes' => Banner::ACTION_TYPES,
            'appRoutes' => Banner::APP_ROUTES,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $this->validateBanner($request);

        if ($request->hasFile('image')) {
            $validated['image_path'] = $request->file('image')->store('banners', 'public');
        }

        unset($validated['image']);

        Banner::create($validated);

        return redirect()
            ->route('banners.index')
            ->with('success', 'Banner created successfully');
    }

    public function show($id)
    {
        $banner = Banner::findOrFail($id);

        return view('Banners::show', compact('banner'));
    }

    public function edit($id)
    {
        $banner = Banner::findOrFail($id);

        return view('Banners::edit', [
            'banner' => $banner,
            'actionTypes' => Banner::ACTION_TYPES,
            'appRoutes' => Banner::APP_ROUTES,
        ]);
    }

    public function update(Request $request, $id)
    {
        $banner = Banner::findOrFail($id);
        $validated = $this->validateBanner($request, $banner->id);

        if ($request->boolean('remove_image')) {
            if ($banner->image_path && Storage::disk('public')->exists($banner->image_path)) {
                Storage::disk('public')->delete($banner->image_path);
            }
            $validated['image_path'] = null;
        }

        if ($request->hasFile('image')) {
            if ($banner->image_path && Storage::disk('public')->exists($banner->image_path)) {
                Storage::disk('public')->delete($banner->image_path);
            }
            $validated['image_path'] = $request->file('image')->store('banners', 'public');
        }

        unset($validated['image'], $validated['remove_image']);

        $banner->update($validated);

        return redirect()
            ->route('banners.index')
            ->with('success', 'Banner updated successfully');
    }

    public function destroy($id)
    {
        $banner = Banner::findOrFail($id);
        $banner->delete();

        return redirect()
            ->route('banners.index')
            ->with('success', 'Banner deleted successfully');
    }

    public function toggleStatus($id)
    {
        $banner = Banner::findOrFail($id);
        $banner->is_active = !$banner->is_active;
        $banner->save();

        return redirect()
            ->back()
            ->with('success', 'Banner status updated');
    }

    private function validateBanner(Request $request, ?int $id = null): array
    {
        $validated = $request->validate([
            'title' => 'required|string|max:255',
            'button_text' => 'required|string|max:80',
            'image' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:4096',
            'image_url' => 'nullable|url|max:500',
            'bg_color' => 'nullable|string|max:20',
            'action_type' => ['required', Rule::in(array_keys(Banner::ACTION_TYPES))],
            'action_value' => 'nullable|string|max:500',
            'open_in_new_tab' => 'nullable|boolean',
            'sort_order' => 'nullable|integer|min:0|max:9999',
            'is_active' => 'nullable|boolean',
            'remove_image' => 'nullable|boolean',
        ]);

        $validated['open_in_new_tab'] = $request->boolean('open_in_new_tab');
        $validated['is_active'] = $request->has('is_active')
            ? $request->boolean('is_active')
            : true;
        $validated['sort_order'] = (int) ($validated['sort_order'] ?? 0);
        $validated['bg_color'] = $validated['bg_color'] ?: '#E3F2FD';

        if (($validated['action_type'] ?? 'none') === 'none') {
            $validated['action_value'] = null;
            $validated['open_in_new_tab'] = false;
        } elseif (empty($validated['action_value'])) {
            throw \Illuminate\Validation\ValidationException::withMessages([
                'action_value' => 'Action value is required for the selected interaction.',
            ]);
        }

        $existing = $id ? Banner::find($id) : null;
        $hasUpload = $request->hasFile('image');
        $hasUrl = !empty($validated['image_url']);
        $keepingPath = $existing && $existing->image_path && !$request->boolean('remove_image');

        if (!$hasUpload && !$hasUrl && !$keepingPath) {
            throw \Illuminate\Validation\ValidationException::withMessages([
                'image' => 'Upload an image or provide an image URL.',
            ]);
        }

        return $validated;
    }
}
