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
                                            <th>الإجراءات</th>
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
                                                <td>
                                                    <div class="btn-group btn-group-sm" role="group">
                                                        <button type="button" class="btn btn-outline-primary" onclick="viewUser({{ $user->id }})" title="عرض">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-outline-warning" onclick="editUser({{ $user->id }})" title="تعديل">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>
                                                        @if(!$user->is_super_admin && $user->id !== auth()->id())
                                                            <button type="button" class="btn btn-outline-danger" onclick="deleteUser({{ $user->id }}, '{{ $user->name }}')" title="حذف">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        @endif
                                                    </div>
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

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">تعديل المستخدم</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="editUserForm">
                    @csrf
                    @method('PUT')
                    <div class="modal-body">
                        <input type="hidden" id="edit_user_id">
                        <div class="mb-3">
                            <label class="form-label">الاسم</label>
                            <input type="text" class="form-control" id="edit_name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">البريد الإلكتروني</label>
                            <input type="email" class="form-control" id="edit_email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">رقم الهاتف</label>
                            <input type="text" class="form-control" id="edit_phone">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">الوظيفة</label>
                            <input type="text" class="form-control" id="edit_job_title">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">الدور</label>
                            <select class="form-select" id="edit_role">
                                <option value="user">مستخدم</option>
                                <option value="manager">مدير</option>
                                <option value="admin">أدمن</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">الحالة</label>
                            <select class="form-select" id="edit_status">
                                <option value="approved">معتمد</option>
                                <option value="pending">قيد الانتظار</option>
                                <option value="rejected">مرفوض</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">كلمة المرور الجديدة (اختياري)</label>
                            <input type="password" class="form-control" id="edit_password">
                            <small class="text-muted">اتركه فارغاً إذا كنت لا تريد تغيير كلمة المرور</small>
                        </div>
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input" id="edit_is_company_owner">
                            <label class="form-check-label" for="edit_is_company_owner">مالك الشركة</label>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">إلغاء</button>
                        <button type="submit" class="btn btn-primary">حفظ التغييرات</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View User Modal -->
    <div class="modal fade" id="viewUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">تفاصيل المستخدم</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="userDetailsContent">
                    <div class="text-center">
                        <div class="spinner-border" role="status">
                            <span class="visually-hidden">جاري التحميل...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@push('scripts')
<script>
function viewUser(userId) {
    const modal = new bootstrap.Modal(document.getElementById('viewUserModal'));
    modal.show();
    
    fetch(`/api/users/${userId}`, {
        headers: {
            'Authorization': 'Bearer ' + localStorage.getItem('token'),
            'Accept': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        const user = data.user;
        document.getElementById('userDetailsContent').innerHTML = `
            <div class="row">
                <div class="col-md-6">
                    <h6 class="text-muted">المعلومات الشخصية</h6>
                    <table class="table table-sm">
                        <tr><th>الاسم:</th><td>${user.name}</td></tr>
                        <tr><th>البريد:</th><td>${user.email}</td></tr>
                        <tr><th>الهاتف:</th><td>${user.phone || '-'}</td></tr>
                        <tr><th>الوظيفة:</th><td>${user.job_title || '-'}</td></tr>
                    </table>
                </div>
                <div class="col-md-6">
                    <h6 class="text-muted">معلومات الحساب</h6>
                    <table class="table table-sm">
                        <tr><th>الشركة:</th><td>${user.company?.name || '-'}</td></tr>
                        <tr><th>الدور:</th><td>${user.role}</td></tr>
                        <tr><th>الحالة:</th><td>${user.status}</td></tr>
                        <tr><th>التسجيل:</th><td>${user.created_at}</td></tr>
                    </table>
                </div>
            </div>
        `;
    })
    .catch(error => {
        document.getElementById('userDetailsContent').innerHTML = `
            <div class="alert alert-danger">حدث خطأ في تحميل البيانات</div>
        `;
    });
}

function editUser(userId) {
    fetch(`/api/users/${userId}`, {
        headers: {
            'Authorization': 'Bearer ' + localStorage.getItem('token'),
            'Accept': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        const user = data.user;
        document.getElementById('edit_user_id').value = user.id;
        document.getElementById('edit_name').value = user.name;
        document.getElementById('edit_email').value = user.email;
        document.getElementById('edit_phone').value = user.phone || '';
        document.getElementById('edit_job_title').value = user.job_title || '';
        document.getElementById('edit_role').value = user.role;
        document.getElementById('edit_status').value = user.status;
        document.getElementById('edit_is_company_owner').checked = user.is_company_owner;
        
        const modal = new bootstrap.Modal(document.getElementById('editUserModal'));
        modal.show();
    });
}

document.getElementById('editUserForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const userId = document.getElementById('edit_user_id').value;
    const formData = {
        name: document.getElementById('edit_name').value,
        email: document.getElementById('edit_email').value,
        phone: document.getElementById('edit_phone').value,
        job_title: document.getElementById('edit_job_title').value,
        role: document.getElementById('edit_role').value,
        status: document.getElementById('edit_status').value,
        is_company_owner: document.getElementById('edit_is_company_owner').checked
    };
    
    const password = document.getElementById('edit_password').value;
    if (password) {
        formData.password = password;
    }
    
    fetch(`/api/users/${userId}`, {
        method: 'PUT',
        headers: {
            'Authorization': 'Bearer ' + localStorage.getItem('token'),
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        body: JSON.stringify(formData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('تم تحديث المستخدم بنجاح');
            location.reload();
        } else {
            alert('حدث خطأ: ' + (data.message || 'خطأ غير معروف'));
        }
    })
    .catch(error => {
        alert('حدث خطأ في الاتصال');
    });
});

function deleteUser(userId, userName) {
    if (!confirm(`هل أنت متأكد من حذف المستخدم "${userName}"؟`)) {
        return;
    }
    
    fetch(`/api/users/${userId}`, {
        method: 'DELETE',
        headers: {
            'Authorization': 'Bearer ' + localStorage.getItem('token'),
            'Accept': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('تم حذف المستخدم بنجاح');
            location.reload();
        } else {
            alert('حدث خطأ: ' + (data.message || 'خطأ غير معروف'));
        }
    })
    .catch(error => {
        alert('حدث خطأ في الاتصال');
    });
}
</script>
@endpush
@endsection