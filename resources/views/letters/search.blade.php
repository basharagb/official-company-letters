@extends('layouts.template')
@section('title', 'البحث في الخطابات')

@section('content')
    <div class="container">
        <!-- نموذج البحث -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-search"></i> البحث في الخطابات</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('letters.search') }}" method="GET">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">بحث نصي</label>
                            <input type="text" class="form-control" name="q" value="{{ request('q') }}"
                                placeholder="رقم الصادر، العنوان، المحتوى...">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">من تاريخ</label>
                            <input type="date" class="form-control" name="from" value="{{ request('from') }}">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">إلى تاريخ</label>
                            <input type="date" class="form-control" name="to" value="{{ request('to') }}">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">الحالة</label>
                            <select class="form-select" name="status">
                                <option value="">الكل</option>
                                <option value="draft" {{ request('status') == 'draft' ? 'selected' : '' }}>مسودة</option>
                                <option value="issued" {{ request('status') == 'issued' ? 'selected' : '' }}>صادر</option>
                                <option value="sent" {{ request('status') == 'sent' ? 'selected' : '' }}>مُرسل</option>
                                <option value="archived" {{ request('status') == 'archived' ? 'selected' : '' }}>مؤرشف
                                </option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-search"></i> بحث
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- نتائج البحث -->
        <div class="card shadow-sm">
            <div class="card-header bg-dark text-white d-flex justify-content-between align-items-center">
                <h6 class="mb-0">
                    <i class="bi bi-list"></i> الخطابات
                    <span class="badge bg-light text-dark">{{ $letters->total() }}</span>
                </h6>
                <a href="{{ route('letters.create') }}" class="btn btn-success btn-sm">
                    <i class="bi bi-plus"></i> خطاب جديد
                </a>
            </div>
            <div class="card-body p-0">
                @if($letters->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>رقم الصادر</th>
                                    <th>الموضوع</th>
                                    <th>المستلم</th>
                                    <th>التاريخ</th>
                                    <th>المُصدر</th>
                                    <th>الحالة</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($letters as $letter)
                                    <tr>
                                        <td>
                                            <span class="fw-bold text-primary">{{ $letter->reference_number }}</span>
                                        </td>
                                        <td>{{ Str::limit($letter->subject, 40) }}</td>
                                        <td>{{ $letter->recipient_name ?? '-' }}</td>
                                        <td>
                                            <small>{{ $letter->gregorian_date?->format('Y/m/d') }}</small>
                                            <br>
                                            <small class="text-muted">{{ $letter->hijri_date }}</small>
                                        </td>
                                        <td>{{ $letter->author->name }}</td>
                                        <td>
                                            @php
                                                $statusColors = [
                                                    'draft' => 'warning',
                                                    'issued' => 'info',
                                                    'sent' => 'success',
                                                    'archived' => 'secondary'
                                                ];
                                                $statusLabels = [
                                                    'draft' => 'مسودة',
                                                    'issued' => 'صادر',
                                                    'sent' => 'مُرسل',
                                                    'archived' => 'مؤرشف'
                                                ];
                                            @endphp
                                            <span class="badge bg-{{ $statusColors[$letter->status] ?? 'secondary' }}">
                                                {{ $statusLabels[$letter->status] ?? $letter->status }}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="{{ route('letters.show', $letter->id) }}" class="btn btn-outline-primary"
                                                    title="عرض">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <a href="{{ route('letters.pdf', $letter->id) }}" class="btn btn-outline-danger"
                                                    title="PDF" target="_blank">
                                                    <i class="bi bi-file-pdf"></i>
                                                </a>
                                                @if($letter->status === 'draft')
                                                    <a href="{{ route('letters.edit', $letter->id) }}" class="btn btn-outline-warning"
                                                        title="تعديل">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                @endif
                                            </div>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="card-footer">
                        {{ $letters->withQueryString()->links() }}
                    </div>
                @else
                    <div class="text-center py-5">
                        <i class="bi bi-inbox display-1 text-muted"></i>
                        <p class="text-muted mt-3">لا توجد خطابات</p>
                        <a href="{{ route('letters.create') }}" class="btn btn-primary">
                            <i class="bi bi-plus"></i> إنشاء خطاب جديد
                        </a>
                    </div>
                @endif
            </div>
        </div>
    </div>
@endsection