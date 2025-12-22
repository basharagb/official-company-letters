@extends('layouts.template')
@section('title', 'جميع الخطابات - لوحة الأدمن')

@section('content')
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-envelope-open"></i> جميع الخطابات من جميع الشركات
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="GET" action="{{ route('admin.letters') }}" class="row g-3 mb-4">
                            <div class="col-md-4">
                                <label class="form-label">بحث</label>
                                <input type="text" name="search" class="form-control" placeholder="رقم الصادر أو الموضوع..."
                                    value="{{ request('search') }}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">الشركة</label>
                                <select name="company_id" class="form-select">
                                    <option value="">جميع الشركات</option>
                                    @foreach($companies as $company)
                                        <option value="{{ $company->id }}" {{ request('company_id') == $company->id ? 'selected' : '' }}>
                                            {{ $company->name }}
                                        </option>
                                    @endforeach
                                </select>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="bi bi-search"></i> بحث
                                </button>
                                <a href="{{ route('admin.letters') }}" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> إعادة تعيين
                                </a>
                            </div>
                        </form>

                        @if($letters->count() > 0)
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>رقم الصادر</th>
                                            <th>الموضوع</th>
                                            <th>الشركة</th>
                                            <th>الكاتب</th>
                                            <th>التاريخ</th>
                                            <th>الحالة</th>
                                            <th>الإجراءات</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach($letters as $letter)
                                            <tr>
                                                <td>
                                                    <strong class="text-primary">{{ $letter->reference_number }}</strong>
                                                </td>
                                                <td>{{ Str::limit($letter->subject, 50) }}</td>
                                                <td>
                                                    <span class="badge bg-info">
                                                        {{ $letter->company->name ?? 'غير محدد' }}
                                                    </span>
                                                </td>
                                                <td>{{ $letter->author->name ?? 'غير محدد' }}</td>
                                                <td>
                                                    <small class="text-muted">
                                                        {{ $letter->created_at->format('Y-m-d') }}
                                                    </small>
                                                </td>
                                                <td>
                                                    @if($letter->status === 'issued')
                                                        <span class="badge bg-success">صادر</span>
                                                    @else
                                                        <span class="badge bg-warning">مسودة</span>
                                                    @endif
                                                </td>
                                                <td>
                                                    <a href="{{ route('letters.show', $letter->id) }}"
                                                        class="btn btn-sm btn-primary" title="عرض">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                    @if($letter->status === 'issued')
                                                        <a href="{{ route('letters.pdf', $letter->id) }}" class="btn btn-sm btn-danger"
                                                            target="_blank" title="تحميل PDF">
                                                            <i class="bi bi-file-pdf"></i>
                                                        </a>
                                                    @endif
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>

                            <div class="mt-4">
                                {{ $letters->links() }}
                            </div>
                        @else
                            <div class="alert alert-info text-center">
                                <i class="bi bi-info-circle"></i>
                                لا توجد خطابات مطابقة للبحث
                            </div>
                        @endif
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-body">
                        <h6 class="text-muted">
                            <i class="bi bi-info-circle"></i> إحصائيات سريعة
                        </h6>
                        <div class="row text-center mt-3">
                            <div class="col-md-4">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-primary">{{ $letters->total() }}</h3>
                                    <small class="text-muted">إجمالي الخطابات</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-success">{{ $letters->where('status', 'issued')->count() }}</h3>
                                    <small class="text-muted">خطابات صادرة</small>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-warning">{{ $letters->where('status', 'draft')->count() }}</h3>
                                    <small class="text-muted">مسودات</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection