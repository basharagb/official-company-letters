@extends('layouts.template')
@section('title', 'إدارة القوالب')

@section('content')
    <div class="container">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h5 class="mb-0"><i class="bi bi-file-earmark-text"></i> قوالب الخطابات</h5>
                <a href="{{ route('templates.create') }}" class="btn btn-light btn-sm">
                    <i class="bi bi-plus-circle"></i> قالب جديد
                </a>
            </div>
            <div class="card-body p-0">
                @if($templates->count() > 0)
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>اسم القالب</th>
                                    <th>الفئة</th>
                                    <th>الحالة</th>
                                    <th>تاريخ الإنشاء</th>
                                    <th>الإجراءات</th>
                                </tr>
                            </thead>
                            <tbody>
                                @foreach($templates as $index => $template)
                                    <tr>
                                        <td>{{ $index + 1 }}</td>
                                        <td>
                                            <span class="fw-bold">{{ $template->name }}</span>
                                        </td>
                                        <td>{{ $template->category ?? 'عام' }}</td>
                                        <td>
                                            @if($template->is_active)
                                                <span class="badge bg-success">نشط</span>
                                            @else
                                                <span class="badge bg-secondary">غير نشط</span>
                                            @endif
                                        </td>
                                        <td>{{ $template->created_at->format('Y/m/d') }}</td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="{{ route('templates.edit', $template->id) }}"
                                                    class="btn btn-outline-primary" title="تعديل">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <form action="{{ route('templates.destroy', $template->id) }}" method="POST"
                                                    class="d-inline" onsubmit="return confirm('هل أنت متأكد من حذف هذا القالب؟')">
                                                    @csrf
                                                    @method('DELETE')
                                                    <button type="submit" class="btn btn-outline-danger" title="حذف">
                                                        <i class="bi bi-trash"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                @endforeach
                            </tbody>
                        </table>
                    </div>
                @else
                    <div class="text-center py-5">
                        <i class="bi bi-file-earmark-text display-1 text-muted"></i>
                        <p class="text-muted mt-3">لا توجد قوالب بعد</p>
                        <a href="{{ route('templates.create') }}" class="btn btn-primary">
                            <i class="bi bi-plus"></i> إنشاء قالب جديد
                        </a>
                    </div>
                @endif
            </div>
        </div>
    </div>
@endsection