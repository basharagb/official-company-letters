# Deployment Guide for cPanel

## Pre-deployment Checklist

### ✅ Bugs Fixed
- Fixed DashboardApiController 500 error (changed `is_active` to `status` for subscriptions)
- Added missing methods to Subscription model (`remainingLetters()`, `daysRemaining()`, `getPlanAttribute()`)
- Added missing `remember_token` column to users table
- Built frontend assets
- Cleared all caches

### 🚀 cPanel Deployment Steps

1. **Upload Files**
   - Upload all files except `.env` to public_html directory
   - Move `public` folder contents to public_html root
   - Move Laravel files to a subdirectory (e.g., `laravel_app`)

2. **Database Setup**
   ```sql
   -- Use these credentials in production .env:
   DB_HOST=localhost
   DB_DATABASE=elitece_erp  
   DB_USERNAME=elitece_user
   DB_PASSWORD=Bashar@1994engzy
   ```

3. **Environment Configuration**
   - Copy `.env.production` to `.env` on server
   - Update APP_KEY if needed: `php artisan key:generate`

4. **Run Migrations**
   ```bash
   php artisan migrate --force
   ```

5. **Set Permissions**
   ```bash
   chmod -R 755 storage
   chmod -R 755 bootstrap/cache
   ```

6. **Storage Link**
   ```bash
   php artisan storage:link
   ```

7. **Cache Optimization**
   ```bash
   php artisan config:cache
   php artisan route:cache
   php artisan view:cache
   ```

### 🔧 cPanel Configuration

1. **Point domain to public folder**
   - Set document root to public_html (where public folder contents are)

2. **PHP Version**
   - Ensure PHP 8.1+ is selected in cPanel

3. **Database**
   - Create MySQL database: `elitece_erp`
   - Create user: `elitece_user` with password: `Bashar@1994engzy`
   - Grant all privileges

### 📱 Mobile App Configuration

Mobile app is already configured for production:
- Base URL: `https://emsg.elite-center-ld.com/api`
- All endpoints properly configured

### 🔍 Testing After Deployment

1. Test API endpoints:
   - GET /api/dashboard (should return "Unauthenticated" not 500)
   - POST /api/auth/login
   - GET /api/letters

2. Test web interface:
   - Login page
   - Dashboard
   - Letters creation

### 🐛 Common Issues & Solutions

1. **500 Error**: Check storage permissions and .env configuration
2. **Database Error**: Verify database credentials and run migrations
3. **Assets Not Loading**: Ensure public folder is properly configured
4. **API 500**: Check logs in `storage/logs/laravel.log`

### 📝 Production URLs

- Web App: https://emsg.elite-center-ld.com
- API Base: https://emsg.elite-center-ld.com/api
- cPanel: https://az1-ts113.a2hosting.com:2083/
