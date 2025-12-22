#!/bin/bash

# سكريبت نشر التحديثات على السيرفر الإنتاجي
# استخدام: ./deploy.sh

echo "🚀 بدء عملية النشر..."

# معلومات السيرفر (عدّلها حسب سيرفرك)
SERVER_USER="your_username"
SERVER_HOST="emsg.elite-center-ld.com"
SERVER_PATH="/home/your_username/public_html"

echo "📦 رفع الملفات..."

# رفع ملف CreateDemoAccount
scp app/Console/Commands/CreateDemoAccount.php $SERVER_USER@$SERVER_HOST:$SERVER_PATH/app/Console/Commands/

# رفع Migration
scp database/migrations/2024_12_22_000001_add_multi_company_support.php $SERVER_USER@$SERVER_HOST:$SERVER_PATH/database/migrations/

# رفع Models
scp app/Models/User.php $SERVER_USER@$SERVER_HOST:$SERVER_PATH/app/Models/
scp app/Models/JoinRequest.php $SERVER_USER@$SERVER_HOST:$SERVER_PATH/app/Models/

# رفع Controllers
scp app/Http/Controllers/Api/AuthController.php $SERVER_USER@$SERVER_HOST:$SERVER_PATH/app/Http/Controllers/Api/

echo "✅ تم رفع الملفات بنجاح"

echo "🔧 تشغيل الأوامر على السيرفر..."

# الاتصال بالسيرفر وتشغيل الأوامر
ssh $SERVER_USER@$SERVER_HOST << 'ENDSSH'
cd /home/your_username/public_html

# تشغيل Migrations
php artisan migrate --force

# إنشاء حساب Demo
php artisan demo:create --email=demo@letters.sa --password=Demo@Review2024 --with-data

# مسح الـ Cache
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

echo "✅ تم تنفيذ جميع الأوامر بنجاح"
ENDSSH

echo "🎉 اكتمل النشر بنجاح!"
echo ""
echo "📝 بيانات الدخول للمراجعة:"
echo "Email: demo@letters.sa"
echo "Password: Demo@Review2024"
