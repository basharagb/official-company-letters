<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <title>{{ $letter->subject }}</title>
    <style>
        * {
            font-family: 'Amiri', 'DejaVu Sans', sans-serif;
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        @page {
            margin: 0;
            padding: 0;
        }

        body {
            margin: 0;
            padding: 0;
            direction: rtl;
            line-height: 1.8;
            position: relative;
            width: 210mm;
            min-height: 297mm;
        }

        /* خلفية الورق الرسمي */
        .letterhead-background {
            position: fixed;
            top: 0;
            left: 0;
            width: 210mm;
            height: 297mm;
            z-index: -1;
        }

        .letterhead-background img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        /* منطقة الباركود والمعلومات */
        .barcode-section {
            position: absolute;
            top:
                {{ $company->barcode_top_margin ?? 20 }}
                mm;
            {{ ($company->barcode_position ?? 'right') == 'right' ? 'right' : 'left' }}
            :
                {{ $company->barcode_side_margin ?? 15 }}
                mm;
            width: 50mm;
            text-align: center;
            z-index: 10;
        }

        .barcode-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        .barcode-image {
            width: 100%;
            max-width: 45mm;
            height: auto;
        }

        .reference-number {
            font-size: 11px;
            font-weight: bold;
            color: #333;
            margin-top: 5px;
        }

        .date-hijri {
            font-size: 10px;
            color: #555;
            margin-top: 3px;
        }

        .date-gregorian {
            font-size: 10px;
            color: #555;
        }

        .subject-text {
            font-size: 9px;
            color: #0d6efd;
            margin-top: 5px;
            font-weight: bold;
            word-wrap: break-word;
        }

        /* محتوى الخطاب */
        .letter-content {
            padding: 80mm 25mm 30mm 25mm;
            min-height: 200mm;
        }

        .recipient {
            margin-bottom: 15px;
            font-size: 14px;
        }

        .recipient-label {
            font-weight: bold;
        }

        .subject-line {
            margin-bottom: 20px;
            padding: 8px 12px;
            background-color: rgba(233, 236, 239, 0.8);
            border-right: 4px solid #0d6efd;
            font-size: 14px;
        }

        .subject-label {
            font-weight: bold;
            color: #0d6efd;
        }

        .content-body {
            text-align: justify;
            font-size: 14px;
            line-height: 2;
        }

        .content-body p {
            margin-bottom: 10px;
        }

        /* قسم التوقيع */
        .signature-section {
            margin-top: 40px;
            page-break-inside: avoid;
        }

        .signature-table {
            width: 100%;
        }

        .signature-box {
            text-align: center;
            width: 50%;
            vertical-align: top;
        }

        .signature-image {
            max-height: 50px;
            margin-bottom: 8px;
        }

        .stamp-image {
            max-height: 70px;
        }

        .signature-name {
            font-weight: bold;
            border-top: 1px solid #333;
            padding-top: 5px;
            font-size: 12px;
        }

        .signature-title {
            font-size: 11px;
            color: #666;
        }
    </style>
</head>

<body>
    {{-- خلفية الورق الرسمي --}}
    @if($company->letterhead_file)
        <div class="letterhead-background">
            @php
                $letterheadPath = storage_path('app/public/' . $company->letterhead_file);
                $extension = pathinfo($company->letterhead_file, PATHINFO_EXTENSION);
            @endphp
            @if(strtolower($extension) !== 'pdf')
                <img src="{{ $letterheadPath }}" alt="الورق الرسمي">
            @endif
        </div>
    @endif

    {{-- منطقة الباركود والمعلومات --}}
    <div class="barcode-section">
        <div class="barcode-container">
            {{-- الباركود --}}
            @if($company->show_barcode ?? true)
                <div class="barcode-wrapper">
                    @php
                        $barcodeValue = $letter->reference_number ?? 'N/A';
                        $barcode = new \Milon\Barcode\DNS1D();
                        $barcodeImage = $barcode->getBarcodePNG($barcodeValue, 'C128', 2, 40);
                    @endphp
                    <img src="data:image/png;base64,{{ $barcodeImage }}" class="barcode-image" alt="باركود">
                </div>
            @endif

            {{-- الرقم الصادر --}}
            @if($company->show_reference_number ?? true)
                <div class="reference-number">{{ $letter->reference_number }}</div>
            @endif

            {{-- التاريخ الهجري --}}
            @if($company->show_hijri_date ?? true)
                <div class="date-hijri">{{ $letter->hijri_date }}</div>
            @endif

            {{-- التاريخ الميلادي --}}
            @if($company->show_gregorian_date ?? true)
                <div class="date-gregorian">{{ $letter->gregorian_date?->format('Y/m/d') }}</div>
            @endif

            {{-- الموضوع --}}
            @if($company->show_subject_in_header ?? true)
                <div class="subject-text">{{ Str::limit($letter->subject, 50) }}</div>
            @endif
        </div>
    </div>

    {{-- محتوى الخطاب --}}
    <div class="letter-content">
        {{-- المستلم --}}
        @if($letter->recipient_name || $letter->recipient_organization)
            <div class="recipient">
                <span class="recipient-label">إلى:</span>
                {{ $letter->recipient_title }} {{ $letter->recipient_name }}
                @if($letter->recipient_organization)
                    <br>{{ $letter->recipient_organization }}
                @endif
            </div>
        @endif

        {{-- الموضوع --}}
        <div class="subject-line">
            <span class="subject-label">الموضوع:</span> {{ $letter->subject }}
        </div>

        {{-- المحتوى --}}
        <div class="content-body">
            <p>السلام عليكم ورحمة الله وبركاته،</p>
            {!! nl2br(e($letter->content)) !!}
            <p>وتقبلوا فائق الاحترام والتقدير،،،</p>
        </div>

        {{-- التوقيع --}}
        <div class="signature-section">
            <table class="signature-table">
                <tr>
                    <td class="signature-box">
                        @if($company->signature)
                            <img src="{{ storage_path('app/public/' . $company->signature) }}" class="signature-image"
                                alt="التوقيع">
                        @endif
                        <div class="signature-name">{{ $letter->author->name ?? '' }}</div>
                        <div class="signature-title">{{ $letter->author->job_title ?? 'الموظف المسؤول' }}</div>
                    </td>
                    <td class="signature-box">
                        @if($company->stamp)
                            <img src="{{ storage_path('app/public/' . $company->stamp) }}" class="stamp-image" alt="الختم">
                        @endif
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>

</html>