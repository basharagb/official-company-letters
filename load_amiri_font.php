<?php
/**
 * Load Amiri Arabic font into dompdf
 */

require_once __DIR__ . '/vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

$fontDir = __DIR__ . '/vendor/dompdf/dompdf/lib/fonts/';

$options = new Options();
$options->set('fontDir', $fontDir);
$options->set('fontCache', $fontDir);
$options->set('isRemoteEnabled', true);
$options->set('defaultFont', 'Amiri');

$dompdf = new Dompdf($options);
$fontMetrics = $dompdf->getFontMetrics();

// Register Amiri font
$fontMetrics->registerFont(
    ['family' => 'Amiri', 'style' => 'normal', 'weight' => 'normal'],
    $fontDir . 'Amiri-Regular.ttf'
);

$fontMetrics->registerFont(
    ['family' => 'Amiri', 'style' => 'normal', 'weight' => 'bold'],
    $fontDir . 'Amiri-Bold.ttf'
);

$fontMetrics->saveFontFamilies();

echo "Amiri font registered successfully!\n";

// Test PDF generation
$html = '<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <style>
        body { font-family: Amiri, serif; direction: rtl; }
    </style>
</head>
<body>
    <h1>اختبار الخط العربي</h1>
    <p>هذا نص تجريبي باللغة العربية</p>
</body>
</html>';

$dompdf->loadHtml($html);
$dompdf->setPaper('A4');
$dompdf->render();

file_put_contents(__DIR__ . '/storage/test-arabic.pdf', $dompdf->output());
echo "Test PDF created at storage/test-arabic.pdf\n";
