@extends('layouts.template')
@section('title', 'تسجيل حساب جديد')

@section('content')
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-lg border-0">
                    <div class="card-header bg-gradient text-white py-4 text-center"
                        style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <h3 class="mb-0"><i class="bi bi-person-plus-fill"></i> تسجيل حساب جديد</h3>
                        <small class="d-block mt-1 opacity-75">أنشئ حسابك وابدأ استخدام النظام</small>
                    </div>
                    <div class="card-body p-4">
                        @if(session('info'))
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> {{ session('info') }}
                            </div>
                        @endif

                        @if($errors->any())
                            <div class="alert alert-danger">
                                <ul class="mb-0">
                                    @foreach($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <form method="POST" action="{{ route('register.submit') }}">
                            @csrf

                            <!-- اختيار نوع التسجيل -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">نوع التسجيل</label>
                                <div class="d-flex gap-3">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="registration_type"
                                            id="newCompany" value="new_company" checked>
                                        <label class="form-check-label" for="newCompany">
                                            <i class="bi bi-building-add"></i> إنشاء شركة جديدة
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="registration_type"
                                            id="joinCompany" value="join_company">
                                        <label class="form-check-label" for="joinCompany">
                                            <i class="bi bi-building"></i> الانضمام لشركة موجودة
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <hr>

                            <!-- بيانات المستخدم -->
                            <h5 class="mb-3"><i class="bi bi-person"></i> بيانات المستخدم</h5>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">الاسم الكامل <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control @error('name') is-invalid @enderror" name="name"
                                        value="{{ old('name') }}" required>
                                    @error('name')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">رقم الهاتف</label>
                                    <input type="text" class="form-control @error('phone') is-invalid @enderror"
                                        name="phone" value="{{ old('phone') }}" dir="ltr">
                                    @error('phone')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">البريد الإلكتروني <span class="text-danger">*</span></label>
                                <input type="email" class="form-control @error('email') is-invalid @enderror" name="email"
                                    value="{{ old('email') }}" required dir="ltr">
                                @error('email')
                                    <div class="invalid-feedback">{{ $message }}</div>
                                @enderror
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">كلمة المرور <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control @error('password') is-invalid @enderror"
                                        name="password" required>
                                    @error('password')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">تأكيد كلمة المرور <span class="text-danger">*</span></label>
                                    <input type="password" class="form-control" name="password_confirmation" required>
                                </div>
                            </div>

                            <hr>

                            <!-- بيانات الشركة الجديدة -->
                            <div id="newCompanyFields">
                                <h5 class="mb-3"><i class="bi bi-building"></i> بيانات الشركة</h5>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">اسم الشركة (عربي) <span
                                                class="text-danger">*</span></label>
                                        <input type="text" class="form-control @error('company_name') is-invalid @enderror"
                                            name="company_name" value="{{ old('company_name') }}">
                                        @error('company_name')
                                            <div class="invalid-feedback">{{ $message }}</div>
                                        @enderror
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">اسم الشركة (إنجليزي)</label>
                                        <input type="text" class="form-control" name="company_name_en"
                                            value="{{ old('company_name_en') }}" dir="ltr">
                                    </div>
                                </div>
                            </div>

                            <!-- اختيار شركة موجودة -->
                            <div id="joinCompanyFields" style="display: none;">
                                <h5 class="mb-3"><i class="bi bi-building"></i> اختر الشركة</h5>

                                <div class="mb-3">
                                    <label class="form-label">الشركة <span class="text-danger">*</span></label>
                                    <select class="form-select @error('existing_company_id') is-invalid @enderror"
                                        name="existing_company_id">
                                        <option value="">-- اختر الشركة --</option>
                                        @foreach($companies as $company)
                                            <option value="{{ $company->id }}" {{ old('existing_company_id') == $company->id ? 'selected' : '' }}>
                                                {{ $company->name }}
                                            </option>
                                        @endforeach
                                    </select>
                                    @error('existing_company_id')
                                        <div class="invalid-feedback">{{ $message }}</div>
                                    @enderror
                                    <small class="text-muted">
                                        <i class="bi bi-info-circle"></i> ملاحظة: طلب الانضمام يحتاج موافقة من مالك الشركة
                                    </small>
                                </div>
                            </div>

                            <div class="d-grid gap-2 mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-person-plus"></i> إنشاء الحساب
                                </button>
                            </div>
                        </form>

                        <hr>

                        <p class="text-center mb-0">
                            لديك حساب بالفعل؟
                            <a href="{{ route('login') }}" class="fw-bold">تسجيل الدخول</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const newCompanyRadio = document.getElementById('newCompany');
                const joinCompanyRadio = document.getElementById('joinCompany');
                const newCompanyFields = document.getElementById('newCompanyFields');
                const joinCompanyFields = document.getElementById('joinCompanyFields');

                function toggleFields() {
                    if (newCompanyRadio.checked) {
                        newCompanyFields.style.display = 'block';
                        joinCompanyFields.style.display = 'none';
                    } else {
                        newCompanyFields.style.display = 'none';
                        joinCompanyFields.style.display = 'block';
                    }
                }

                newCompanyRadio.addEventListener('change', toggleFields);
                joinCompanyRadio.addEventListener('change', toggleFields);
                toggleFields();
            });
        </script>
    @endpush
@endsection