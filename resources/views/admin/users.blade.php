@extends('layouts.template')
@section('title', 'جميع المستخدمين - لوحة الأدمن')

@section('content')
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-people-fill"></i> جميع المستخدمين في النظام
                        </h5>
                    </div>
                    <div class="card-body">
                        <form method="GET" action="{{ route('admin.users') }}" class="row g-3 mb-4">
                            <div class="col-md-3">
                                <label class="form-label">بحث</label>
                                <input type="text" name="search" class="form-control"
                                    placeholder="الاسم أو البريد الإلكتروني..." value="{{ request('search') }}">
                            </div>
                            <div class="col-md-3">
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
                            <div class="col-md-3">
                                <label class="form-label">الحالة</label>
                                <select name="status" class="form-select">
                                    <option value="">جميع الحالات</option>
                                    <option value="approved" {{ request('status') == 'approved' ? 'selected' : '' }}>معتمد
                                    </option>
                                    <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>قيد
                                        الانتظار</option>
                                    <option value="rejected" {{ request('status') == 'rejected' ? 'selected' : '' }}>مرفوض
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary me-2">
                                    <i class="bi bi-search"></i> بحث
                                </button>
                                <a href="{{ route('admin.users') }}" class="btn btn-secondary">
                                    <i class="bi bi-x-circle"></i> إعادة تعيين
                                </a>
                            </div>
                        </form>

                        @if($users->count() > 0)
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>الاسم</th>
                                            <th>البريد الإلكتروني</th>
                                            <th>الشركة</th>
                                            <th>الوظيفة</th>
                                            <th>الدور</th>
                                            <th>الحالة</th>
                                            <th>تاريخ التسجيل</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach($users as $user)
                                            <tr>
                                                <td>
                                                    <strong>{{ $user->name }}</strong>
                                                    @if($user->is_super_admin)
                                                        <span class="badge bg-danger ms-2">Super Admin</span>
                                                    @elseif($user->is_company_owner)
                                                        <span class="badge bg-warning ms-2">مالك الشركة</span>
                                                    @endif
                                                </td>
                                                <td>{{ $user->email }}</td>
                                                <td>
                                                    @if($user->company)
                                                        <span class="badge bg-info">{{ $user->company->name }}</span>
                                                    @else
                                                        <span class="text-muted">-</span>
                                                    @endif
                                                </td>
                                                <td>{{ $user->job_title ?? '-' }}</td>
                                                <td>
                                                    @if($user->role === 'admin')
                                                        <span class="badge bg-primary">أدمن</span>
                                                    @elseif($user->role === 'manager')
                                                        <span class="badge bg-success">مدير</span>
                                                    @else
                                                        <span class="badge bg-secondary">مستخدم</span>
                                                    @endif
                                                </td>
                                                <td>
                                                    @if($user->status === 'approved')
                                                        <span class="badge bg-success">معتمد</span>
                                                    @elseif($user->status === 'pending')
                                                        <span class="badge bg-warning">قيد الانتظار</span>
                                                    @else
                                                        <span class="badge bg-danger">مرفوض</span>
                                                    @endif
                                                </td>
                                                <td>
                                                    <small class="text-muted">
                                                        {{ $user->created_at->format('Y-m-d') }}
                                                    </small>
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>

                            <div class="mt-4">
                                {{ $users->links() }}
                            </div>
                        @else
                            <div class="alert alert-info text-center">
                                <i class="bi bi-info-circle"></i>
                                لا توجد مستخدمين مطابقين للبحث
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
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-primary">{{ $users->total() }}</h3>
                                    <small class="text-muted">إجمالي المستخدمين</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-success">{{ $users->where('status', 'approved')->count() }}</h3>
                                    <small class="text-muted">معتمدين</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-warning">{{ $users->where('status', 'pending')->count() }}</h3>
                                    <small class="text-muted">قيد الانتظار</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="p-3 bg-light rounded">
                                    <h3 class="text-info">{{ $users->where('is_company_owner', true)->count() }}</h3>
                                    <small class="text-muted">ملاك الشركات</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection