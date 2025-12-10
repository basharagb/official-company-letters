<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ $letter->subject }} - خطاب رسمي</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.rtl.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Cairo', sans-serif;
            background-color: #f8f9fa;
        }

        .letter-container {
            max-width: 800px;
            margin: 40px auto;
            background: #fff;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            overflow: hidden;
        }

        .letter-header {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            color: #fff;
            padding: 30px;
            text-align: center;
        }

        .company-logo {
            max-height: 80px;
            margin-bottom: 15px;
        }

        .letter-body {
            padding: 40px;
        }

        .letter-info {
            display: flex;
            justify-content: space-between;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
        }

        .info-item {
            text-align: center;
        }

        .info-label {
            font-size: 12px;
            color: #666;
        }

        .info-value {
            font-weight: bold;
            color: #333;
        }

        .letter-subject {
            background: #e9ecef;
            padding: 15px;
            border-right: 4px solid #0d6efd;
            margin-bottom: 30px;
        }

        .letter-content {
            line-height: 2;
            text-align: justify;
        }

        .letter-footer {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid #ddd;
        }

        .signature-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .signature-box {
            text-align: center;
        }

        .signature-img {
            max-height: 60px;
            margin-bottom: 10px;
        }

        .stamp-img {
            max-height: 80px;
        }

        .download-section {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="letter-container">
            <!-- Header -->
            <div class="letter-header">
                @if($letter->company->logo)
                    <img src="{{ asset('storage/' . $letter->company->logo) }}" class="company-logo" alt="شعار الشركة">
                @endif
                <h2 class="mb-0">{{ $letter->company->name }}</h2>
                @if($letter->company->name_en)
                    <p class="mb-0">{{ $letter->company->name_en }}</p>
                @endif
            </div>

            <!-- Body -->
            <div class="letter-body">
                <!-- Info -->
                <div class="letter-info">
                    <div class="info-item">
                        <div class="info-label">رقم الصادر</div>
                        <div class="info-value">{{ $letter->reference_number }}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">التاريخ الميلادي</div>
                        <div class="info-value">{{ $letter->gregorian_date?->format('Y/m/d') }}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">التاريخ الهجري</div>
                        <div class="info-value">{{ $letter->hijri_date }}</div>
                    </div>
                </div>

                <!-- Recipient -->
                @if($letter->recipient_name || $letter->recipient_organization)
                    <p class="mb-3">
                        <strong>إلى:</strong>
                        {{ $letter->recipient_title }} {{ $letter->recipient_name }}
                        @if($letter->recipient_organization)
                            <br>{{ $letter->recipient_organization }}
                        @endif
                    </p>
                @endif

                <!-- Subject -->
                <div class="letter-subject">
                    <strong><i class="bi bi-card-heading"></i> الموضوع:</strong>
                    {{ $letter->subject }}
                </div>

                <!-- Content -->
                <div class="letter-content">
                    <p>السلام عليكم ورحمة الله وبركاته،</p>
                    {!! nl2br(e($letter->content)) !!}
                    <p class="mt-4">وتقبلوا فائق الاحترام والتقدير،،،</p>
                </div>

                <!-- Footer -->
                <div class="letter-footer">
                    <div class="signature-section">
                        <div class="signature-box">
                            @if($letter->company->signature)
                                <img src="{{ asset('storage/' . $letter->company->signature) }}" class="signature-img"
                                    alt="التوقيع">
                            @endif
                            <div class="border-top pt-2">
                                <strong>{{ $letter->author->name }}</strong>
                                <br>
                                <small>{{ $letter->author->job_title ?? 'الموظف المسؤول' }}</small>
                            </div>
                        </div>
                        <div class="signature-box">
                            @if($letter->company->stamp)
                                <img src="{{ asset('storage/' . $letter->company->stamp) }}" class="stamp-img" alt="الختم">
                            @endif
                        </div>
                    </div>
                </div>
            </div>

            <!-- Download Section -->
            <div class="download-section">
                <p class="text-muted mb-2">هذا الخطاب مُشارك عبر نظام إصدار الخطابات الرسمية</p>
                <a href="{{ route('letters.pdf', $letter->id) }}" class="btn btn-primary" target="_blank">
                    <i class="bi bi-file-pdf"></i> تحميل نسخة PDF
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>