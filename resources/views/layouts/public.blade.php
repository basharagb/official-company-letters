<!DOCTYPE html>
<html lang="en" dir="ltr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>@yield('title', 'Official Letters')</title>

    <!-- Bootstrap LTR -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            direction: ltr;
            text-align: left;
        }

        .public-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
        }

        .public-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .public-header {
            background: linear-gradient(135deg, #1e3a5f 0%, #0d2137 100%);
            color: #fff;
            padding: 30px;
            text-align: center;
        }

        .public-header h1 {
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
        }

        .public-header .app-name {
            font-size: 0.9rem;
            opacity: 0.8;
            margin-top: 8px;
        }

        .public-body {
            padding: 40px;
        }

        .section {
            margin-bottom: 35px;
        }

        .section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            color: #1e3a5f;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #667eea;
        }

        .section p,
        .section li {
            color: #495057;
            line-height: 1.7;
            text-align: left;
        }

        .section ul {
            padding-left: 20px;
        }

        .section li {
            margin-bottom: 8px;
        }

        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            border-radius: 0 8px 8px 0;
            margin-bottom: 20px;
        }

        .info-box p {
            margin: 0;
            color: #1e3a5f;
        }

        .contact-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }

        .contact-card p {
            margin-bottom: 8px;
        }

        .contact-card p:last-child {
            margin-bottom: 0;
        }

        .last-updated {
            color: #6c757d;
            font-size: 0.85rem;
            text-align: center;
            margin-bottom: 25px;
        }

        .public-footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #6c757d;
            font-size: 0.85rem;
            border-top: 1px solid #e9ecef;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .feature-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .feature-item i {
            color: #28a745;
            font-size: 1.1rem;
        }

        .allowed-prohibited {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .allowed-box,
        .prohibited-box {
            border-radius: 10px;
            overflow: hidden;
        }

        .allowed-box {
            border: 1px solid #28a745;
        }

        .prohibited-box {
            border: 1px solid #dc3545;
        }

        .allowed-box .box-header {
            background: #28a745;
            color: #fff;
            padding: 12px 15px;
            font-weight: 600;
        }

        .prohibited-box .box-header {
            background: #dc3545;
            color: #fff;
            padding: 12px 15px;
            font-weight: 600;
        }

        .box-content {
            padding: 15px;
        }

        .box-content li {
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .warning-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px 20px;
            border-radius: 0 8px 8px 0;
        }

        .permission-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .permission-card {
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }

        .permission-card i {
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .permission-card h6 {
            font-weight: 600;
            margin-bottom: 8px;
        }

        .permission-card p {
            font-size: 0.85rem;
            margin: 0;
        }

        .permission-card.camera {
            border-color: #17a2b8;
        }

        .permission-card.camera i {
            color: #17a2b8;
        }

        .permission-card.photos {
            border-color: #28a745;
        }

        .permission-card.photos i {
            color: #28a745;
        }

        .permission-card.notifications {
            border-color: #ffc107;
        }

        .permission-card.notifications i {
            color: #ffc107;
        }

        .permission-card.files {
            border-color: #6c757d;
        }

        .permission-card.files i {
            color: #6c757d;
        }

        @media (max-width: 576px) {
            .public-container {
                padding: 20px 15px;
            }

            .public-body {
                padding: 25px 20px;
            }

            .public-header {
                padding: 25px 20px;
            }

            .public-header h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>

<body>
    <div class="public-container">
        <div class="public-card">
            <div class="public-header">
                <h1>@yield('title')</h1>
                <div class="app-name">Official Letters App</div>
            </div>

            <div class="public-body">
                @yield('content')
            </div>

            <div class="public-footer">
                © {{ date('Y') }} Official Letters - All Rights Reserved
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>