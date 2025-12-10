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
        Schema::create('companies', function (Blueprint $table) {
            $table->id();
            $table->string('name'); // اسم الشركة
            $table->string('name_en')->nullable(); // اسم الشركة بالإنجليزي
            $table->string('logo')->nullable(); // شعار الشركة
            $table->string('signature')->nullable(); // توقيع المصرّح
            $table->string('stamp')->nullable(); // الختم الرسمي
            $table->string('address')->nullable(); // العنوان
            $table->string('phone')->nullable(); // رقم الهاتف
            $table->string('email')->nullable(); // البريد الإلكتروني
            $table->string('website')->nullable(); // الموقع الإلكتروني
            $table->string('commercial_register')->nullable(); // السجل التجاري
            $table->string('tax_number')->nullable(); // الرقم الضريبي
            $table->string('letter_prefix')->default('OUT'); // بادئة رقم الصادر
            $table->integer('last_letter_number')->default(0); // آخر رقم صادر
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('companies');
    }
};
