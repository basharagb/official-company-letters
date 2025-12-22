@extends('layouts.template')
@section('title', 'إعدادات الحساب')

@section('content')
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <h2 class="mb-4"><i class="bi bi-gear"></i> إعدادات الحساب</h2>

                <!-- تعديل البيانات الشخصية -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-person"></i> البيانات الشخصية</h5>
                    </div>
                    <div class="card-body">
                        <form action="{{ route('user.update-profile') }}" method="POST">
                            @csrf
                            @method('PUT')
                            <div class="mb-3">
                                <label class="form-label">الاسم</label>
                                <input type="text" class="form-control" name="name" value="{{ auth()->user()->name }}"
                                    required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">البريد الإلكتروني</label>
                                <input type="email" class="form-control" name="email" value="{{ auth()->user()->email }}"
                                    required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">رقم الهاتف</label>
                                <input type="text" class="form-control" name="phone" value="{{ auth()->user()->phone }}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">الوظيفة</label>
                                <input type="text" class="form-control" name="job_title"
                                    value="{{ auth()->user()->job_title }}">
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check-circle"></i> حفظ التغييرات
                            </button>
                        </form>
                    </div>
                </div>

                <!-- تغيير كلمة المرور -->
                <div class="card shadow-sm mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="bi bi-lock"></i> تغيير كلمة المرور</h5>
                    </div>
                    <div class="card-body">
                        <form action="{{ route('user.change-password') }}" method="POST">
                            @csrf
                            @method('PUT')
                            <div class="mb-3">
                                <label class="form-label">كلمة المرور الحالية</label>
                                <input type="password" class="form-control" name="current_password" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">كلمة المرور الجديدة</label>
                                <input type="password" class="form-control" name="new_password" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">تأكيد كلمة المرور الجديدة</label>
                                <input type="password" class="form-control" name="new_password_confirmation" required>
                            </div>
                            <button type="submit" class="btn btn-info">
                                <i class="bi bi-key"></i> تغيير كلمة المرور
                            </button>
                        </form>
                    </div>
                </div>

                <!-- حذف الحساب -->
                <div class="card shadow-sm border-danger">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="bi bi-exclamation-triangle"></i> منطقة الخطر</h5>
                    </div>
                    <div class="card-body">
                        <h6 class="text-danger">حذف الحساب نهائياً</h6>
                        <p class="text-muted">
                            <i class="bi bi-info-circle"></i>
                            تحذير: حذف الحساب عملية لا يمكن التراجع عنها. سيتم حذف جميع بياناتك بشكل نهائي.
                        </p>
                        <button type="button" class="btn btn-danger" data-bs-toggle="modal"
                            data-bs-target="#deleteAccountModal">
                            <i class="bi bi-trash"></i> حذف الحساب نهائياً
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal تأكيد حذف الحساب -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">تأكيد حذف الحساب</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="{{ route('user.delete-account') }}" method="POST">
                    @csrf
                    @method('DELETE')
                    <div class="modal-body">
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <strong>تحذير!</strong> هذه العملية لا يمكن التراجع عنها.
                        </div>
                        <p>سيتم حذف:</p>
                        <ul>
                            <li>جميع بياناتك الشخصية</li>
                            <li>جميع الخطابات التي أنشأتها</li>
                            <li>جميع الإعدادات والتفضيلات</li>
                        </ul>
                        <div class="mb-3">
                            <label class="form-label">للتأكيد، اكتب كلمة المرور الخاصة بك:</label>
                            <input type="password" class="form-control" name="password" required placeholder="كلمة المرور">
                        </div>
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="confirmDelete" required>
                            <label class="form-check-label" for="confirmDelete">
                                أفهم أن هذه العملية لا يمكن التراجع عنها
                            </label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-trash"></i> حذف الحساب نهائياً
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection