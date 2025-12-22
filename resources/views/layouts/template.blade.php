<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'نظام الخطابات الرسمية')</title>

    <!-- Bootstrap RTL -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.rtl.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts - Arabic -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Cairo', sans-serif;
            background-color: #f4f6f9;
            overflow-x: hidden;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            right: 0;
            width: 260px;
            height: 100vh;
            background: linear-gradient(180deg, #1e3a5f 0%, #0d2137 100%);
            z-index: 1000;
            transition: all 0.3s ease;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h4 {
            color: #fff;
            font-size: 1.2rem;
            margin: 0;
        }

        .sidebar-header i {
            font-size: 2rem;
            color: #4dabf7;
            margin-bottom: 10px;
        }

        .sidebar-menu {
            padding: 15px 0;
        }

        .menu-label {
            color: rgba(255, 255, 255, 0.4);
            font-size: 0.75rem;
            padding: 10px 20px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .sidebar-menu .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            border-right: 3px solid transparent;
        }

        .sidebar-menu .nav-link:hover {
            color: #fff;
            background-color: rgba(255, 255, 255, 0.1);
            border-right-color: #4dabf7;
        }

        .sidebar-menu .nav-link.active {
            color: #fff;
            background-color: rgba(77, 171, 247, 0.2);
            border-right-color: #4dabf7;
        }

        .sidebar-menu .nav-link i {
            font-size: 1.2rem;
            margin-left: 12px;
            width: 24px;
        }

        .user-panel {
            padding: 15px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: auto;
        }

        .user-panel .user-info {
            display: flex;
            align-items: center;
            color: #fff;
        }

        .user-panel .user-avatar {
            width: 40px;
            height: 40px;
            background: #4dabf7;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-left: 12px;
        }

        .user-panel .user-name {
            font-size: 0.9rem;
            font-weight: 600;
        }

        .user-panel .user-role {
            font-size: 0.75rem;
            color: rgba(255, 255, 255, 0.5);
        }

        /* Main Content */
        .main-content {
            margin-right: 260px;
            min-height: 100vh;
            transition: all 0.3s ease;
        }

        /* Top Header */
        .top-header {
            background: #fff;
            padding: 15px 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .top-header .page-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e3a5f;
            margin: 0;
        }

        .top-header .header-actions .btn {
            margin-right: 10px;
        }

        /* Content Area */
        .content-area {
            padding: 25px;
        }

        .card {
            border: none;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border-radius: 10px;
        }

        .card-header {
            border-radius: 10px 10px 0 0 !important;
        }

        /* Mobile Toggle */
        .sidebar-toggle {
            display: none;
            position: fixed;
            bottom: 20px;
            left: 20px;
            width: 50px;
            height: 50px;
            background: #1e3a5f;
            color: #fff;
            border: none;
            border-radius: 50%;
            z-index: 1001;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
        }

        /* Responsive */
        @media (max-width: 991px) {
            .sidebar {
                transform: translateX(100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .main-content {
                margin-right: 0;
            }

            .sidebar-toggle {
                display: flex;
                align-items: center;
                justify-content: center;
            }
        }

        /* Logout Button */
        .logout-btn {
            background: rgba(220, 53, 69, 0.2);
            border: none;
            color: #dc3545;
            width: 100%;
            text-align: right;
            padding: 12px 20px;
            transition: all 0.3s;
        }

        .logout-btn:hover {
            background: rgba(220, 53, 69, 0.3);
            color: #fff;
        }

        /* Footer */
        .main-footer {
            background: #fff;
            padding: 15px 25px;
            text-align: center;
            color: #6c757d;
            font-size: 0.85rem;
            border-top: 1px solid #eee;
        }
    </style>
    @stack('styles')
</head>

<body>
    @auth
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <i class="bi bi-envelope-paper-fill"></i>
                <h4>نظام الخطابات</h4>
            </div>

            <nav class="sidebar-menu">
                <div class="menu-label">الرئيسية</div>
                <a class="nav-link {{ request()->routeIs('dashboard') ? 'active' : '' }}" href="{{ route('dashboard') }}">
                    <i class="bi bi-speedometer2"></i> لوحة التحكم
                </a>

                <div class="menu-label">الخطابات</div>
                <a class="nav-link {{ request()->routeIs('letters.create') ? 'active' : '' }}"
                    href="{{ route('letters.create') }}">
                    <i class="bi bi-plus-circle"></i> خطاب جديد
                </a>
                <a class="nav-link {{ request()->routeIs('letters.index') || request()->routeIs('letters.search') ? 'active' : '' }}"
                    href="{{ route('letters.index') }}">
                    <i class="bi bi-envelope"></i> جميع الخطابات
                </a>

                @if(Auth::user()->isSuperAdmin())
                    <div class="menu-label">إدارة النظام</div>
                    <a class="nav-link {{ request()->routeIs('admin.dashboard') ? 'active' : '' }}"
                        href="{{ route('admin.dashboard') }}">
                        <i class="bi bi-shield-check"></i> لوحة الأدمن
                    </a>
                    <a class="nav-link {{ request()->routeIs('admin.companies') || request()->routeIs('admin.company.details') ? 'active' : '' }}"
                        href="{{ route('admin.companies') }}">
                        <i class="bi bi-buildings"></i> الشركات المسجلة
                    </a>
                    <a class="nav-link {{ request()->routeIs('admin.letters') ? 'active' : '' }}"
                        href="{{ route('admin.letters') }}">
                        <i class="bi bi-envelope-open"></i> جميع الخطابات
                    </a>
                    <a class="nav-link {{ request()->routeIs('admin.users') ? 'active' : '' }}"
                        href="{{ route('admin.users') }}">
                        <i class="bi bi-people-fill"></i> جميع المستخدمين
                    </a>
                @endif

                <div class="menu-label">الإعدادات</div>
                <a class="nav-link {{ request()->routeIs('templates.*') ? 'active' : '' }}"
                    href="{{ route('templates.index') }}">
                    <i class="bi bi-file-earmark-text"></i> القوالب
                </a>
                <a class="nav-link {{ request()->routeIs('company.settings') ? 'active' : '' }}"
                    href="{{ route('company.settings') }}">
                    <i class="bi bi-building"></i> إعدادات الشركة
                </a>
                <a class="nav-link {{ request()->routeIs('company.letterhead') ? 'active' : '' }}"
                    href="{{ route('company.letterhead') }}">
                    <i class="bi bi-file-earmark-pdf"></i> الورق الرسمي
                </a>
                <a class="nav-link {{ request()->routeIs('subscriptions.*') ? 'active' : '' }}"
                    href="{{ route('subscriptions.index') }}">
                    <i class="bi bi-credit-card"></i> الاشتراكات
                </a>

                <div class="menu-label">البيانات المحفوظة</div>
                <a class="nav-link {{ request()->routeIs('recipients.*') ? 'active' : '' }}"
                    href="{{ route('recipients.index') }}">
                    <i class="bi bi-people"></i> المستلمين
                </a>
                <a class="nav-link {{ request()->routeIs('recipient-titles.*') ? 'active' : '' }}"
                    href="{{ route('recipient-titles.index') }}">
                    <i class="bi bi-person-badge"></i> صفات المستلمين
                </a>
                <a class="nav-link {{ request()->routeIs('organizations.*') ? 'active' : '' }}"
                    href="{{ route('organizations.index') }}">
                    <i class="bi bi-building"></i> الجهات
                </a>
                <a class="nav-link {{ request()->routeIs('letter-subjects.*') ? 'active' : '' }}"
                    href="{{ route('letter-subjects.index') }}">
                    <i class="bi bi-card-heading"></i> مواضيع الخطابات
                </a>
            </nav>

            <div class="user-panel">
                <div class="user-info mb-3">
                    <div class="user-avatar">
                        <i class="bi bi-person"></i>
                    </div>
                    <div>
                        <div class="user-name">{{ Auth::user()->name }}</div>
                        <div class="user-role">{{ Auth::user()->job_title ?? 'مستخدم' }}</div>
                    </div>
                </div>
                <form action="{{ route('logout') }}" method="POST">
                    @csrf
                    <button type="submit" class="logout-btn">
                        <i class="bi bi-box-arrow-right"></i> تسجيل الخروج
                    </button>
                </form>
            </div>
        </aside>

        <!-- Mobile Toggle -->
        <button class="sidebar-toggle" onclick="document.getElementById('sidebar').classList.toggle('show')">
            <i class="bi bi-list"></i>
        </button>

        <!-- Main Content -->
        <main class="main-content">
            <header class="top-header">
                <h1 class="page-title">@yield('title', 'لوحة التحكم')</h1>
                <div class="header-actions">
                    <a href="{{ route('letters.create') }}" class="btn btn-primary btn-sm">
                        <i class="bi bi-plus"></i> خطاب جديد
                    </a>
                </div>
            </header>

            <div class="content-area">
                @if(session('success'))
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle"></i> {{ session('success') }}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif

                @if(session('error'))
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-circle"></i> {{ session('error') }}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                @endif

                @yield('content')
            </div>

            <footer class="main-footer">
                © {{ date('Y') }} نظام إصدار الخطابات الرسمية - جميع الحقوق محفوظة
            </footer>
        </main>
    @else
        <!-- Guest Layout (No Sidebar) -->
        <nav class="navbar navbar-dark bg-dark">
            <div class="container">
                <a class="navbar-brand" href="{{ route('home') }}">
                    <i class="bi bi-envelope-paper"></i> نظام الخطابات
                </a>
                <a class="btn btn-outline-light btn-sm" href="{{ route('login') }}">
                    <i class="bi bi-box-arrow-in-right"></i> تسجيل الدخول
                </a>
            </div>
        </nav>
        <main style="min-height: calc(100vh - 120px);">
            @yield('content')
        </main>
        <footer class="bg-dark text-light py-3">
            <div class="container text-center">
                <small>© {{ date('Y') }} نظام إصدار الخطابات الرسمية - جميع الحقوق محفوظة</small>
            </div>
        </footer>
    @endauth

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    @stack('scripts')
</body>

</html>