@extends('layouts.template')
@section('title', 'إعداد الشركة')

@section('content')
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <!-- شريط التقدم -->
            <div class="mb-5">
                <div class="d-flex justify-content-between mb-2">
                    <span class="badge bg-primary rounded-pill px-3 py-2">1. البيانات الأساسية</span>
                    <span class="badge {{ $step >= 2 ? 'bg-primary' : 'bg-secondary' }} rounded-pill px-3 py-2">2. الورق الرسمي</span>
                    <span class="badge {{ $step >= 3 ? 'bg-primary' : 'bg-secondary' }} rounded-pill px-3 py-2">3. إعدادات الباركود</span>
                </div>
                <div class="progress" style="height: 8px;">
                    <div class="progress-bar" role="progressbar" style="width: {{ ($step / 3) * 100 }}%"></div>
                </div>
            </div>

            @if($step == 1)
            <!-- الخطوة 1: البيانات الأساسية -->
            <div class="card shadow-lg border-0">
                <div class="card-header bg-primary text-white py-3">
                    <h4 class="mb-0"><i class="bi bi-building"></i> مرحباً! لنبدأ بإعداد شركتك</h4>
                </div>
                <div class="card-body p-4">
                    <form action="{{ route('company.setup.step1') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">اسم الشركة (عربي) <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-lg" name="name" 
                                       value="{{ $company->name ?? '' }}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">اسم الشركة (إنجليزي)</label>
                                <input type="text" class="form-control form-control-lg" name="name_en" 
                                       value="{{ $company->name_en ?? '' }}">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">العنوان</label>
                                <input type="text" class="form-control" name="address" 
                                       value="{{ $company->address ?? '' }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">رقم الهاتف</label>
                                <input type="text" class="form-control" name="phone" 
                                       value="{{ $company->phone ?? '' }}">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">البريد الإلكتروني</label>
                                <input type="email" class="form-control" name="email" 
                                       value="{{ $company->email ?? '' }}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">بادئة رقم الصادر</label>
                                <input type="text" class="form-control" name="letter_prefix" 
                                       value="{{ $company->letter_prefix ?? 'OUT' }}" maxlength="10">
                                <small class="text-muted">مثال: OUT, صادر, خ</small>
                            </div>
                        </div>

                        <hr class="my-4">

                        <h5 class="mb-3"><i class="bi bi-image"></i> الشعار والتوقيع والختم</h5>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">شعار الشركة</label>
                                @if($company->logo ?? false)
                                <div class="mb-2">
                                    <img src="{{ Storage::url($company->logo) }}" class="img-thumbnail" style="max-height: 80px;">
                                </div>
                                @endif
                                <input type="file" class="form-control" name="logo" accept="image/*">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">التوقيع</label>
                                @if($company->signature ?? false)
                                <div class="mb-2">
                                    <img src="{{ Storage::url($company->signature) }}" class="img-thumbnail" style="max-height: 80px;">
                                </div>
                                @endif
                                <input type="file" class="form-control" name="signature" accept="image/*">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label">الختم</label>
                                @if($company->stamp ?? false)
                                <div class="mb-2">
                                    <img src="{{ Storage::url($company->stamp) }}" class="img-thumbnail" style="max-height: 80px;">
                                </div>
                                @endif
                                <input type="file" class="form-control" name="stamp" accept="image/*">
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <button type="submit" class="btn btn-primary btn-lg px-5">
                                التالي <i class="bi bi-arrow-left"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            @elseif($step == 2)
            <!-- الخطوة 2: رفع الورق الرسمي -->
            <div class="card shadow-lg border-0">
                <div class="card-header bg-info text-white py-3">
                    <h4 class="mb-0"><i class="bi bi-file-earmark-pdf"></i> رفع الورق الرسمي</h4>
                </div>
                <div class="card-body p-4">
                    <div class="alert alert-info mb-4">
                        <i class="bi bi-info-circle"></i>
                        <strong>نصيحة:</strong> قم بعمل سكان للورق الرسمي الخاص بشركتك (الورقة الفارغة مع الشعار والترويسة) وارفعه هنا.
                        سيتم استخدامه كخلفية لجميع الخطابات.
                    </div>

                    <form action="{{ route('company.setup.step2') }}" method="POST" enctype="multipart/form-data">
                        @csrf
                        
                        <div class="text-center mb-4">
                            <div class="border rounded-3 p-5 bg-light" id="dropZone">
                                @if($company->letterhead_file)
                                <div class="mb-3">
                                    <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
                                    <p class="mt-2 text-success fw-bold">تم رفع الورق الرسمي</p>
                                    <a href="{{ Storage::url($company->letterhead_file) }}" target="_blank" class="btn btn-outline-primary btn-sm">
                                        <i class="bi bi-eye"></i> معاينة
                                    </a>
                                </div>
                                @else
                                <i class="bi bi-cloud-upload text-primary" style="font-size: 3rem;"></i>
                                <p class="mt-2">اسحب الملف هنا أو انقر للاختيار</p>
                                @endif
                                <input type="file" class="form-control mt-3" name="letterhead_file" 
                                       accept=".pdf,image/*" id="letterheadInput">
                                <small class="text-muted d-block mt-2">PDF أو صورة (PNG, JPG) - حد أقصى 5MB</small>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="{{ route('company.setup', ['step' => 1]) }}" class="btn btn-outline-secondary btn-lg px-4">
                                <i class="bi bi-arrow-right"></i> السابق
                            </a>
                            <div>
                                <button type="submit" name="skip" value="1" class="btn btn-outline-secondary btn-lg px-4 me-2">
                                    تخطي
                                </button>
                                <button type="submit" class="btn btn-primary btn-lg px-5">
                                    التالي <i class="bi bi-arrow-left"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            @elseif($step == 3)
            <!-- الخطوة 3: إعدادات الباركود -->
            <div class="card shadow-lg border-0">
                <div class="card-header bg-success text-white py-3">
                    <h4 class="mb-0"><i class="bi bi-upc-scan"></i> إعدادات الباركود والمعلومات</h4>
                </div>
                <div class="card-body p-4">
                    <form action="{{ route('company.setup.step3') }}" method="POST">
                        @csrf
                        
                        <div class="row">
                            <div class="col-md-6">
                                <!-- موقع الباركود -->
                                <div class="mb-4">
                                    <label class="form-label fw-bold">موقع الباركود والمعلومات على الورقة</label>
                                    <div class="d-flex gap-4 mt-2">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="barcode_position" 
                                                   id="posRight" value="right" 
                                                   {{ ($company->barcode_position ?? 'right') == 'right' ? 'checked' : '' }}>
                                            <label class="form-check-label" for="posRight">
                                                <i class="bi bi-align-end"></i> يمين الورقة
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="barcode_position" 
                                                   id="posLeft" value="left"
                                                   {{ ($company->barcode_position ?? 'right') == 'left' ? 'checked' : '' }}>
                                            <label class="form-check-label" for="posLeft">
                                                <i class="bi bi-align-start"></i> يسار الورقة
                                            </label>
                                        </div>
                                    </div>
                                </div>

                                <!-- العناصر المعروضة -->
                                <div class="mb-4">
                                    <label class="form-label fw-bold">العناصر المعروضة</label>
                                    <div class="mt-2">
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" name="show_barcode" 
                                                   id="chkBarcode" value="1"
                                                   {{ ($company->show_barcode ?? true) ? 'checked' : '' }}>
                                            <label class="form-check-label" for="chkBarcode">الباركود</label>
                                        </div>
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" name="show_reference_number" 
                                                   id="chkRef" value="1"
                                                   {{ ($company->show_reference_number ?? true) ? 'checked' : '' }}>
                                            <label class="form-check-label" for="chkRef">الرقم الصادر</label>
                                        </div>
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" name="show_hijri_date" 
                                                   id="chkHijri" value="1"
                                                   {{ ($company->show_hijri_date ?? true) ? 'checked' : '' }}>
                                            <label class="form-check-label" for="chkHijri">التاريخ الهجري</label>
                                        </div>
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" name="show_gregorian_date" 
                                                   id="chkGreg" value="1"
                                                   {{ ($company->show_gregorian_date ?? true) ? 'checked' : '' }}>
                                            <label class="form-check-label" for="chkGreg">التاريخ الميلادي</label>
                                        </div>
                                        <div class="form-check form-switch mb-2">
                                            <input class="form-check-input" type="checkbox" name="show_subject_in_header" 
                                                   id="chkSubject" value="1"
                                                   {{ ($company->show_subject_in_header ?? true) ? 'checked' : '' }}>
                                            <label class="form-check-label" for="chkSubject">الموضوع</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <!-- معاينة -->
                                <div class="border rounded p-3 bg-light" style="min-height: 300px; position: relative;">
                                    <small class="text-muted d-block text-center mb-3">[ معاينة الورقة ]</small>
                                    
                                    <div id="previewBox" class="position-absolute p-2 border border-primary rounded bg-white text-center"
                                         style="width: 120px; top: 50px;">
                                        <div class="bg-secondary mb-1" style="height: 30px;"></div>
                                        <small class="d-block">OUT-2024-00001</small>
                                        <small class="d-block text-muted">1446/06/10</small>
                                        <small class="d-block text-muted">2024/12/12</small>
                                        <small class="d-block text-primary" style="font-size: 10px;">الموضوع</small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-4">
                            <a href="{{ route('company.setup', ['step' => 2]) }}" class="btn btn-outline-secondary btn-lg px-4">
                                <i class="bi bi-arrow-right"></i> السابق
                            </a>
                            <button type="submit" class="btn btn-success btn-lg px-5">
                                <i class="bi bi-check-circle"></i> إنهاء الإعداد
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            @endif
        </div>
    </div>
</div>

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function() {
    // تحديث موقع المعاينة
    const posRight = document.getElementById('posRight');
    const posLeft = document.getElementById('posLeft');
    const previewBox = document.getElementById('previewBox');

    function updatePreviewPosition() {
        if (posRight && posRight.checked) {
            previewBox.style.right = '20px';
            previewBox.style.left = 'auto';
        } else if (posLeft) {
            previewBox.style.left = '20px';
            previewBox.style.right = 'auto';
        }
    }

    if (posRight) posRight.addEventListener('change', updatePreviewPosition);
    if (posLeft) posLeft.addEventListener('change', updatePreviewPosition);
    updatePreviewPosition();
});
</script>
@endpush
@endsection
