<?php
/**
 * Script to install Arabic font (Amiri) in dompdf
 */

require_once __DIR__ . '/vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

$fontDir = __DIR__ . '/storage/fonts/';

// Initialize dompdf
$options = new Options();
$options->set('fontDir', $fontDir);
$options->set('fontCache', $fontDir);
$options->set('isRemoteEnabled', true);

$dompdf = new Dompdf($options);

// Get the font metrics
$fontMetrics = $dompdf->getFontMetrics();

// Install Amiri font
$fontFamily = 'Amiri';
$normalFont = $fontDir . 'Amiri-Regular.ttf';
$boldFont = $fontDir . 'Amiri-Bold.ttf';

// Register font family
try {
    $fontMetrics->registerFont(
        ['family' => $fontFamily, 'style' => 'normal', 'weight' => 'normal'],
        $normalFont
    );
    echo "Registered Amiri Regular\n";
    
    $fontMetrics->registerFont(
        ['family' => $fontFamily, 'style' => 'normal', 'weight' => 'bold'],
        $boldFont
    );
    echo "Registered Amiri Bold\n";
    
    // Save font cache
    $fontMetrics->saveFontFamilies();
    echo "Font families saved!\n";
    
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}

echo "Done!\n";
