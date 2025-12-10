<?php

namespace Database\Seeders;

use App\Models\Company;
use App\Models\User;
use App\Models\Subscription;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // إنشاء الشركة الافتراضية
        $company = Company::create([
            'name' => 'شركة الخطابات الرسمية',
            'name_en' => 'Official Letters Company',
            'address' => 'الرياض، المملكة العربية السعودية',
            'phone' => '+966 11 123 4567',
            'email' => 'info@letters.sa',
            'letter_prefix' => 'OUT',
            'last_letter_number' => 0,
        ]);

        // إنشاء المستخدم الافتراضي (المدير)
        User::create([
            'company_id' => $company->id,
            'name' => 'مدير النظام',
            'email' => 'admin@letters.sa',
            'password' => Hash::make('123456'),
            'job_title' => 'مدير النظام',
            'role' => 'admin',
            'access_level' => 1,
        ]);

        // إنشاء اشتراك تجريبي
        Subscription::create([
            'company_id' => $company->id,
            'type' => 'yearly',
            'price' => 0,
            'start_date' => Carbon::now(),
            'end_date' => Carbon::now()->addYear(),
            'status' => 'active',
            'letters_limit' => null,
            'letters_used' => 0,
        ]);
    }
}
