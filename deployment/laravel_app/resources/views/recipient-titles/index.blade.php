@extends('layouts.template')
@section('title', 'إدارة صفات المستلمين')

@section('content')
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4 class="mb-0">
                <i class="bi bi-person-badge text-primary"></i> إدارة صفات المستلمين
            </h4>
            <a href="{{ route('recipient-titles.create') }}" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> إضافة صفة جديدة
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
                <form method="GET" action="{{ route('recipient-titles.index') }}" class="row g-3">
                    <div class="col-md-10">
                        <input type="text" class="form-control" name="search" value="{{ request('search') }}"
                            placeholder="البحث في صفات المستلمين...">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> بحث
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- قائمة الصفات -->
        <div class="card shadow-sm">
            <div class="card-header bg-light">
                <i class="bi bi-list-ul"></i> صفات المستلمين ({{ $titles->total() }})
            </div>
            <div class="card-body p-0">
                @if($titles->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>الصفة</th>
                                    <th>الحالة</th>
                                    <th>تاريخ الإنشاء</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($titles as $title)
                                    <tr>
                                        <td>{{ $loop->iteration }}</td>
                                        <td>{{ $title->title }}</td>
                                        <td>
                                            @if($title->is_active)
                                                <span class="badge bg-success">نشط</span>
                                            @else
                                                <span class="badge bg-secondary">غير نشط</span>
                                            @endif
                                        </td>
                                        <td>{{ $title->created_at->format('Y-m-d') }}</td>
                                        <td>
                                            <a href="{{ route('recipient-titles.edit', $title->id) }}"
                                                class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <form action="{{ route('recipient-titles.destroy', $title->id) }}" method="POST"
                                                class="d-inline" onsubmit="return confirm('هل أنت متأكد من حذف هذه الصفة؟')">
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
                        <p class="text-muted mt-3">لا توجد صفات مسجلة</p>
                        <a href="{{ route('recipient-titles.create') }}" class="btn btn-primary">
                            <i class="bi bi-plus-circle"></i> إضافة صفة جديدة
                        </a>
                    </div>
                @endif
            </div>
            @if($titles->hasPages())
                <div class="card-footer">
                    {{ $titles->links() }}
                </div>
            @endif
        </div>
    </div>
@endsection