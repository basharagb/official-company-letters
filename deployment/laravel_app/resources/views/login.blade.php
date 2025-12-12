@extends('layouts.template')
@section('title', 'تسجيل الدخول')

@section('content')
    <div class="container">
        <div class="row justify-content-center mt-5">
            <div class="col-md-5">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white text-center">
                        <h4 class="mb-0">
                            <i class="bi bi-box-arrow-in-right"></i> تسجيل الدخول
                        </h4>
                    </div>
                    <div class="card-body p-4">
                        @if (session('success'))
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle"></i> {{ session('success') }}
                            </div>
                        @endif

                        @if ($errors->any())
                            @foreach ($errors->all() as $error)
                                <div class="alert alert-danger">
                                    <i class="bi bi-exclamation-circle"></i> {{ $error }}
                                </div>
                            @endforeach
                        @endif

                        <form method="POST" action="{{ route('login.post') }}">
                            @csrf

                            <div class="mb-3">
                                <label class="form-label" for="email">
                                    <i class="bi bi-envelope"></i> البريد الإلكتروني
                                </label>
                                <input class="form-control form-control-lg" type="email" name="email" id="email" required
                                    placeholder="admin@letters.sa">
                            </div>

                            <div class="mb-3">
                                <label class="form-label" for="password">
                                    <i class="bi bi-lock"></i> كلمة المرور
                                </label>
                                <input class="form-control form-control-lg" type="password" name="password" id="password"
                                    required placeholder="••••••">
                            </div>

                            <div class="mb-3 form-check">
                                <input class="form-check-input" type="checkbox" name="remember" id="remember">
                                <label class="form-check-label" for="remember">تذكرني</label>
                            </div>

                            <div class="d-grid">
                                <button class="btn btn-primary btn-lg" type="submit">
                                    <i class="bi bi-box-arrow-in-right"></i> دخول
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection