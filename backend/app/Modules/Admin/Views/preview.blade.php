@extends('layouts.admin')

@section('title', 'Preview Screen')
@section('page-title', 'Preview Screen')

@section('content')
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Preview Contents</h3>
                </div>
                <div class="card-body">
                    <p>This is the preview screen for the admin interface.</p>
                    <p>Use this page to display a live preview of your site, landing page, or content blocks.</p>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card card-primary">
                                <div class="card-body">
                                    <h5>Preview item 1</h5>
                                    <p>This section can show a quick live preview of the homepage layout.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-secondary">
                                <div class="card-body">
                                    <h5>Preview item 2</h5>
                                    <p>Use this area to display sample content, banners, or feature blocks.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@stop
