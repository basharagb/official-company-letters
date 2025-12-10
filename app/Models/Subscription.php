<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Subscription extends Model
{
    use HasFactory;

    protected $fillable = [
        'company_id',
        'type',
        'price',
        'start_date',
        'end_date',
        'status',
        'letters_limit',
        'letters_used',
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date' => 'date',
        'price' => 'decimal:2',
    ];

    /**
     * العلاقة مع الشركة
     */
    public function company()
    {
        return $this->belongsTo(Company::class);
    }

    /**
     * التحقق من صلاحية الاشتراك
     */
    public function isValid(): bool
    {
        if ($this->status !== 'active') {
            return false;
        }

        // اشتراك لمرة واحدة
        if ($this->type === 'once') {
            return $this->letters_used < $this->letters_limit;
        }

        // اشتراك شهري أو سنوي
        return $this->end_date >= now();
    }

    /**
     * زيادة عدد الخطابات المستخدمة
     */
    public function incrementUsage(): void
    {
        $this->increment('letters_used');
        
        // تحديث حالة الاشتراك إذا انتهى
        if ($this->type === 'once' && $this->letters_used >= $this->letters_limit) {
            $this->update(['status' => 'expired']);
        }
    }
}
