@extends('layouts.template')
@section('title', 'الاشتراكات')

@section('content')
    <div class="container">
        <!-- الاشتراك الحالي -->
        @if($currentSubscription)
            <div class="card shadow-sm mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="bi bi-check-circle"></i> اشتراكك الحالي</h5>
                </div>
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col-md-4 text-center border-end">
                            <h3 class="text-success mb-0">
                                @if($currentSubscription->type == 'once')
                                    اشتراك لمرة واحدة
                                @elseif($currentSubscription->type == 'monthly')
                                    اشتراك شهري
                                @else
                                    اشتراك سنوي
                                @endif
                            </h3>
                            <span class="badge bg-{{ $currentSubscription->isValid() ? 'success' : 'danger' }} mt-2">
                                {{ $currentSubscription->isValid() ? 'نشط' : 'منتهي' }}
                            </span>
                        </div>
                        <div class="col-md-4 text-center">
                            @if($currentSubscription->type == 'once')
                                <p class="mb-1">الخطابات المستخدمة</p>
                                <h4>{{ $currentSubscription->letters_used }} / {{ $currentSubscription->letters_limit }}</h4>
                                <div class="progress" style="height: 10px;">
                                    <div class="progress-bar"
                                        style="width: {{ ($currentSubscription->letters_used / $currentSubscription->letters_limit) * 100 }}%">
                                    </div>
                                </div>
                            @else
                                <p class="mb-1">تاريخ الانتهاء</p>
                                <h4>{{ $currentSubscription->end_date->format('Y/m/d') }}</h4>
                                <small class="text-muted">متبقي {{ $currentSubscription->end_date->diffInDays(now()) }} يوم</small>
                            @endif
                        </div>
                        <div class="col-md-4 text-center">
                            <p class="mb-1">تاريخ البدء</p>
                            <h4>{{ $currentSubscription->start_date->format('Y/m/d') }}</h4>
                        </div>
                    </div>
                </div>
            </div>
        @endif

        <!-- خطط الاشتراك -->
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="bi bi-credit-card"></i> خطط الاشتراك</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <!-- اشتراك لمرة واحدة -->
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 border-primary">
                            <div class="card-header bg-primary text-white text-center">
                                <h5 class="mb-0">اشتراك لمرة واحدة</h5>
                            </div>
                            <div class="card-body text-center">
                                <h2 class="text-primary mb-3">199 <small>ر.س</small></h2>
                                <ul class="list-unstyled">
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> 100 خطاب</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> جميع المزايا</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> دعم فني</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> بدون تجديد تلقائي</li>
                                </ul>
                            </div>
                            <div class="card-footer bg-transparent text-center">
                                <form action="{{ route('subscriptions.subscribe') }}" method="POST">
                                    @csrf
                                    <input type="hidden" name="type" value="once">
                                    <button type="submit" class="btn btn-primary w-100">اشترك الآن</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- اشتراك شهري -->
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 border-success">
                            <div class="card-header bg-success text-white text-center position-relative">
                                <span class="badge bg-warning position-absolute top-0 start-50 translate-middle">الأكثر
                                    شيوعاً</span>
                                <h5 class="mb-0 mt-2">اشتراك شهري</h5>
                            </div>
                            <div class="card-body text-center">
                                <h2 class="text-success mb-3">99 <small>ر.س/شهر</small></h2>
                                <ul class="list-unstyled">
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> خطابات غير محدودة</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> جميع المزايا</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> دعم فني متميز</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> إلغاء في أي وقت</li>
                                </ul>
                            </div>
                            <div class="card-footer bg-transparent text-center">
                                <form action="{{ route('subscriptions.subscribe') }}" method="POST">
                                    @csrf
                                    <input type="hidden" name="type" value="monthly">
                                    <button type="submit" class="btn btn-success w-100">اشترك الآن</button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- اشتراك سنوي -->
                    <div class="col-md-4 mb-4">
                        <div class="card h-100 border-warning">
                            <div class="card-header bg-warning text-dark text-center">
                                <h5 class="mb-0">اشتراك سنوي</h5>
                                <small>وفر 20%</small>
                            </div>
                            <div class="card-body text-center">
                                <h2 class="text-warning mb-3">949 <small>ر.س/سنة</small></h2>
                                <ul class="list-unstyled">
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> خطابات غير محدودة</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> جميع المزايا</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> دعم فني VIP</li>
                                    <li class="mb-2"><i class="bi bi-check-circle text-success"></i> توفير شهرين</li>
                                </ul>
                            </div>
                            <div class="card-footer bg-transparent text-center">
                                <form action="{{ route('subscriptions.subscribe') }}" method="POST">
                                    @csrf
                                    <input type="hidden" name="type" value="yearly">
                                    <button type="submit" class="btn btn-warning w-100">اشترك الآن</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- سجل الاشتراكات -->
        @if(isset($subscriptionHistory) && $subscriptionHistory->count() > 0)
            <div class="card shadow-sm mt-4">
                <div class="card-header bg-secondary text-white">
                    <h6 class="mb-0"><i class="bi bi-clock-history"></i> سجل الاشتراكات</h6>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>النوع</th>
                                <th>تاريخ البدء</th>
                                <th>تاريخ الانتهاء</th>
                                <th>المبلغ</th>
                                <th>الحالة</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($subscriptionHistory as $sub)
                                <tr>
                                    <td>
                                        @if($sub->type == 'once') لمرة واحدة
                                        @elseif($sub->type == 'monthly') شهري
                                        @else سنوي @endif
                                    </td>
                                    <td>{{ $sub->start_date->format('Y/m/d') }}</td>
                                    <td>{{ $sub->end_date?->format('Y/m/d') ?? '-' }}</td>
                                    <td>{{ number_format($sub->price, 2) }} ر.س</td>
                                    <td>
                                        <span class="badge bg-{{ $sub->status == 'active' ? 'success' : 'secondary' }}">
                                            {{ $sub->status == 'active' ? 'نشط' : 'منتهي' }}
                                        </span>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                </div>
            </div>
        @endif
    </div>
@endsection