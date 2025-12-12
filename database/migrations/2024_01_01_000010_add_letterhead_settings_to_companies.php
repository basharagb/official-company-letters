<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('companies', function (Blueprint $table) {
            // ملف الورق الرسمي (PDF أو صورة)
            $table->string('letterhead_file')->nullable()->after('stamp');
            
            // موقع الباركود والمعلومات (right = يمين، left = يسار)
            $table->enum('barcode_position', ['right', 'left'])->default('right')->after('letterhead_file');
            
            // إظهار الباركود
            $table->boolean('show_barcode')->default(true)->after('barcode_position');
            
            // إظهار الرقم الصادر تحت الباركود
            $table->boolean('show_reference_number')->default(true)->after('show_barcode');
            
            // إظهار التاريخ الهجري
            $table->boolean('show_hijri_date')->default(true)->after('show_reference_number');
            
            // إظهار التاريخ الميلادي
            $table->boolean('show_gregorian_date')->default(true)->after('show_hijri_date');
            
            // إظهار الموضوع في منطقة الباركود
            $table->boolean('show_subject_in_header')->default(true)->after('show_gregorian_date');
            
            // هل تم إكمال الإعدادات الأولية
            $table->boolean('setup_completed')->default(false)->after('show_subject_in_header');
            
            // المسافة من أعلى الصفحة (بالمليمتر)
            $table->integer('barcode_top_margin')->default(20)->after('setup_completed');
            
            // المسافة من الجانب (بالمليمتر)
            $table->integer('barcode_side_margin')->default(15)->after('barcode_top_margin');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('companies', function (Blueprint $table) {
            $table->dropColumn([
                'letterhead_file',
                'barcode_position',
                'show_barcode',
                'show_reference_number',
                'show_hijri_date',
                'show_gregorian_date',
                'show_subject_in_header',
                'setup_completed',
                'barcode_top_margin',
                'barcode_side_margin',
            ]);
        });
    }
};
