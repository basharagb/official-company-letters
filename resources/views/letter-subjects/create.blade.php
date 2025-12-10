@extends('layouts.template')
@section('title', 'إضافة موضوع جديد')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-card-heading"></i> إضافة موضوع خطاب جديد
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="{{ route('letter-subjects.store') }}">
                            @csrf

                            <div class="mb-3">
                                <label class="form-label">موضوع الخطاب <span class="text-danger">*</span></label>
                                <input type="text" class="form-control @error('subject') is-invalid @enderror"
                                    name="subject" value="{{ old('subject') }}" required
                                    placeholder="مثال: خطاب تعريف بالراتب">
                                @error('subject')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>

                            <div class="mb-3">
                                <label class="form-label">التصنيف (اختياري)</label>
                                <input type="text" class="form-control @error('category') is-invalid @enderror"
                                    name="category" value="{{ old('category') }}"
                                    placeholder="مثال: موارد بشرية، مالية، إدارية">
                                @error('category')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                                <small class="text-muted">يساعد التصنيف في تنظيم المواضيع</small>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-circle"></i> حفظ الموضوع
                                </button>
                                <a href="{{ route('letter-subjects.index') }}" class="btn btn-secondary">
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