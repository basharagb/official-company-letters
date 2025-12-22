<?php

namespace App\Console\Commands;

use App\Models\User;
use App\Models\Company;
use App\Models\Subscription;
use App\Models\Letter;
use App\Models\LetterTemplate;
use App\Models\Recipient;
use App\Models\Organization;
use App\Models\RecipientTitle;
use App\Models\LetterSubject;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Carbon\Carbon;

class CreateDemoAccount extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'demo:create {--email=demo@letters.sa} {--password=Demo@123456} {--with-data}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create a demo account for App Store review with sample data';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $email = $this->option('email');
        $password = $this->option('password');
        $withData = $this->option('with-data');

        // التحقق من وجود الحساب
        $existingUser = User::where('email', $email)->first();
        
        if ($existingUser) {
            // تحديث كلمة المرور فقط
            $existingUser->update([
                'password' => Hash::make($password),
                'status' => 'approved',
            ]);
            $this->info("✅ Demo account updated: {$email}");
            $this->info("Password: {$password}");
            
            if ($withData) {
                $this->createSampleData($existingUser->company);
            }
            
            return 0;
        }

        // إنشاء شركة تجريبية
        $company = Company::firstOrCreate(
            ['email' => $email],
            [
                'name' => 'شركة النخبة للخطابات الرسمية',
                'name_en' => 'Elite Official Letters Company',
                'address' => 'الرياض، المملكة العربية السعودية',
                'phone' => '+966112345678',
                'letter_prefix' => 'OUT',
                'last_letter_number' => 0,
                'setup_completed' => true,
                'barcode_position' => 'right',
                'show_barcode' => true,
                'show_reference_number' => true,
                'show_hijri_date' => true,
                'show_gregorian_date' => true,
                'show_subject_in_header' => true,
                'barcode_top_margin' => 20,
                'barcode_side_margin' => 15,
            ]
        );

        // إنشاء المستخدم
        $user = User::create([
            'company_id' => $company->id,
            'name' => 'مدير الخطابات',
            'email' => $email,
            'password' => Hash::make($password),
            'job_title' => 'مدير الخطابات الرسمية',
            'role' => 'admin',
            'access_level' => 1,
            'is_super_admin' => false,
            'is_company_owner' => true,
            'status' => 'approved',
        ]);

        // إنشاء اشتراك
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

        $this->info("✅ Demo account created successfully!");
        $this->info("Email: {$email}");
        $this->info("Password: {$password}");
        $this->info("Company: {$company->name}");

        // إنشاء بيانات تجريبية
        if ($withData) {
            $this->createSampleData($company);
        }

        return 0;
    }

    /**
     * إنشاء بيانات تجريبية
     */
    private function createSampleData(Company $company)
    {
        $this->info("\n📊 Creating sample data...");

        // إنشاء جهات
        $organizations = [
            ['name' => 'وزارة التعليم', 'name_en' => 'Ministry of Education'],
            ['name' => 'وزارة الصحة', 'name_en' => 'Ministry of Health'],
            ['name' => 'الهيئة العامة للزكاة والدخل', 'name_en' => 'ZATCA'],
        ];

        foreach ($organizations as $org) {
            Organization::firstOrCreate(
                ['company_id' => $company->id, 'name' => $org['name']],
                ['name_en' => $org['name_en']]
            );
        }
        $this->info("✓ Created organizations");

        // إنشاء ألقاب المستلمين
        $titles = ['معالي', 'سعادة', 'الأستاذ', 'الدكتور', 'المهندس'];
        foreach ($titles as $title) {
            RecipientTitle::firstOrCreate(
                ['company_id' => $company->id, 'title' => $title]
            );
        }
        $this->info("✓ Created recipient titles");

        // إنشاء مواضيع الخطابات
        $subjects = [
            'طلب موافقة',
            'إفادة',
            'دعوة لحضور اجتماع',
            'تقرير شهري',
            'طلب معلومات',
        ];
        foreach ($subjects as $subject) {
            LetterSubject::firstOrCreate(
                ['company_id' => $company->id, 'subject' => $subject]
            );
        }
        $this->info("✓ Created letter subjects");

        // إنشاء مستلمين
        $org = Organization::where('company_id', $company->id)->first();
        $recipients = [
            ['name' => 'أحمد محمد العلي', 'title' => 'معالي', 'job_title' => 'الوزير'],
            ['name' => 'فاطمة عبدالله السالم', 'title' => 'سعادة', 'job_title' => 'المدير العام'],
            ['name' => 'خالد سعد الغامدي', 'title' => 'الأستاذ', 'job_title' => 'مدير الإدارة'],
        ];

        foreach ($recipients as $rec) {
            Recipient::firstOrCreate(
                ['company_id' => $company->id, 'name' => $rec['name']],
                [
                    'organization_id' => $org->id,
                    'title' => $rec['title'],
                    'job_title' => $rec['job_title'],
                ]
            );
        }
        $this->info("✓ Created recipients");

        // إنشاء قوالب
        $templates = [
            [
                'name' => 'قالب خطاب رسمي',
                'content' => 'السلام عليكم ورحمة الله وبركاته\n\nنحيطكم علماً بأن...\n\nوتقبلوا فائق الاحترام والتقدير',
            ],
            [
                'name' => 'قالب دعوة اجتماع',
                'content' => 'تحية طيبة وبعد،\n\nيسرنا دعوتكم لحضور الاجتماع...\n\nشاكرين لكم حسن تعاونكم',
            ],
        ];

        foreach ($templates as $template) {
            LetterTemplate::firstOrCreate(
                ['company_id' => $company->id, 'name' => $template['name']],
                ['content' => $template['content']]
            );
        }
        $this->info("✓ Created templates");

        // إنشاء خطابات تجريبية
        $recipient = Recipient::where('company_id', $company->id)->first();
        $user = User::where('company_id', $company->id)->first();
        
        for ($i = 1; $i <= 5; $i++) {
            $referenceNumber = $company->getNextReferenceNumber();
            $date = Carbon::now()->subDays($i);
            
            Letter::create([
                'company_id' => $company->id,
                'author_id' => $user->id,
                'recipient_id' => $recipient->id,
                'reference_number' => $referenceNumber,
                'subject' => "موضوع الخطاب رقم {$i}",
                'recipient_name' => $recipient->name,
                'recipient_title' => $recipient->title,
                'recipient_organization' => $recipient->organization->name ?? '',
                'content' => "محتوى الخطاب التجريبي رقم {$i}\n\nهذا خطاب تجريبي لعرض إمكانيات النظام.",
                'creation_date' => $date,
                'gregorian_date' => $date,
                'hijri_date' => $date->format('Y-m-d'),
                'status' => $i <= 3 ? 'sent' : 'draft',
            ]);
        }
        $this->info("✓ Created sample letters");

        $this->info("\n✅ Sample data created successfully!");
    }
}
