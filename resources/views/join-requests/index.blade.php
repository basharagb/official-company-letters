@extends('layouts.template')
@section('title', 'طلبات الانضمام')

@section('content')
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-primary">
                <i class="bi bi-person-plus"></i> طلبات الانضمام
            </h2>
        </div>

        @if(session('success'))
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle"></i> {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

        @if(session('error'))
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="bi bi-exclamation-circle"></i> {{ session('error') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

        <div class="card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>المستخدم</th>
                                <th>البريد الإلكتروني</th>
                                <th>الشركة</th>
                                <th>الحالة</th>
                                <th>تاريخ الطلب</th>
                                <th>إجراءات</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($requests as $request)
                                <tr>
                                    <td>{{ $request->id }}</td>
                                    <td>{{ $request->user->name }}</td>
                                    <td>{{ $request->user->email }}</td>
                                    <td>{{ $request->company->name }}</td>
                                    <td>
                                        @if($request->status == 'pending')
                                            <span class="badge bg-warning">معلق</span>
                                        @elseif($request->status == 'approved')
                                            <span class="badge bg-success">معتمد</span>
                                        @else
                                            <span class="badge bg-danger">مرفوض</span>
                                        @endif
                                    </td>
                                    <td>{{ $request->created_at->format('Y-m-d H:i') }}</td>
                                    <td>
                                        @if($request->status == 'pending')
                                            <form action="{{ route('join-requests.approve', $request) }}" method="POST"
                                                class="d-inline">
                                                @csrf
                                                <button type="submit" class="btn btn-success btn-sm" title="موافقة">
                                                    <i class="bi bi-check-lg"></i> موافقة
                                                </button>
                                            </form>
                                            <button type="button" class="btn btn-danger btn-sm" data-bs-toggle="modal"
                                                data-bs-target="#rejectModal{{ $request->id }}" title="رفض">
                                                <i class="bi bi-x-lg"></i> رفض
                                            </button>

                                            <!-- Modal للرفض -->
                                            <div class="modal fade" id="rejectModal{{ $request->id }}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <form action="{{ route('join-requests.reject', $request) }}" method="POST">
                                                            @csrf
                                                            <div class="modal-header">
                                                                <h5 class="modal-title">رفض طلب الانضمام</h5>
                                                                <button type="button" class="btn-close"
                                                                    data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="mb-3">
                                                                    <label class="form-label">سبب الرفض (اختياري)</label>
                                                                    <textarea class="form-control" name="rejection_reason"
                                                                        rows="3"></textarea>
                                                                </div>
                                                            </div>
                                                            <div class="modal-footer">
                                                                <button type="button" class="btn btn-secondary"
                                                                    data-bs-dismiss="modal">إلغاء</button>
                                                                <button type="submit" class="btn btn-danger">تأكيد الرفض</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        @else
                                            @if($request->approver)
                                                <small class="text-muted">بواسطة: {{ $request->approver->name }}</small>
                                            @endif
                                        @endif
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">لا توجد طلبات</td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="mt-4">
            {{ $requests->links() }}
        </div>
    </div>
@endsection