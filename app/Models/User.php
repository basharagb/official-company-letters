<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'company_id',
        'name',
        'job_title',
        'email',
        'phone',
        'password',
        'access_level',
        'role',
        'is_super_admin',
        'is_company_owner',
        'status',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
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
        return $this->hasMany(Letter::class, 'author_id');
    }

    /**
     * التحقق من صلاحية الأدمن
     */
    public function isAdmin(): bool
    {
        return $this->role === 'admin' || $this->access_level == 1;
    }

    /**
     * التحقق من صلاحية المدير
     */
    public function isManager(): bool
    {
        return $this->role === 'manager' || $this->isAdmin();
    }

    /**
     * التحقق من صلاحية الأدمن الرئيسي
     */
    public function isSuperAdmin(): bool
    {
        return $this->is_super_admin == true || $this->email === 'admin@letters.sa';
    }

    /**
     * التحقق من أن المستخدم هو مالك الشركة
     */
    public function isCompanyOwner(): bool
    {
        return $this->is_company_owner == true;
    }

    /**
     * التحقق من أن المستخدم معتمد
     */
    public function isApproved(): bool
    {
        return $this->status === 'approved';
    }

    /**
     * العلاقة مع طلبات الانضمام
     */
    public function joinRequests()
    {
        return $this->hasMany(JoinRequest::class);
    }
}
