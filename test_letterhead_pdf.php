<?php
/**
 * Test PDF with letterhead and barcode in correct order
 */

require_once __DIR__ . '/vendor/autoload.php';

use Mpdf\Mpdf;
use Illuminate\Support\Str;

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

// Test barcode
$barcode = new \Milon\Barcode\DNS1D();
$barcodeImage = $barcode->getBarcodePNG('OUT-2025-00001', 'C128', 2, 40);

// Barcode position - test with 'right'
$barcodePosition = 'right';
$barcodeFloat = $barcodePosition === 'right' ? 'right' : 'left';
$barcodeAlign = $barcodePosition === 'right' ? 'right' : 'left';

$barcodeSectionHtml = '
<div class="barcode-info-section" style="float: ' . $barcodeFloat . '; text-align: ' . $barcodeAlign . '; width: 180px; padding: 10px; background: rgba(255,255,255,0.95); border: 1px solid #ddd; border-radius: 5px; margin-bottom: 20px;">
    <div style="margin-bottom: 5px;">
        <img src="data:image/png;base64,' . $barcodeImage . '" style="max-width: 160px;">
    </div>
    <div style="font-size: 12px; font-weight: bold; color: #333; margin-bottom: 3px;">OUT-2025-00001</div>
    <div style="font-size: 11px; color: #555; margin-bottom: 2px;">19 جمادى الآخرة 1447هـ</div>
    <div style="font-size: 11px; color: #555; margin-bottom: 3px;">2025/12/10</div>
    <div style="font-size: 10px; color: #0d6efd; font-weight: bold;">خطاب إبداء رغبة</div>
</div>';

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
        .company-name-en {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        .company-info {
            font-size: 12px;
            color: #666;
        }
        .recipient {
            margin-bottom: 20px;
            font-size: 14px;
        }
        .recipient-label {
            font-weight: bold;
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
        .signature-section {
            margin-top: 50px;
        }
        .signature-box {
            text-align: center;
            width: 50%;
            vertical-align: top;
        }
        .signature-name {
            font-weight: bold;
            border-top: 1px solid #333;
            padding-top: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="company-name">شركة الخطابات الرسمية</div>
        <div class="company-name-en">Official Letters Company</div>
        <div class="company-info">الرياض، المملكة العربية السعودية | هاتف: +966 11 123 4567 | info@letters.sa</div>
    </div>

    ' . $barcodeSectionHtml . '
    <div style="clear: both;"></div>

    <div class="recipient">
        <span class="recipient-label">إلى:</span>
        الأستاذ بندر مدير
        <br>شركة أرامكو
    </div>

    <div class="subject">
        <span class="subject-label">الموضوع:</span> خطاب إبداء رغبة
    </div>

    <div class="content">
        <p>السلام عليكم ورحمة الله وبركاته،</p>
        <p>أتشرف أنا/نحن (اسم رباعي / اسم الشركة) بأن نتقدم إلى جهتكم الموقرة بهذا الخطاب لإبداء رغبتنا في (مثال: التعاون معكم في مجال ... / التقدم لتنفيذ مشروع ... / التقدم لشغل وظيفة ... / الدخول في شراكة استراتيجية في مجال ...)، وذلك لما نراه من توافق بين احتياجاتكم وخبراتنا وإمكانياتنا.</p>
        <p>وتقبلوا فائق الاحترام والتقدير،،،</p>
    </div>

    <div class="signature-section">
        <table style="width: 100%;">
            <tr>
                <td class="signature-box">
                    <div class="signature-name">مدير النظام</div>
                    <div>مدير النظام</div>
                </td>
                <td class="signature-box">
                </td>
            </tr>
        </table>
    </div>
</body>
</html>';

$mpdf->WriteHTML($html);

$outputPath = __DIR__ . '/storage/test-letterhead-barcode.pdf';
$mpdf->Output($outputPath, 'F');

echo "PDF created successfully at: $outputPath\n";
echo "Opening PDF...\n";

exec("open '$outputPath'");
