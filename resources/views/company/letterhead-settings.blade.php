@extends('layouts.template')
@section('title', 'إعدادات الورق الرسمي')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <form action="{{ route('company.letterhead.update') }}" method="POST" enctype="multipart/form-data">
                @csrf
                @method('PUT')
                
                <!-- رفع الورق الرسمي -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-file-earmark-pdf"></i> الورق الرسمي للشركة</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">رفع ملف الورق الرسمي (PDF أو صورة)</label>
                                <input type="file" class="form-control" name="letterhead_file" 
                                       accept=".pdf,image/*" id="letterheadFile">
                                <small class="text-muted">
                                    يمكنك رفع سكان للورق الرسمي بصيغة PDF أو صورة (PNG, JPG)
                                </small>
                            </div>
                            <div class="col-md-6">
                                @if($company->letterhead_file)
                                <div class="alert alert-success">
                                    <i class="bi bi-check-circle"></i> تم رفع الورق الرسمي
                                    <br>
                                    <a href="{{ Storage::url($company->letterhead_file) }}" target="_blank" class="btn btn-sm btn-outline-primary mt-2">
                                        <i class="bi bi-eye"></i> معاينة الملف
                                    </a>
                                    <button type="button" class="btn btn-sm btn-outline-danger mt-2" 
                                            onclick="document.getElementById('deleteLetterhead').value='1'">
                                        <i class="bi bi-trash"></i> حذف
                                    </button>
                                    <input type="hidden" name="delete_letterhead" id="deleteLetterhead" value="0">
                                </div>
                                @else
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> لم يتم رفع ورق رسمي بعد
                                    <br>
                                    <small>قم بعمل سكان للورق الرسمي الخاص بشركتك وارفعه هنا</small>
                                </div>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>

                <!-- إعدادات الباركود والمعلومات -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="bi bi-upc-scan"></i> إعدادات الباركود والمعلومات</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- موقع الباركود -->
                            <div class="col-md-6 mb-4">
                                <label class="form-label fw-bold">موقع الباركود والمعلومات</label>
                                <div class="d-flex gap-3">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="barcode_position" 
                                               id="positionRight" value="right" 
                                               {{ ($company->barcode_position ?? 'right') == 'right' ? 'checked' : '' }}>
                                        <label class="form-check-label" for="positionRight">
                                            <i class="bi bi-align-end"></i> يمين الورقة
                                        </label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="barcode_position" 
                                               id="positionLeft" value="left"
                                               {{ ($company->barcode_position ?? 'right') == 'left' ? 'checked' : '' }}>
                                        <label class="form-check-label" for="positionLeft">
                                            <i class="bi bi-align-start"></i> يسار الورقة
                                        </label>
                                    </div>
                                </div>
                            </div>

                            <!-- المسافات -->
                            <div class="col-md-3 mb-4">
                                <label class="form-label">المسافة من الأعلى (مم)</label>
                                <input type="number" class="form-control" name="barcode_top_margin" 
                                       value="{{ $company->barcode_top_margin ?? 20 }}" min="0" max="100">
                            </div>
                            <div class="col-md-3 mb-4">
                                <label class="form-label">المسافة من الجانب (مم)</label>
                                <input type="number" class="form-control" name="barcode_side_margin" 
                                       value="{{ $company->barcode_side_margin ?? 15 }}" min="0" max="100">
                            </div>
                        </div>

                        <hr>

                        <!-- خيارات العرض -->
                        <h6 class="fw-bold mb-3">العناصر المعروضة (بالترتيب من الأعلى للأسفل)</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" name="show_barcode" 
                                           id="showBarcode" value="1"
                                           {{ ($company->show_barcode ?? true) ? 'checked' : '' }}>
                                    <label class="form-check-label" for="showBarcode">
                                        <i class="bi bi-upc"></i> إظهار الباركود
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" name="show_reference_number" 
                                           id="showRefNumber" value="1"
                                           {{ ($company->show_reference_number ?? true) ? 'checked' : '' }}>
                                    <label class="form-check-label" for="showRefNumber">
                                        <i class="bi bi-hash"></i> إظهار الرقم الصادر (تحت الباركود)
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" name="show_hijri_date" 
                                           id="showHijri" value="1"
                                           {{ ($company->show_hijri_date ?? true) ? 'checked' : '' }}>
                                    <label class="form-check-label" for="showHijri">
                                        <i class="bi bi-calendar"></i> إظهار التاريخ الهجري
                                    </label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" name="show_gregorian_date" 
                                           id="showGregorian" value="1"
                                           {{ ($company->show_gregorian_date ?? true) ? 'checked' : '' }}>
                                    <label class="form-check-label" for="showGregorian">
                                        <i class="bi bi-calendar2"></i> إظهار التاريخ الميلادي
                                    </label>
                                </div>
                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" name="show_subject_in_header" 
                                           id="showSubject" value="1"
                                           {{ ($company->show_subject_in_header ?? true) ? 'checked' : '' }}>
                                    <label class="form-check-label" for="showSubject">
                                        <i class="bi bi-card-heading"></i> إظهار الموضوع
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- معاينة -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0"><i class="bi bi-eye"></i> معاينة الترتيب</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-8 mx-auto">
                                <div class="border rounded p-4 bg-light position-relative" style="min-height: 400px;">
                                    <!-- محاكاة الورقة -->
                                    <div class="text-center text-muted mb-3">
                                        <small>[ الورق الرسمي للشركة ]</small>
                                    </div>
                                    
                                    <!-- منطقة الباركود -->
                                    <div id="barcodePreview" class="position-absolute" 
                                         style="top: 60px; width: 150px; text-align: center; padding: 10px; border: 2px dashed #0d6efd; border-radius: 8px; background: rgba(13,110,253,0.05);">
                                        <div id="previewBarcode" class="mb-2">
                                            <svg id="barcodeSvg"></svg>
                                        </div>
                                        <div id="previewRefNumber" class="fw-bold small">OUT-2024-00001</div>
                                        <div id="previewHijriDate" class="small text-muted">1446/06/10</div>
                                        <div id="previewGregorianDate" class="small text-muted">2024/12/12</div>
                                        <div id="previewSubject" class="small text-primary mt-1" style="font-size: 10px;">الموضوع: خطاب رسمي</div>
                                    </div>

                                    <!-- محتوى الخطاب -->
                                    <div class="text-center mt-5 pt-5">
                                        <div class="text-muted">
                                            <br><br><br><br>
                                            <p>[ محتوى الخطاب ]</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-check-circle"></i> حفظ الإعدادات
                    </button>
                    <a href="{{ route('company.settings') }}" class="btn btn-secondary btn-lg">
                        <i class="bi bi-arrow-right"></i> رجوع
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>

