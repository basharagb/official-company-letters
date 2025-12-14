<?php

return [
    'show_warnings' => false,
    'public_path' => null,
    'convert_entities' => true,

    'options' => [
        'font_dir' => base_path('vendor/dompdf/dompdf/lib/fonts'),
        'font_cache' => base_path('vendor/dompdf/dompdf/lib/fonts'),
        'temp_dir' => sys_get_temp_dir(),
        'chroot' => realpath(base_path()),
        
        'allowed_protocols' => [
            'data://' => ['rules' => []],
            'file://' => ['rules' => []],
            'http://' => ['rules' => []],
            'https://' => ['rules' => []],
        ],

        'log_output_file' => null,
        'enable_font_subsetting' => false,
        'pdf_backend' => 'CPDF',
        'default_media_type' => 'screen',
        'default_paper_size' => 'a4',
        'default_paper_orientation' => 'portrait',
        
        // استخدام Amiri كخط افتراضي - يدعم العربية
        'default_font' => 'Amiri',
        
        'dpi' => 96,
        'enable_php' => false,
        'enable_javascript' => true,
        
        // تمكين تحميل الموارد البعيدة (للخطوط والصور)
        'enable_remote' => true,
        
        'allowed_remote_hosts' => null,
        'font_height_ratio' => 1.1,
        'enable_html5_parser' => true,
        
        // دعم RTL للعربية
        'isHtml5ParserEnabled' => true,
    ],
];
