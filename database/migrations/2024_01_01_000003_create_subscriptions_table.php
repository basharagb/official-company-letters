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
        Schema::create('subscriptions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('company_id');
            $table->foreign('company_id')->references('id')->on('companies')->onDelete('cascade');
            $table->enum('type', ['once', 'monthly', 'yearly']); // نوع الاشتراك
            $table->decimal('price', 10, 2); // السعر
            $table->date('start_date'); // تاريخ البداية
            $table->date('end_date')->nullable(); // تاريخ الانتهاء
            $table->enum('status', ['active', 'expired', 'cancelled'])->default('active');
            $table->integer('letters_limit')->nullable(); // حد الخطابات (للاشتراك المرة الواحدة)
            $table->integer('letters_used')->default(0); // عدد الخطابات المستخدمة
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('subscriptions');
    }
};
