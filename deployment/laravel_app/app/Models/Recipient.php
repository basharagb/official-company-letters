<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * نموذج المستلمين المحفوظين
 */
class Recipient extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'name',
        'title',
        'email',
        'phone',
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
     * البحث في المستلمين
     */
    public function scopeSearch($query, $search)
    {
        return $query->where('name', 'like', "%{$search}%")
            ->orWhere('email', 'like', "%{$search}%");
    }

    /**
     * المستلمين النشطين فقط
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
