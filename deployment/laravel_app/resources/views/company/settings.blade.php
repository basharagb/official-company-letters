@extends('layouts.template')
@section('title', 'إعدادات الشركة')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            @if(!$company)
            <!-- إنشاء شركة جديدة -->
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="bi bi-building-add"></i> إنشاء شركة جديدة</h5>
                </div>
                <div class="card-body">
                    <form action="{{ route('company.store') }}" method="POST">
                        @csrf
                        <div class="mb-3">
                            <label class="form-label">اسم الشركة</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check"></i> إنشاء الشركة
                        </button>
                    </form>
                </div>
            </div>
            @else
            <!-- تعديل بيانات الشركة -->
            <form action="{{ route('company.update') }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')
                
                <!-- البيانات الأساسية -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-building"></i> البيانات الأساسية</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">اسم الشركة (عربي)</label>
                                <input type="text" class="form-control" name="name" 
                                       value="{{ $company->name }}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">اسم الشركة (إنجليزي)</label>
                                <input type="text" class="form-control" name="name_en" 
                                       value="{{ $company->name_en }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">العنوان</label>
                                <input type="text" class="form-control" name="address" 
                                       value="{{ $company->address }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">رقم الهاتف</label>
                                <input type="text" class="form-control" name="phone" 
                                       value="{{ $company->phone }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">البريد الإلكتروني</label>
                                <input type="email" class="form-control" name="email" 
                                       value="{{ $company->email }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">الموقع الإلكتروني</label>
                                <input type="url" class="form-control" name="website" 
                                       value="{{ $company->website }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">السجل التجاري</label>
                                <input type="text" class="form-control" name="commercial_register" 
                                       value="{{ $company->commercial_register }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">الرقم الضريبي</label>
                                <input type="text" class="form-control" name="tax_number" 
                                       value="{{ $company->tax_number }}">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- إعدادات الخطابات -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="bi bi-gear"></i> إعدادات الخطابات</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">بادئة رقم الصادر</label>
                                <input type="text" class="form-control" name="letter_prefix" 
                                       value="{{ $company->letter_prefix }}" maxlength="10">
                                <small class="text-muted">مثال: OUT, صادر, خ</small>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">آخر رقم صادر</label>
                                <input type="text" class="form-control" 
                                       value="{{ $company->last_letter_number }}" disabled>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- الشعار والتوقيع والختم -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="bi bi-image"></i> الشعار والتوقيع والختم</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- الشعار -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label">شعار الشركة</label>
                                @if($company->logo)
                                <div class="mb-2">
                                    <img src="{{ Storage::url($company->logo) }}" 
                                         class="img-thumbnail" style="max-height: 100px;">
                                </div>
                                @endif
                                <input type="file" class="form-control" name="logo" accept="image/*">
                            </div>
                            
                            <!-- التوقيع -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label">توقيع المصرّح</label>
                                @if($company->signature)
                                <div class="mb-2">
                                    <img src="{{ Storage::url($company->signature) }}" 
                                         class="img-thumbnail" style="max-height: 100px;">
                                </div>
                                @endif
                                <input type="file" class="form-control" name="signature" accept="image/*">
                            </div>
                            
                            <!-- الختم -->
                            <div class="col-md-4 mb-3">
                                <label class="form-label">الختم الرسمي</label>
                                @if($company->stamp)
                                <div class="mb-2">
                                    <img src="{{ Storage::url($company->stamp) }}" 
                                         class="img-thumbnail" style="max-height: 100px;">
                                </div>
                                @endif
                                <input type="file" class="form-control" name="stamp" accept="image/*">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-check-circle"></i> حفظ التغييرات
                    </button>
                    <a href="{{ route('dashboard') }}" class="btn btn-secondary btn-lg">
                        <i class="bi bi-arrow-right"></i> رجوع
                    </a>
                </div>
            </form>
            @endif
        </div>
    </div>
</div>
@endsection
