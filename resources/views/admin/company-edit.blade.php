@extends('layouts.template')
@section('title', 'تعديل بيانات الشركة')

@section('content')
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-pencil-square"></i> تعديل بيانات الشركة
            </h2>
            <a href="{{ route('admin.companies') }}" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-right"></i> رجوع
            </a>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <form action="{{ route('admin.company.update', $company) }}" method="POST">
                    @csrf
                    @method('PUT')

                    <div class="row g-3">
                        <!-- اسم الشركة بالعربي -->
                        <div class="col-md-6">
                            <label for="name" class="form-label">اسم الشركة (عربي) <span
                                    class="text-danger">*</span></label>
                            <input type="text" class="form-control @error('name') is-invalid @enderror" id="name"
                                name="name" value="{{ old('name', $company->name) }}" required>
                            @error('name')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- اسم الشركة بالإنجليزي -->
                        <div class="col-md-6">
                            <label for="name_en" class="form-label">اسم الشركة (English)</label>
                            <input type="text" class="form-control @error('name_en') is-invalid @enderror" id="name_en"
                                name="name_en" value="{{ old('name_en', $company->name_en) }}">
                            @error('name_en')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- البريد الإلكتروني -->
                        <div class="col-md-6">
                            <label for="email" class="form-label">البريد الإلكتروني <span
                                    class="text-danger">*</span></label>
                            <input type="email" class="form-control @error('email') is-invalid @enderror" id="email"
                                name="email" value="{{ old('email', $company->email) }}" required>
                            @error('email')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- رقم الهاتف -->
                        <div class="col-md-6">
                            <label for="phone" class="form-label">رقم الهاتف</label>
                            <input type="text" class="form-control @error('phone') is-invalid @enderror" id="phone"
                                name="phone" value="{{ old('phone', $company->phone) }}">
                            @error('phone')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- العنوان -->
                        <div class="col-12">
                            <label for="address" class="form-label">العنوان</label>
                            <textarea class="form-control @error('address') is-invalid @enderror" id="address"
                                name="address" rows="2">{{ old('address', $company->address) }}</textarea>
                            @error('address')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- الموقع الإلكتروني -->
                        <div class="col-md-6">
                            <label for="website" class="form-label">الموقع الإلكتروني</label>
                            <input type="url" class="form-control @error('website') is-invalid @enderror" id="website"
                                name="website" value="{{ old('website', $company->website) }}"
                                placeholder="https://example.com">
                            @error('website')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- السجل التجاري -->
                        <div class="col-md-6">
                            <label for="commercial_register" class="form-label">السجل التجاري</label>
                            <input type="text" class="form-control @error('commercial_register') is-invalid @enderror"
                                id="commercial_register" name="commercial_register"
                                value="{{ old('commercial_register', $company->commercial_register) }}">
                            @error('commercial_register')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>

                        <!-- الرقم الضريبي -->
                        <div class="col-md-6">
                            <label for="tax_number" class="form-label">الرقم الضريبي</label>
                            <input type="text" class="form-control @error('tax_number') is-invalid @enderror"
                                id="tax_number" name="tax_number" value="{{ old('tax_number', $company->tax_number) }}">
                            @error('tax_number')
                                <div class="invalid-feedback">{{ $message }}</div>
                            @enderror
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle"></i> حفظ التعديلات
                        </button>
                        <a href="{{ route('admin.companies') }}" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> إلغاء
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection