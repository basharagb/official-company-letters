#!/bin/bash

# A2 Hosting Terminal Deployment Commands
# Execute these commands step by step on A2 hosting

echo "🚀 A2 Hosting Deployment Commands for Laravel Application"
echo "========================================================="

cat << 'EOF'

# STEP 1: Connect to A2 hosting SSH terminal
# Get SSH credentials from cPanel > SSH Access
# Then connect: ssh username@yourdomain.com

# STEP 2: Navigate to public_html and clean up
cd ~/public_html
rm -rf * .[^.]*  # Clean existing files (be careful!)

# STEP 3: Upload deployment.tar.gz via File Manager first, then extract
cd ~/public_html
tar -xzf deployment.tar.gz

# STEP 4: Move files to correct locations
# public_html contents are already in place
# Laravel app is in laravel_app directory

# STEP 5: Install Composer dependencies (A2 hosting specific)
cd ~/public_html/laravel_app
/usr/local/bin/ea-php81 /usr/local/bin/composer install --no-dev --optimize-autoloader

# STEP 6: Set up Laravel environment
/usr/local/bin/ea-php81 artisan key:generate --force

# STEP 7: Set proper permissions for A2 hosting
find ~/public_html/laravel_app/storage -type f -exec chmod 644 {} \;
find ~/public_html/laravel_app/storage -type d -exec chmod 755 {} \;
find ~/public_html/laravel_app/bootstrap/cache -type f -exec chmod 644 {} \;
find ~/public_html/laravel_app/bootstrap/cache -type d -exec chmod 755 {} \;
chmod 644 ~/public_html/laravel_app/.env

# STEP 8: Create storage symbolic link
cd ~/public_html/laravel_app
/usr/local/bin/ea-php81 artisan storage:link

# STEP 9: Database setup (do this in cPanel MySQL Databases first):
# - Create database: elitece_erp
# - Create user: elitece_user  
# - Password: Bashar@1994engzy
# - Grant all privileges

# STEP 10: Run database migrations
/usr/local/bin/ea-php81 artisan migrate --force

# STEP 11: Cache configuration for production
/usr/local/bin/ea-php81 artisan config:cache
/usr/local/bin/ea-php81 artisan route:cache
/usr/local/bin/ea-php81 artisan view:cache

# STEP 12: Verify PHP version (should be 8.1 or higher)
/usr/local/bin/ea-php81 -v

# STEP 13: Test the application
curl -I https://emsg.elite-center-ld.com
curl -I https://emsg.elite-center-ld.com/api

# STEP 14: Check Laravel logs if there are issues
tail -f ~/public_html/laravel_app/storage/logs/laravel.log

EOF

echo ""
echo "🔧 Additional A2 Hosting Configuration Notes:"
echo ""
echo "1. PHP Version: Select PHP 8.1 in cPanel > MultiPHP Manager"
echo "2. Document Root: Should point to public_html (default)"
echo "3. SSL: Enable SSL certificate in cPanel > SSL/TLS"
echo "4. Database: Use cPanel > MySQL Databases to create database"
echo ""
echo "📁 File Structure after deployment:"
echo "~/public_html/           (Laravel public files - index.php, assets)"
echo "~/public_html/laravel_app/  (Laravel application core)"
echo ""
echo "🌐 URLs after deployment:"
echo "Web App: https://emsg.elite-center-ld.com"
echo "API: https://emsg.elite-center-ld.com/api"
echo ""
echo "✅ Deployment package ready: deployment.tar.gz (164 MB)"
