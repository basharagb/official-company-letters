<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LetterTemplate extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'name',
        'content',
        'category',
        'styles',
        'is_active',
    ];

    protected $casts = [
        'styles' => 'array',
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
     * العلاقة مع الخطابات
     */
    public function letters()
    {
        return $this->hasMany(Letter::class, 'template_id');
    }
}
