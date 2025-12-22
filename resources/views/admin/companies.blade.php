@extends('layouts.template')
@section('title', 'إدارة الشركات')

@section('content')
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-building"></i> جميع الشركات المسجلة
            </h2>
            <a href="{{ route('admin.dashboard') }}" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-right"></i> رجوع
            </a>
        </div>

        <!-- البحث -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form action="" method="GET" class="row g-3">
                    <div class="col-md-10">
                        <input type="text" class="form-control" name="search" value="{{ request('search') }}"
                            placeholder="ابحث عن شركة...">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> بحث
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- قائمة الشركات -->
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>اسم الشركة</th>
                                <th>البريد الإلكتروني</th>
                                <th>المستخدمين</th>
                                <th>الاشتراك</th>
                                <th>تاريخ التسجيل</th>
                                <th>إجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($companies as $company)
                                <tr>
                                    <td>{{ $company->id }}</td>
                                    <td>
                                        <strong>{{ $company->name }}</strong>
                                        @if($company->name_en)
                                            <br><small class="text-muted">{{ $company->name_en }}</small>
                                        @endif
                                    </td>
                                    <td>{{ $company->email }}</td>
                                    <td>
                                        <span class="badge bg-primary">{{ $company->users->count() }}</span>
                                    </td>
                                    <td>
                                        @if($company->subscription)
                                            <span
                                                class="badge bg-{{ $company->subscription->status == 'active' ? 'success' : 'warning' }}">
                                                {{ $company->subscription->type }}
                                            </span>
                                        @else
                                            <span class="badge bg-secondary">لا يوجد</span>
                                        @endif
                                    </td>
                                    <td>{{ $company->created_at->format('Y-m-d') }}</td>
                                    <td>
                                        <a href="{{ route('admin.company.details', $company) }}" class="btn btn-info btn-sm"
                                            title="عرض">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="{{ route('admin.company.edit', $company) }}" class="btn btn-warning btn-sm"
                                            title="تعديل">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form action="{{ route('admin.company.delete', $company) }}" method="POST"
                                            class="d-inline"
                                            onsubmit="return confirm('هل أنت متأكد من حذف هذه الشركة؟ سيتم حذف جميع البيانات المرتبطة بها.')">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-danger btn-sm" title="حذف">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">لا توجد شركات</td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- الترقيم -->
        <div class="mt-4">
            {{ $companies->links() }}
        </div>
    </div>
@endsection