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
        'address',
        'phone',
        'email',
        'website',
        'commercial_register',
        'tax_number',
        'letter_prefix',
        'last_letter_number',
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
