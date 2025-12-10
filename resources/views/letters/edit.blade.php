@extends('layouts.template')
@section('title', 'تعديل الخطاب - ' . $letter->reference_number)

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card shadow-sm">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0">
                            <i class="bi bi-pencil"></i> تعديل الخطاب - {{ $letter->reference_number }}
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" action="{{ route('letters.update', $letter->id) }}">
                            @csrf
                            @method('PUT')

                            <!-- معلومات المستلم -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-muted border-bottom pb-2">
                                        <i class="bi bi-person"></i> معلومات المستلم
                                    </h6>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">اسم المستلم</label>
                                    <input type="text" class="form-control" name="recipient_name"
                                        value="{{ $letter->recipient_name }}">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">صفة المستلم</label>
                                    <input type="text" class="form-control" name="recipient_title"
                                        value="{{ $letter->recipient_title }}">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">الجهة</label>
                                    <input type="text" class="form-control" name="recipient_organization"
                                        value="{{ $letter->recipient_organization }}">
                                </div>
                            </div>

                            <!-- موضوع الخطاب -->
                            <div class="mb-4">
                                <h6 class="text-muted border-bottom pb-2">
                                    <i class="bi bi-card-heading"></i> موضوع الخطاب
                                </h6>
                                <input type="text" class="form-control form-control-lg" name="subject"
                                    value="{{ $letter->subject }}" required>
                            </div>

                            <!-- محتوى الخطاب -->
                            <div class="mb-4">
                                <h6 class="text-muted border-bottom pb-2">
                                    <i class="bi bi-body-text"></i> محتوى الخطاب
                                </h6>
                                <textarea class="form-control" name="content" rows="12" required
                                    style="font-size: 16px; line-height: 1.8;">{{ $letter->content }}</textarea>
                            </div>

                            <!-- أزرار الإجراءات -->
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-warning btn-lg">
                                    <i class="bi bi-check-circle"></i> حفظ التعديلات
                                </button>
                                <a href="{{ route('letters.show', $letter->id) }}" class="btn btn-secondary btn-lg">
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