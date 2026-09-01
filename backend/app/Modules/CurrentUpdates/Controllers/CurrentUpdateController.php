<?php

namespace App\Modules\CurrentUpdates\Controllers;

use App\Http\Controllers\Controller;
use App\Modules\CurrentUpdates\Models\CurrentUpdate;
use Illuminate\Http\Request;

class CurrentUpdateController extends Controller
{
    public function index()
    {
        $updates = CurrentUpdate::ordered()->get();
        return view('CurrentUpdates::index', compact('updates'));
    }

    public function create()
    {
        return view('CurrentUpdates::create');
    }

    public function store(Request $request)
    {
        CurrentUpdate::create($this->validated($request));

        return redirect()
            ->route('current-updates.index')
            ->with('success', 'Current update added successfully');
    }

    public function edit($id)
    {
        $update = CurrentUpdate::findOrFail($id);
        return view('CurrentUpdates::edit', compact('update'));
    }

    public function update(Request $request, $id)
    {
        $update = CurrentUpdate::findOrFail($id);
        $update->update($this->validated($request));

        return redirect()
            ->route('current-updates.index')
            ->with('success', 'Current update updated successfully');
    }

    public function destroy($id)
    {
        CurrentUpdate::findOrFail($id)->delete();

        return redirect()
            ->route('current-updates.index')
            ->with('success', 'Current update deleted successfully');
    }

    public function toggleStatus($id)
    {
        $update = CurrentUpdate::findOrFail($id);
        $update->is_active = !$update->is_active;
        $update->save();

        return back()->with('success', 'Status updated');
    }

    private function validated(Request $request): array
    {
        $data = $request->validate([
            'value' => 'required|string|max:50',
            'label' => 'required|string|max:120',
            'bg_color' => 'nullable|string|max:20',
            'text_color' => 'nullable|string|max:20',
            'sort_order' => 'nullable|integer|min:0|max:9999',
            'is_active' => 'nullable|boolean',
        ]);

        $data['bg_color'] = $data['bg_color'] ?: '#EFF6FF';
        $data['text_color'] = $data['text_color'] ?: '#1D4ED8';
        $data['sort_order'] = (int) ($data['sort_order'] ?? 0);
        $data['is_active'] = $request->boolean('is_active', true);

        return $data;
    }
}
