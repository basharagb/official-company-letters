<?php

namespace App\Services;

use App\Models\Letter;
use App\Models\Company;
use Illuminate\Support\Str;
use Mpdf\Mpdf;
use Mpdf\Config\ConfigVariables;
use Mpdf\Config\FontVariables;

class PdfService
{
    protected Mpdf $mpdf;
    protected bool $hasLetterhead = false;

    public function __construct()
    {
        $defaultConfig = (new ConfigVariables())->getDefaults();
        $fontDirs = $defaultConfig['fontDir'];

        $defaultFontConfig = (new FontVariables())->getDefaults();
        $fontData = $defaultFontConfig['fontdata'];

        $this->mpdf = new Mpdf([
            'mode' => 'utf-8',
            'format' => 'A4',
            'default_font_size' => 12,
            'default_font' => 'xbriyaz',
            'margin_left' => 15,
            'margin_right' => 15,
            'margin_top' => 16,
            'margin_bottom' => 16,
            'margin_header' => 9,
            'margin_footer' => 9,
            'tempDir' => storage_path('app/mpdf'),
            'fontDir' => array_merge($fontDirs, [
                storage_path('fonts'),
            ]),
            'fontdata' => $fontData + [
                'amiri' => [
                    'R' => 'Amiri-Regular.ttf',
                    'B' => 'Amiri-Bold.ttf',
                    'useOTL' => 0xFF,
                    'useKashida' => 75,
                ],
            ],
        ]);

        $this->mpdf->SetDirectionality('rtl');
        $this->mpdf->autoScriptToLang = true;
        $this->mpdf->autoLangToFont = true;
    }

    /**
     * Set letterhead background from PDF or image
     */
    protected function setLetterheadBackground(Company $company): void
    {
        if (!$company->letterhead_file) {
            return;
        }

        $letterheadPath = storage_path('app/public/' . $company->letterhead_file);
        
        if (!file_exists($letterheadPath)) {
            return;
        }

        $extension = strtolower(pathinfo($letterheadPath, PATHINFO_EXTENSION));
        
        if ($extension === 'pdf') {
            // Import PDF as background
            $this->mpdf->SetImportUse();
            $pageCount = $this->mpdf->SetSourceFile($letterheadPath);
            $tplId = $this->mpdf->ImportPage(1);
            $this->mpdf->UseTemplate($tplId);
            $this->hasLetterhead = true;
        } elseif (in_array($extension, ['jpg', 'jpeg', 'png', 'gif'])) {
            // Use image as background
            $this->mpdf->SetDefaultBodyCSS('background', "url('$letterheadPath')");
            $this->mpdf->SetDefaultBodyCSS('background-image-resize', 6);
            $this->hasLetterhead = true;
        }
    }

    public function generateLetterPdf(Letter $letter): string
    {
        $letter->load(['author', 'company']);
        $company = $letter->company;

        // Set letterhead background if available
        $this->setLetterheadBackground($company);

        $html = $this->buildLetterHtml($letter, $company);
        
        $this->mpdf->WriteHTML($html);
        
        return $this->mpdf->Output('', 'S');
    }

    public function downloadLetterPdf(Letter $letter): void
    {
        $letter->load(['author', 'company']);
        $company = $letter->company;

        $html = $this->buildLetterHtml($letter, $company);
        
        $this->mpdf->WriteHTML($html);
        
        $this->mpdf->Output("letter-{$letter->reference_number}.pdf", 'D');
    }

