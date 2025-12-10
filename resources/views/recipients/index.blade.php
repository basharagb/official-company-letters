@extends('layouts.template')
@section('title', 'إدارة المستلمين')

@section('content')
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0">
                <i class="bi bi-people text-primary"></i> إدارة المستلمين
            </h4>
            <a href="{{ route('recipients.create') }}" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> إضافة مستلم جديد
            </a>
        </div>

        @if(session('success'))
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                {{ session('success') }}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        @endif

        <!-- البحث -->
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <form method="GET" action="{{ route('recipients.index') }}" class="row g-3">
                    <div class="col-md-10">
                        <input type="text" class="form-control" name="search" value="{{ request('search') }}"
                            placeholder="البحث في المستلمين...">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> بحث
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- قائمة المستلمين -->
        <div class="card shadow-sm">
            <div class="card-header bg-light">
                <i class="bi bi-list-ul"></i> المستلمين ({{ $recipients->total() }})
            </div>
            <div class="card-body p-0">
                @if($recipients->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>اسم المستلم</th>
                                    <th>الصفة</th>
                                    <th>البريد الإلكتروني</th>
                                    <th>الهاتف</th>
                                    <th>الحالة</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($recipients as $recipient)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        <td>{{ $recipient->name }}</td>
                                        <td>{{ $recipient->title ?? '-' }}</td>
                                        <td>{{ $recipient->email ?? '-' }}</td>
                                        <td>{{ $recipient->phone ?? '-' }}</td>
                                        <td>
                                            @if($recipient->is_active)
                                                <span class="badge bg-success">نشط</span>
                                            @else
                                                <span class="badge bg-secondary">غير نشط</span>
                                            @endif
                                        </td>
                                        <td>
                                            <a href="{{ route('recipients.edit', $recipient->id) }}"
                                                class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <form action="{{ route('recipients.destroy', $recipient->id) }}" method="POST"
                                                class="d-inline" onsubmit="return confirm('هل أنت متأكد من حذف هذا المستلم؟')">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @else
                    <div class="text-center py-5">
                        <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
                        <p class="text-muted mt-3">لا يوجد مستلمين مسجلين</p>
                        <a href="{{ route('recipients.create') }}" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> إضافة مستلم جديد
                        </a>
                    </div>
                @endif
            </div>
            @if($recipients->hasPages())
                <div class="card-footer">
                    {{ $recipients->links() }}
                </div>
            @endif
        </div>
    </div>
@endsection