@push('scripts')
<script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // توليد الباركود للمعاينة
    if (typeof JsBarcode !== 'undefined') {
        JsBarcode("#barcodeSvg", "OUT-2024-00001", {
            format: "CODE128",
            width: 1.5,
            height: 40,
            displayValue: false
        });
    }

    // تحديث موقع الباركود
    const positionRight = document.getElementById('positionRight');
    const positionLeft = document.getElementById('positionLeft');
    const barcodePreview = document.getElementById('barcodePreview');

    function updatePosition() {
        if (positionRight.checked) {
            barcodePreview.style.right = '20px';
            barcodePreview.style.left = 'auto';
        } else {
            barcodePreview.style.left = '20px';
            barcodePreview.style.right = 'auto';
        }
    }

    positionRight.addEventListener('change', updatePosition);
    positionLeft.addEventListener('change', updatePosition);
    updatePosition();

    // تحديث العناصر المعروضة
    const toggles = {
        'showBarcode': 'previewBarcode',
        'showRefNumber': 'previewRefNumber',
        'showHijri': 'previewHijriDate',
        'showGregorian': 'previewGregorianDate',
        'showSubject': 'previewSubject'
    };

    Object.keys(toggles).forEach(function(toggleId) {
        const toggle = document.getElementById(toggleId);
        const preview = document.getElementById(toggles[toggleId]);
        
        toggle.addEventListener('change', function() {
            preview.style.display = this.checked ? 'block' : 'none';
        });
        
        // تطبيق الحالة الأولية
        preview.style.display = toggle.checked ? 'block' : 'none';
    });
});
</script>
@endpush
@endsection