    protected function buildLetterHtml(Letter $letter, Company $company): string
    {
        $logoPath = $company->logo ? storage_path('app/public/' . $company->logo) : null;
        $signaturePath = $company->signature ? storage_path('app/public/' . $company->signature) : null;
        $stampPath = $company->stamp ? storage_path('app/public/' . $company->stamp) : null;

        $logoHtml = $logoPath && file_exists($logoPath) 
            ? '<img src="' . $logoPath . '" style="max-height: 80px; margin-bottom: 10px;">' 
            : '';

        $signatureHtml = $signaturePath && file_exists($signaturePath)
            ? '<img src="' . $signaturePath . '" style="max-height: 60px; margin-bottom: 10px;">'
            : '';

        $stampHtml = $stampPath && file_exists($stampPath)
            ? '<img src="' . $stampPath . '" style="max-height: 80px;">'
            : '';

        // Barcode position (right or left)
        $barcodePosition = $company->barcode_position ?? 'right';
        $barcodeAlign = $barcodePosition === 'right' ? 'right' : 'left';
        $barcodeFloat = $barcodePosition === 'right' ? 'right' : 'left';

        // Generate barcode section with proper order:
        // 1. Barcode
        // 2. Reference Number
        // 3. Hijri Date
        // 4. Gregorian Date  
        // 5. Subject
        $barcodeSectionHtml = '';
        $barcode = new \Milon\Barcode\DNS1D();
        $barcodeImage = $barcode->getBarcodePNG($letter->reference_number ?? 'N/A', 'C128', 2, 40);
        
        $gregorianDateFormatted = '';
        if ($letter->gregorian_date) {
            $gregorianDateFormatted = $letter->gregorian_date instanceof \Carbon\Carbon 
                ? $letter->gregorian_date->format('Y/m/d')
                : $letter->gregorian_date;
        }

        $barcodeSectionHtml = '
        <div class="barcode-info-section" style="float: ' . $barcodeFloat . '; text-align: ' . $barcodeAlign . '; width: 180px; padding: 10px; background: rgba(255,255,255,0.9); border: 1px solid #ddd; border-radius: 5px; margin-bottom: 20px;">
            <div style="margin-bottom: 5px;">
                <img src="data:image/png;base64,' . $barcodeImage . '" style="max-width: 160px;">
            </div>
            <div style="font-size: 12px; font-weight: bold; color: #333; margin-bottom: 3px;">' . e($letter->reference_number) . '</div>
            <div style="font-size: 11px; color: #555; margin-bottom: 2px;">' . e($letter->hijri_date) . '</div>
            <div style="font-size: 11px; color: #555; margin-bottom: 3px;">' . $gregorianDateFormatted . '</div>
            <div style="font-size: 10px; color: #0d6efd; font-weight: bold;">' . e(Str::limit($letter->subject, 30)) . '</div>
        </div>';

        return '
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
                    margin-bottom: 5px;
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
                .letter-info {
                    margin-bottom: 30px;
                    padding: 15px;
                    background-color: #f5f5f5;
                    border-radius: 5px;
                }
                .letter-info table {
                    width: 100%;
                }
                .letter-info td {
                    text-align: center;
                    padding: 10px;
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
                    margin-bottom: 40px;
                    font-size: 14px;
                    line-height: 2;
                }
                .signature-section {
                    margin-top: 50px;
                }
                .signature-section table {
                    width: 100%;
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
                .page-footer {
                    position: fixed;
                    bottom: 10px;
                    left: 20px;
                    right: 20px;
                    text-align: center;
                    font-size: 10px;
                    color: #999;
                    border-top: 1px solid #ddd;
                    padding-top: 10px;
                }
                .barcode-section {
                    text-align: center;
                    margin-bottom: 10px;
                }
            </style>
        </head>
        <body>
            <div class="header">
                ' . $logoHtml . '
                <div class="company-name">' . e($company->name) . '</div>
                ' . ($company->name_en ? '<div class="company-name-en">' . e($company->name_en) . '</div>' : '') . '
                <div class="company-info">
                    ' . ($company->address ? e($company->address) . ' | ' : '') . '
                    ' . ($company->phone ? 'هاتف: ' . e($company->phone) . ' | ' : '') . '
                    ' . ($company->email ? e($company->email) : '') . '
                </div>
            </div>

            ' . $barcodeSectionHtml . '
            <div style="clear: both;"></div>

            ' . ($letter->recipient_name || $letter->recipient_organization ? '
            <div class="recipient">
                <span class="recipient-label">إلى:</span>
                ' . e($letter->recipient_title) . ' ' . e($letter->recipient_name) . '
                ' . ($letter->recipient_organization ? '<br>' . e($letter->recipient_organization) : '') . '
            </div>
            ' : '') . '

            <div class="subject">
                <span class="subject-label">الموضوع:</span> ' . e($letter->subject) . '
            </div>

            <div class="content">
                <p>السلام عليكم ورحمة الله وبركاته،</p>
                ' . nl2br(e($letter->content)) . '
                <p>وتقبلوا فائق الاحترام والتقدير،،،</p>
            </div>

            <div class="signature-section">
                <table>
                    <tr>
                        <td class="signature-box">
                            ' . $signatureHtml . '
                            <div class="signature-name">' . e($letter->author->name ?? '') . '</div>
                            <div>' . e($letter->author->job_title ?? 'الموظف المسؤول') . '</div>
                        </td>
                        <td class="signature-box">
                            ' . $stampHtml . '
                        </td>
                    </tr>
                </table>
            </div>

            <div class="page-footer">
                ' . ($company->commercial_register ? 'سجل تجاري: ' . e($company->commercial_register) . ' | ' : '') . '
                ' . ($company->tax_number ? 'الرقم الضريبي: ' . e($company->tax_number) . ' | ' : '') . '
                ' . ($company->website ? e($company->website) : '') . '
            </div>
        </body>
        </html>';
    }
}
