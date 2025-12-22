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
        // إضافة حقول جديدة لجدول المستخدمين
        Schema::table('users', function (Blueprint $table) {
            // هل المستخدم هو الأدمن الرئيسي للنظام
            if (!Schema::hasColumn('users', 'is_super_admin')) {
                $table->boolean('is_super_admin')->default(false)->after('role');
            }
            // هل المستخدم هو مالك/مؤسس الشركة (أول من سجل)
            if (!Schema::hasColumn('users', 'is_company_owner')) {
                $table->boolean('is_company_owner')->default(false)->after('is_super_admin');
            }
            // حالة المستخدم (معتمد، بانتظار الموافقة، مرفوض)
            if (!Schema::hasColumn('users', 'status')) {
                $table->enum('status', ['approved', 'pending', 'rejected'])->default('approved')->after('is_company_owner');
            }
        });

        // إنشاء جدول طلبات الانضمام للشركات
        Schema::create('join_requests', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('company_id');
            $table->enum('status', ['pending', 'approved', 'rejected'])->default('pending');
            $table->unsignedBigInteger('approved_by')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('company_id')->references('id')->on('companies')->onDelete('cascade');
            $table->foreign('approved_by')->references('id')->on('users')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('join_requests');
        
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['is_super_admin', 'is_company_owner', 'status']);
        });
    }
};
