<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Tahoma', 'Arial', sans-serif;
            direction: rtl;
            text-align: right;
            line-height: 1.8;
            color: #333;
            background-color: #f5f5f5;
            padding: 20px;
        }

        .email-container {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background-color: #0d6efd;
            color: #fff;
            padding: 20px;
            text-align: center;
        }

        .header h1 {
            margin: 0;
            font-size: 24px;
        }

        .content {
            padding: 30px;
        }

        .letter-info {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }

        .letter-info p {
            margin: 5px 0;
        }

        .letter-info strong {
            color: #0d6efd;
        }

        .custom-message {
            background-color: #e7f3ff;
            border-right: 4px solid #0d6efd;
            padding: 15px;
            margin: 20px 0;
        }

        .footer {
            background-color: #f8f9fa;
            padding: 20px;
            text-align: center;
            font-size: 12px;
            color: #666;
        }

        .btn {
            display: inline-block;
            background-color: #0d6efd;
            color: #fff;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 15px;
        }
    </style>
</head>

<body>
    <div class="email-container">
        <div class="header">
            <h1>{{ $letter->company->name }}</h1>
        </div>

        <div class="content">
            <p>السلام عليكم ورحمة الله وبركاته،</p>

            <p>مرفق لكم خطاب رسمي من {{ $letter->company->name }}.</p>

            <div class="letter-info">
                <p><strong>الموضوع:</strong> {{ $letter->subject }}</p>
                <p><strong>رقم الصادر:</strong> {{ $letter->reference_number }}</p>
                <p><strong>التاريخ:</strong> {{ $letter->gregorian_date?->format('Y/m/d') }} - {{ $letter->hijri_date }}
                </p>
            </div>

            @if($customMessage)
                <div class="custom-message">
                    <strong>رسالة إضافية:</strong>
                    <p>{{ $customMessage }}</p>
                </div>
            @endif

            <p>يرجى الاطلاع على الملف المرفق للخطاب الرسمي بصيغة PDF.</p>

            <p>مع فائق الاحترام والتقدير،</p>
            <p><strong>{{ $letter->author->name }}</strong></p>
        </div>

        <div class="footer">
            <p>هذا البريد مُرسل من نظام إصدار الخطابات الرسمية</p>
            @if($letter->company->website)
                <p>{{ $letter->company->website }}</p>
            @endif
        </div>
    </div>
</body>

</html>