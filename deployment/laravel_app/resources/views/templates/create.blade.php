@extends('layouts.template')
@section('title', 'إنشاء قالب جديد')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-plus-circle"></i> إنشاء قالب جديد</h5>
                    </div>
                    <div class="card-body">
                        <form action="{{ route('templates.store') }}" method="POST">
                            @csrf

                            <div class="row mb-4">
                                <div class="col-md-8 mb-3">
                                    <label class="form-label">اسم القالب <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control @error('name') is-invalid @enderror" name="name"
                                        value="{{ old('name') }}" required placeholder="مثال: خطاب تعريف بالراتب">
                                    @error('name')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">الفئة</label>
                                    <select class="form-select" name="category">
                                        <option value="">-- اختر الفئة --</option>
                                        <option value="hr">الموارد البشرية</option>
                                        <option value="finance">المالية</option>
                                        <option value="admin">الإدارية</option>
                                        <option value="official">الرسمية</option>
                                        <option value="other">أخرى</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">محتوى القالب <span class="text-danger">*</span></label>
                                <textarea class="form-control @error('content') is-invalid @enderror" name="content"
                                    rows="15" required placeholder="اكتب محتوى القالب هنا...

    يمكنك استخدام المتغيرات التالية:
    {recipient_name} - اسم المستلم
    {recipient_title} - صفة المستلم
    {date} - التاريخ
    {company_name} - اسم الشركة">{{ old('content') }}</textarea>
                                @error('content')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                                <small class="text-muted">
                                    <i class="bi bi-info-circle"></i>
                                    المتغيرات المتاحة: {recipient_name}, {recipient_title}, {date}, {company_name}
                                </small>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-check-circle"></i> حفظ القالب
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