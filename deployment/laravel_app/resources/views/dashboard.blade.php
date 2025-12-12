@extends('layouts.template')
@section('title', 'لوحة التحكم')

@section('content')
    <div class="container">
        <!-- الترحيب -->
        <div class="row mb-4">
            <div class="col-12">
                <h4 class="text-primary">
                    <i class="bi bi-speedometer2"></i>
                    مرحباً، {{ Auth::user()->name }}
                </h4>
                <p class="text-muted">{{ Auth::user()->company?->name ?? 'لم يتم تحديد الشركة' }}</p>
            </div>
        </div>

        <!-- الإحصائيات -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card bg-primary text-white h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-envelope display-4"></i>
                        <h2 class="mt-2">{{ $stats['total'] ?? 0 }}</h2>
                        <p class="mb-0">إجمالي الخطابات</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-warning text-dark h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-pencil-square display-4"></i>
                        <h2 class="mt-2">{{ $stats['draft'] ?? 0 }}</h2>
                        <p class="mb-0">مسودات</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-info text-white h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-check-circle display-4"></i>
                        <h2 class="mt-2">{{ $stats['issued'] ?? 0 }}</h2>
                        <p class="mb-0">صادرة</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card bg-success text-white h-100">
                    <div class="card-body text-center">
                        <i class="bi bi-send display-4"></i>
                        <h2 class="mt-2">{{ $stats['sent'] ?? 0 }}</h2>
                        <p class="mb-0">مُرسلة</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- الإجراءات السريعة -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h6 class="mb-0"><i class="bi bi-lightning"></i> إجراءات سريعة</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="{{ route('letters.create') }}" class="btn btn-primary">
                                <i class="bi bi-plus-circle"></i> خطاب جديد
                            </a>
                            <a href="{{ route('letters.index') }}" class="btn btn-outline-primary">
                                <i class="bi bi-search"></i> البحث في الخطابات
                            </a>
                            <a href="{{ route('templates.index') }}" class="btn btn-outline-secondary">
                                <i class="bi bi-file-earmark-text"></i> إدارة القوالب
                            </a>
                            <a href="{{ route('company.settings') }}" class="btn btn-outline-info">
                                <i class="bi bi-building"></i> إعدادات الشركة
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- آخر الخطابات -->
            <div class="col-lg-8 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h6 class="mb-0"><i class="bi bi-clock-history"></i> آخر الخطابات</h6>
                        <a href="{{ route('letters.index') }}" class="btn btn-light btn-sm">عرض الكل</a>
                    </div>
                    <div class="card-body p-0">
                        @if(isset($recentLetters) && $recentLetters->count() > 0)
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>رقم الصادر</th>
                                            <th>الموضوع</th>
                                            <th>التاريخ</th>
                                            <th>الحالة</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach($recentLetters as $letter)
                                            <tr>
                                                <td><span class="fw-bold text-primary">{{ $letter->reference_number }}</span></td>
                                                <td>{{ Str::limit($letter->subject, 30) }}</td>
                                                <td><small>{{ $letter->gregorian_date?->format('Y/m/d') }}</small></td>
                                                <td>
                                                    @php
                                                        $colors = ['draft' => 'warning', 'issued' => 'info', 'sent' => 'success'];
                                                        $labels = ['draft' => 'مسودة', 'issued' => 'صادر', 'sent' => 'مُرسل'];
                                                    @endphp
                                                    <span class="badge bg-{{ $colors[$letter->status] ?? 'secondary' }}">
                                                        {{ $labels[$letter->status] ?? $letter->status }}
                                                    </span>
                                                </td>
                                                <td>
                                                    <a href="{{ route('letters.show', $letter->id) }}"
                                                        class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        @endforeach
                                    </tbody>
                                </table>
                            </div>
                        @else
                            <div class="text-center py-5">
                                <i class="bi bi-inbox display-1 text-muted"></i>
                                <p class="text-muted mt-3">لا توجد خطابات بعد</p>
                                <a href="{{ route('letters.create') }}" class="btn btn-primary">
                                    <i class="bi bi-plus"></i> إنشاء أول خطاب
                                </a>
                            </div>
                        @endif
                    </div>
                </div>
            </div>

            <!-- خطاباتي -->
            <div class="col-lg-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header bg-success text-white">
                        <h6 class="mb-0"><i class="bi bi-person"></i> خطاباتي</h6>
                    </div>
                    <div class="card-body p-0">
                        @if(isset($myLetters) && $myLetters->count() > 0)
                            <ul class="list-group list-group-flush">
                                @foreach($myLetters as $letter)
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <small class="text-primary fw-bold">{{ $letter->reference_number }}</small>
                                            <br>
                                            <small>{{ Str::limit($letter->subject, 25) }}</small>
                                        </div>
                                        <a href="{{ route('letters.show', $letter->id) }}" class="btn btn-sm btn-outline-success">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </li>
                                @endforeach
                            </ul>
                        @else
                            <div class="text-center py-4">
                                <p class="text-muted mb-0">لم تنشئ أي خطابات بعد</p>
                            </div>
                        @endif
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection