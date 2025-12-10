<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Letter extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'reference_number',
        'subject',
        'recipient_name',
        'recipient_title',
        'recipient_organization',
        'content',
        'author_id',
        'creation_date',
        'gregorian_date',
        'hijri_date',
        'template_id',
        'styles',
        'pdf_path',
        'share_token',
        'status',
        'access_level',
    ];

    protected $casts = [
        'styles' => 'array',
        'gregorian_date' => 'date',
        'creation_date' => 'datetime',
    ];

    /**
     * Boot method لتوليد share_token تلقائياً
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($letter) {
            if (empty($letter->share_token)) {
                $letter->share_token = Str::random(32);
            }
        });
    }

    /**
     * العلاقة مع الشركة
     */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    /**
     * العلاقة مع المؤلف
     */
    public function author()
    {
        return $this->belongsTo(User::class, 'author_id');
    }

    /**
     * العلاقة مع القالب
     */
    public function template()
    {
        return $this->belongsTo(LetterTemplate::class, 'template_id');
    }

    /**
     * العلاقة مع الإصدارات
     */
    public function versions()
    {
        return $this->hasMany(LetterVersion::class);
    }

    /**
     * الحصول على رابط المشاركة
     */
    public function getShareUrlAttribute(): string
    {
        return url("/letters/share/{$this->share_token}");
    }

    /**
     * البحث في الخطابات
     */
    public function scopeSearch($query, $term)
    {
        return $query->where(function ($q) use ($term) {
            $q->where('reference_number', 'like', "%{$term}%")
              ->orWhere('subject', 'like', "%{$term}%")
              ->orWhere('content', 'like', "%{$term}%")
              ->orWhere('recipient_name', 'like', "%{$term}%")
              ->orWhereHas('author', function ($q) use ($term) {
                  $q->where('name', 'like', "%{$term}%");
              });
        });
    }

    /**
     * فلترة حسب التاريخ
     */
    public function scopeDateRange($query, $from, $to)
    {
        if ($from) {
            $query->where('gregorian_date', '>=', $from);
        }
        if ($to) {
            $query->where('gregorian_date', '<=', $to);
        }
        return $query;
    }
}
