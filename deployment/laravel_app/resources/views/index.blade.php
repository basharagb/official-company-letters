@extends('layouts.template')
@section('title', 'نظام إصدار الخطابات الرسمية')

@section('content')
  <div class="container">
    <div class="px-4 py-5 my-5 text-center">
      <div class="mb-4">
        <i class="bi bi-envelope-paper display-1 text-primary"></i>
      </div>
      <h1 class="display-4 fw-bold text-primary mb-3">نظام إصدار الخطابات الرسمية</h1>
      <div class="col-lg-8 mx-auto">
        <p class="lead mb-4 text-muted">
          منصة إلكترونية متكاملة تساعد الشركات على إنشاء الخطابات الرسمية بسرعة وبشكل احترافي،
          مع أرشفة كاملة ونظام بحث وإرسال مباشر للخطابات.
        </p>

        @auth
          <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
            <a href="{{ route('dashboard') }}" class="btn btn-primary btn-lg px-5">
              <i class="bi bi-speedometer2"></i> لوحة التحكم
            </a>
          </div>
        @else
          <div class="d-grid gap-2 d-sm-flex justify-content-sm-center">
            <a class="btn btn-primary btn-lg px-5" href="{{ route('login') }}">
              <i class="bi bi-box-arrow-in-right"></i> تسجيل الدخول
            </a>
          </div>
        @endauth
      </div>

      <!-- المميزات -->
      <div class="row mt-5 g-4">
        <div class="col-md-4">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-hash display-4 text-primary"></i>
              <h5 class="mt-3">ترقيم تلقائي</h5>
              <p class="text-muted">رقم صادر فريد تلقائي لكل خطاب</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-calendar3 display-4 text-success"></i>
              <h5 class="mt-3">تاريخ هجري/ميلادي</h5>
              <p class="text-muted">إدراج التاريخ تلقائياً عند الإنشاء</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-search display-4 text-info"></i>
              <h5 class="mt-3">بحث ذكي</h5>
              <p class="text-muted">البحث بالرقم، العنوان، التاريخ، المحتوى</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-file-pdf display-4 text-danger"></i>
              <h5 class="mt-3">تصدير PDF</h5>
              <p class="text-muted">تصدير وحفظ الخطابات بصيغة PDF</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-share display-4 text-warning"></i>
              <h5 class="mt-3">مشاركة متعددة</h5>
              <p class="text-muted">إيميل، واتساب، تيليجرام، رابط</p>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card h-100 border-0 shadow-sm">
            <div class="card-body text-center">
              <i class="bi bi-archive display-4 text-secondary"></i>
              <h5 class="mt-3">أرشفة متكاملة</h5>
              <p class="text-muted">حفظ جميع الخطابات بشكل منظم</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
@endsection