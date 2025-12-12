<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('letters', function (Blueprint $table) {
            // إضافة حقول جديدة
            $table->unsignedBigInteger('company_id')->nullable()->after('id');
            $table->foreign('company_id')->references('id')->on('companies')->onDelete('cascade');
            
            $table->string('reference_number')->unique()->after('company_id'); // رقم الصادر
            $table->string('recipient_name')->nullable()->after('subject'); // اسم المستلم
            $table->string('recipient_title')->nullable()->after('recipient_name'); // صفة المستلم
            $table->string('recipient_organization')->nullable()->after('recipient_title'); // جهة المستلم
            
            $table->date('gregorian_date')->after('creation_date'); // التاريخ الميلادي
            $table->string('hijri_date')->after('gregorian_date'); // التاريخ الهجري
            
            $table->unsignedBigInteger('template_id')->nullable()->after('content');
            $table->foreign('template_id')->references('id')->on('letter_templates')->onDelete('set null');
            
            $table->json('styles')->nullable()->after('template_id'); // إعدادات التنسيق
            $table->string('pdf_path')->nullable()->after('styles'); // مسار ملف PDF
            $table->string('share_token')->nullable()->after('pdf_path'); // رمز المشاركة
            
            $table->enum('status', ['draft', 'issued', 'sent', 'archived'])->default('draft')->after('share_token');
            
            // حذف الحقول القديمة غير المطلوبة
            $table->dropColumn(['text_color']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('letters', function (Blueprint $table) {
            $table->dropForeign(['company_id']);
            $table->dropForeign(['template_id']);
            $table->dropColumn([
                'company_id', 'reference_number', 'recipient_name', 'recipient_title',
                'recipient_organization', 'gregorian_date', 'hijri_date', 'template_id',
                'styles', 'pdf_path', 'share_token', 'status'
            ]);
            $table->string('text_color');
        });
    }
};
