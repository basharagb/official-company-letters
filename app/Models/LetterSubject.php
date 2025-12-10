<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * نموذج مواضيع الخطابات المحفوظة
 */
class LetterSubject extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'subject',
        'category',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    /**
     * العلاقة مع الشركة
     */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    /**
     * البحث في المواضيع
     */
    public function scopeSearch($query, $search)
    {
        return $query->where('subject', 'like', "%{$search}%")
            ->orWhere('category', 'like', "%{$search}%");
    }

    /**
     * المواضيع النشطة فقط
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
