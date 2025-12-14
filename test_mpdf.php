<?php
/**
 * Test mPDF Arabic support
 */

require_once __DIR__ . '/vendor/autoload.php';

use Mpdf\Mpdf;

// Create temp directory
@mkdir(__DIR__ . '/storage/app/mpdf', 0755, true);

$mpdf = new Mpdf([
    'mode' => 'utf-8',
    'format' => 'A4',
    'default_font_size' => 14,
    'default_font' => 'xbriyaz',
    'margin_left' => 15,
    'margin_right' => 15,
    'margin_top' => 16,
    'margin_bottom' => 16,
    'tempDir' => __DIR__ . '/storage/app/mpdf',
]);

$mpdf->SetDirectionality('rtl');
$mpdf->autoScriptToLang = true;
$mpdf->autoLangToFont = true;

$html = '
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: xbriyaz, sans-serif;
            direction: rtl;
            text-align: right;
            line-height: 1.8;
            padding: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #333;
            padding-bottom: 20px;
        }
        .company-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
        .letter-info {
            margin-bottom: 30px;
            padding: 15px;
            background-color: #f5f5f5;
        }
        .letter-info table {
            width: 100%;
        }
        .letter-info td {
            text-align: center;
            padding: 10px;
        }
        .subject {
            margin-bottom: 20px;
            padding: 10px 15px;
            background-color: #e9ecef;
            border-right: 4px solid #0d6efd;
        }
        .subject-label {
            font-weight: bold;
            color: #0d6efd;
        }
        .content {
            text-align: justify;
            font-size: 14px;
            line-height: 2;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="company-name">شركة الخطابات الرسمية</div>
        <div>Official Letters Company</div>
        <div>الرياض، المملكة العربية السعودية | هاتف: +966 11 123 4567 | info@letters.sa</div>
    </div>

    <div class="letter-info">
        <table>
            <tr>
                <td>
                    <div>التاريخ الهجري</div>
                    <div><strong>19 جمادى الآخرة 1447هـ</strong></div>
                </td>
                <td>
                    <div>التاريخ الميلادي</div>
                    <div><strong>2025/12/10</strong></div>
                </td>
                <td>
                    <div>رقم الصادر</div>
                    <div><strong>OUT-2025-00001</strong></div>
                </td>
            </tr>
        </table>
    </div>

    <div class="recipient">
        <strong>إلى:</strong> الأستاذ بندر مدير شركة أرامكو
    </div>

    <div class="subject">
        <span class="subject-label">الموضوع:</span> خطاب إبداء رغبة
    </div>

    <div class="content">
        <p>السلام عليكم ورحمة الله وبركاته،</p>
        <p>أتشرف أنا/نحن (اسم رباعي / اسم الشركة) بأن نتقدم إلى جهتكم الموقرة بهذا الخطاب لإبداء رغبتنا في (مثال: التعاون معكم في مجال ... / التقدم لتنفيذ مشروع ... / التقدم لشغل وظيفة ... / الدخول في شراكة استراتيجية في مجال ...)، وذلك لما نراه من توافق بين احتياجاتكم وخبراتنا وإمكانياتنا.</p>
        <p>وتقبلوا فائق الاحترام والتقدير،،،</p>
    </div>

    <div style="margin-top: 50px; text-align: center;">
        <div style="border-top: 1px solid #333; width: 200px; margin: 0 auto; padding-top: 10px;">
            <strong>مدير النظام</strong>
        </div>
    </div>
</body>
</html>';

$mpdf->WriteHTML($html);

$outputPath = __DIR__ . '/storage/test-mpdf-arabic.pdf';
$mpdf->Output($outputPath, 'F');

echo "PDF created successfully at: $outputPath\n";
echo "Opening PDF...\n";

// Open the PDF
exec("open '$outputPath'");
