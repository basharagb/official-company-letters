<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'name_en',
        'logo',
        'signature',
        'stamp',
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
        'address',
        'phone',
        'email',
        'website',
        'commercial_register',
        'tax_number',
        'letter_prefix',
        'last_letter_number',
    ];

    protected $casts = [
        'show_barcode' => 'boolean',
        'show_reference_number' => 'boolean',
        'show_hijri_date' => 'boolean',
        'show_gregorian_date' => 'boolean',
        'show_subject_in_header' => 'boolean',
        'setup_completed' => 'boolean',
    ];

    /**
     * الحصول على رقم الصادر التالي
     */
    public function getNextReferenceNumber(): string
    {
        $this->increment('last_letter_number');
        $year = date('Y');
        $number = str_pad($this->last_letter_number, 5, '0', STR_PAD_LEFT);
        return "{$this->letter_prefix}-{$year}-{$number}";
    }

    /**
     * العلاقة مع المستخدمين
     */
    public function users()
    {
        return $this->hasMany(User::class);
    }

    /**
     * العلاقة مع الخطابات
     */
    public function letters()
    {
        return $this->hasMany(Letter::class);
    }

    /**
     * العلاقة مع القوالب
     */
    public function templates()
    {
        return $this->hasMany(LetterTemplate::class);
    }

    /**
     * العلاقة مع الاشتراكات
     */
    public function subscriptions()
    {
        return $this->hasMany(Subscription::class);
    }

    /**
     * الحصول على الاشتراك النشط
     */
    public function activeSubscription()
    {
        return $this->hasOne(Subscription::class)->where('status', 'active');
    }
}
