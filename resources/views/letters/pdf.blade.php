<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <title>{{ $letter->subject }}</title>
    <style>
        * {
            font-family: 'Amiri', 'DejaVu Sans', sans-serif;
        }
        
        body {
            margin: 0;
            padding: 40px;
            direction: rtl;
            line-height: 1.8;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
        }
        
        .logo {
            max-height: 80px;
            margin-bottom: 10px;
        }
        
        .company-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        
        .company-info {
            font-size: 12px;
            color: #666;
        }
        
        .letter-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            padding: 15px;
            background-color: #f5f5f5;
            border-radius: 5px;
        }
        
        .letter-info-item {
            text-align: center;
        }
        
        .letter-info-label {
            font-size: 12px;
            color: #666;
        }
        
        .letter-info-value {
            font-size: 14px;
            font-weight: bold;
            color: #333;
        }
        
        .recipient {
            margin-bottom: 20px;
        }
        
        .recipient-label {
            font-weight: bold;
        }
        
        .subject {
            margin-bottom: 20px;
            padding: 10px;
            background-color: #e9ecef;
            border-right: 4px solid #0d6efd;
        }
        
        .subject-label {
            font-weight: bold;
            color: #0d6efd;
        }
        
        .content {
            text-align: justify;
            margin-bottom: 40px;
            min-height: 300px;
        }
        
        .footer {
            margin-top: 50px;
        }
        
        .signature-section {
            display: flex;
            justify-content: space-between;
            margin-top: 40px;
        }
        
        .signature-box {
            text-align: center;
            width: 200px;
        }
        
        .signature-image {
            max-height: 60px;
            margin-bottom: 10px;
        }
        
        .stamp-image {
            max-height: 80px;
        }
        
        .signature-name {
            font-weight: bold;
            border-top: 1px solid #333;
            padding-top: 5px;
        }
        
        .page-footer {
            position: fixed;
            bottom: 20px;
            left: 40px;
            right: 40px;
            text-align: center;
            font-size: 10px;
            color: #999;
            border-top: 1px solid #ddd;
            padding-top: 10px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        @if($letter->company->logo)
        <img src="{{ storage_path('app/public/' . $letter->company->logo) }}" class="logo" alt="شعار الشركة">
        @endif
        <div class="company-name">{{ $letter->company->name }}</div>
        @if($letter->company->name_en)
        <div class="company-info">{{ $letter->company->name_en }}</div>
        @endif
        <div class="company-info">
            @if($letter->company->address){{ $letter->company->address }} | @endif
            @if($letter->company->phone)هاتف: {{ $letter->company->phone }} | @endif
            @if($letter->company->email){{ $letter->company->email }}@endif
        </div>
    </div>

    <!-- Letter Info -->
    <table style="width: 100%; margin-bottom: 30px; background-color: #f5f5f5; padding: 10px;">
        <tr>
            <td style="text-align: center; width: 33%;">
                <div class="letter-info-label">رقم الصادر</div>
                <div class="letter-info-value">{{ $letter->reference_number }}</div>
            </td>
            <td style="text-align: center; width: 33%;">
                <div class="letter-info-label">التاريخ الميلادي</div>
                <div class="letter-info-value">{{ $letter->gregorian_date?->format('Y/m/d') }}</div>
            </td>
            <td style="text-align: center; width: 33%;">
                <div class="letter-info-label">التاريخ الهجري</div>
                <div class="letter-info-value">{{ $letter->hijri_date }}</div>
            </td>
        </tr>
    </table>

    <!-- Recipient -->
    @if($letter->recipient_name || $letter->recipient_organization)
    <div class="recipient">
        <span class="recipient-label">إلى:</span>
        {{ $letter->recipient_title }} {{ $letter->recipient_name }}
        @if($letter->recipient_organization)
        <br>{{ $letter->recipient_organization }}
        @endif
    </div>
    @endif

    <!-- Subject -->
    <div class="subject">
        <span class="subject-label">الموضوع:</span> {{ $letter->subject }}
    </div>

    <!-- Content -->
    <div class="content">
        <p>السلام عليكم ورحمة الله وبركاته،</p>
        {!! nl2br(e($letter->content)) !!}
        <p>وتقبلوا فائق الاحترام والتقدير،،،</p>
    </div>

    <!-- Signature Section -->
    <div class="footer">
        <table style="width: 100%;">
            <tr>
                <td style="text-align: center; width: 50%;">
                    @if($letter->company->signature)
                    <img src="{{ storage_path('app/public/' . $letter->company->signature) }}" 
                         class="signature-image" alt="التوقيع">
                    @endif
                    <div class="signature-name">{{ $letter->author->name }}</div>
                    <div>{{ $letter->author->job_title ?? 'الموظف المسؤول' }}</div>
                </td>
                <td style="text-align: center; width: 50%;">
                    @if($letter->company->stamp)
                    <img src="{{ storage_path('app/public/' . $letter->company->stamp) }}" 
                         class="stamp-image" alt="الختم">
                    @endif
                </td>
            </tr>
        </table>
    </div>

    <!-- Page Footer -->
    <div class="page-footer">
        @if($letter->company->commercial_register)
        سجل تجاري: {{ $letter->company->commercial_register }} |
        @endif
        @if($letter->company->tax_number)
        الرقم الضريبي: {{ $letter->company->tax_number }} |
        @endif
        @if($letter->company->website)
        {{ $letter->company->website }}
        @endif
    </div>
</body>
</html>
