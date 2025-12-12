@extends('layouts.template')
@section('title', 'تعديل القالب - ' . $template->name)

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card shadow-sm">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0"><i class="bi bi-pencil"></i> تعديل القالب</h5>
                </div>
                <div class="card-body">
                    <form action="{{ route('templates.update', $template->id) }}" method="POST">
                        @csrf
                        @method('PUT')
                        
                        <div class="row mb-4">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">اسم القالب <span class="text-danger">*</span></label>
                                <input type="text" class="form-control @error('name') is-invalid @enderror" 
                                       name="name" value="{{ old('name', $template->name) }}" required>
                                @error('name')
                                <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">الفئة</label>
                                <select class="form-select" name="category">
                                    <option value="">-- اختر الفئة --</option>
                                    <option value="hr" {{ $template->category == 'hr' ? 'selected' : '' }}>الموارد البشرية</option>
                                    <option value="finance" {{ $template->category == 'finance' ? 'selected' : '' }}>المالية</option>
                                    <option value="admin" {{ $template->category == 'admin' ? 'selected' : '' }}>الإدارية</option>
                                    <option value="official" {{ $template->category == 'official' ? 'selected' : '' }}>الرسمية</option>
                                    <option value="other" {{ $template->category == 'other' ? 'selected' : '' }}>أخرى</option>
                                </select>
                            </div>
                            <div class="col-md-2 mb-3">
                                <label class="form-label">الحالة</label>
                                <div class="form-check form-switch mt-2">
                                    <input class="form-check-input" type="checkbox" name="is_active" 
                                           {{ $template->is_active ? 'checked' : '' }}>
                                    <label class="form-check-label">نشط</label>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">محتوى القالب <span class="text-danger">*</span></label>
                            <textarea class="form-control @error('content') is-invalid @enderror" 
                                      name="content" rows="15" required>{{ old('content', $template->content) }}</textarea>
                            @error('content')
                            <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                            <small class="text-muted">
                                <i class="bi bi-info-circle"></i>
                                المتغيرات المتاحة: {recipient_name}, {recipient_title}, {date}, {company_name}
                            </small>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning btn-lg">
                                <i class="bi bi-check-circle"></i> حفظ التعديلات
                            </button>
                            <a href="{{ route('templates.index') }}" class="btn btn-secondary btn-lg">
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
