@extends('layouts.template')
@section('title', 'تفاصيل الشركة')

@section('content')
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-building"></i> تفاصيل الشركة
            </h2>
            <a href="{{ route('admin.companies') }}" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-right"></i> رجوع
            </a>
        </div>

        <!-- معلومات الشركة الأساسية -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-info-circle"></i> المعلومات الأساسية</h5>
            </div>
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <strong>اسم الشركة (عربي):</strong>
                        <p class="text-muted">{{ $company->name }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>اسم الشركة (English):</strong>
                        <p class="text-muted">{{ $company->name_en ?? 'غير محدد' }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>البريد الإلكتروني:</strong>
                        <p class="text-muted">{{ $company->email }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>رقم الهاتف:</strong>
                        <p class="text-muted">{{ $company->phone ?? 'غير محدد' }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>العنوان:</strong>
                        <p class="text-muted">{{ $company->address ?? 'غير محدد' }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>الموقع الإلكتروني:</strong>
                        <p class="text-muted">
                            @if($company->website)
                                <a href="{{ $company->website }}" target="_blank">{{ $company->website }}</a>
                            @else
                                غير محدد
                            @endif
                        </p>
                    </div>
                    <div class="col-md-6">
                        <strong>السجل التجاري:</strong>
                        <p class="text-muted">{{ $company->commercial_register ?? 'غير محدد' }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>الرقم الضريبي:</strong>
                        <p class="text-muted">{{ $company->tax_number ?? 'غير محدد' }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>تاريخ التسجيل:</strong>
                        <p class="text-muted">{{ $company->created_at->format('Y-m-d H:i') }}</p>
                    </div>
                    <div class="col-md-6">
                        <strong>حالة الإعداد:</strong>
                        <p>
                            @if($company->setup_completed)
                                <span class="badge bg-success">مكتمل</span>
                            @else
                                <span class="badge bg-warning">غير مكتمل</span>
                            @endif
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- الاشتراك -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="bi bi-credit-card"></i> الاشتراك</h5>
            </div>
            <div class="card-body">
                @if($company->activeSubscription)
                    <div class="row g-3">
                        <div class="col-md-4">
                            <strong>نوع الاشتراك:</strong>
                            <p class="text-muted">{{ $company->activeSubscription->type }}</p>
                        </div>
                        <div class="col-md-4">
                            <strong>الحالة:</strong>
                            <p>
                                <span
                                    class="badge bg-{{ $company->activeSubscription->status == 'active' ? 'success' : 'warning' }}">
                                    {{ $company->activeSubscription->status == 'active' ? 'نشط' : 'غير نشط' }}
                                </span>
                            </p>
                        </div>
                        <div class="col-md-4">
                            <strong>تاريخ الانتهاء:</strong>
                            <p class="text-muted">
                                {{ $company->activeSubscription->end_date ? $company->activeSubscription->end_date->format('Y-m-d') : 'غير محدد' }}
                            </p>
                        </div>
                    </div>
                @else
                    <p class="text-muted">لا يوجد اشتراك نشط</p>
                @endif
            </div>
        </div>

        <!-- المستخدمين -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="bi bi-people"></i> المستخدمين ({{ $company->users->count() }})</h5>
            </div>
            <div class="card-body">
                @if($company->users->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>الاسم</th>
                                    <th>البريد الإلكتروني</th>
                                    <th>الوظيفة</th>
                                    <th>الصلاحية</th>
                                    <th>الحالة</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($company->users as $user)
                                    <tr>
                                        <td>{{ $user->name }}</td>
                                        <td>{{ $user->email }}</td>
                                        <td>{{ $user->job_title ?? 'غير محدد' }}</td>
                                        <td>
                                            @if($user->is_super_admin)
                                                <span class="badge bg-danger">Super Admin</span>
                                            @elseif($user->is_company_owner)
                                                <span class="badge bg-primary">مالك</span>
                                            @else
                                                <span class="badge bg-secondary">{{ $user->role }}</span>
                                            @endif
                                        </td>
                                        <td>
                                            <span class="badge bg-{{ $user->status == 'approved' ? 'success' : 'warning' }}">
                                                {{ $user->status }}
                                            </span>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @else
                    <p class="text-muted">لا يوجد مستخدمين</p>
                @endif
            </div>
        </div>

        <!-- الخطابات -->
        <div class="card shadow-sm mb-4">
            <div class="card-header bg-warning text-dark">
                <h5 class="mb-0"><i class="bi bi-envelope"></i> الخطابات ({{ $company->letters->count() }})</h5>
            </div>
            <div class="card-body">
                @if($company->letters->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>الرقم الصادر</th>
                                    <th>الموضوع</th>
                                    <th>الحالة</th>
                                    <th>التاريخ</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($company->letters->take(10) as $letter)
                                    <tr>
                                        <td>{{ $letter->reference_number }}</td>
                                        <td>{{ $letter->subject }}</td>
                                        <td>
                                            <span class="badge bg-{{ $letter->status == 'issued' ? 'success' : 'secondary' }}">
                                                {{ $letter->status }}
                                            </span>
                                        </td>
                                        <td>{{ $letter->created_at->format('Y-m-d') }}</td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                    @if($company->letters->count() > 10)
                        <p class="text-muted text-center mt-2">عرض أول 10 خطابات فقط</p>
                    @endif
                @else
                    <p class="text-muted">لا توجد خطابات</p>
                @endif
            </div>
        </div>

        <!-- أزرار الإجراءات -->
        <div class="d-flex gap-2">
            <a href="{{ route('admin.company.edit', $company) }}" class="btn btn-warning">
                <i class="bi bi-pencil"></i> تعديل
            </a>
            <form action="{{ route('admin.company.delete', $company) }}" method="POST" class="d-inline"
                onsubmit="return confirm('هل أنت متأكد من حذف هذه الشركة؟ سيتم حذف جميع البيانات المرتبطة بها.')">
                @csrf
                @method('DELETE')
                <button type="submit" class="btn btn-danger">
                    <i class="bi bi-trash"></i> حذف الشركة
                </button>
            </form>
        </div>
    </div>
@endsection