@extends('layouts.template')
@section('title', 'إضافة صفة جديدة')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-person-badge"></i> إضافة صفة مستلم جديدة
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="{{ route('recipient-titles.store') }}">
                            @csrf

                            <div class="mb-3">
                                <label class="form-label">صفة المستلم <span class="text-danger">*</span></label>
                                <input type="text" class="form-control @error('title') is-invalid @enderror" name="title"
                                    value="{{ old('title') }}" required placeholder="مثال: المدير العام، الرئيس التنفيذي">
                                @error('title')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                                <small class="text-muted">أمثلة: المدير العام، الرئيس التنفيذي، مدير الموارد البشرية</small>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> حفظ الصفة
                                </button>
                                <a href="{{ route('recipient-titles.index') }}" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> إلغاء
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection