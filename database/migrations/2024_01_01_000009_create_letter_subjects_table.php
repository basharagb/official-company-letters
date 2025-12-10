<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * جدول مواضيع الخطابات المحفوظة
     */
    public function up(): void
    {
        Schema::create('letter_subjects', function (Blueprint $table) {
            $table->id();
            $table->foreignId('company_id')->constrained()->onDelete('cascade');
            $table->string('subject'); // موضوع الخطاب
            $table->string('category')->nullable(); // تصنيف الموضوع
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            
            $table->index(['company_id', 'subject']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('letter_subjects');
    }
};
