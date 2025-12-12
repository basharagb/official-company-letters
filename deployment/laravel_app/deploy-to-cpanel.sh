#!/bin/bash

# Deploy Laravel App to A2 Hosting cPanel
# Usage: ./deploy-to-cpanel.sh

set -e

echo "🚀 Starting deployment to A2 Hosting..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}📋 Deployment Configuration:${NC}"
echo "Target: A2 Hosting cPanel"
echo "Domain: emsg.elite-center-ld.com"
echo "Database: elitece_erp"

# Step 1: Prepare files for upload
echo -e "\n${YELLOW}📦 Preparing files for upload...${NC}"

# Create deployment directory
mkdir -p deployment/laravel_app
mkdir -p deployment/public_html

# Copy Laravel files (excluding public directory)
echo "Copying Laravel core files..."
rsync -av --exclude='public' --exclude='node_modules' --exclude='.git' --exclude='storage/logs/*' --exclude='vendor' ./ deployment/laravel_app/

# Copy public directory contents to public_html
echo "Copying public files..."
cp -r public/* deployment/public_html/

# Update index.php to point to correct Laravel location
sed -i.bak "s|__DIR__.'/../|__DIR__.'/../laravel_app/|g" deployment/public_html/index.php

# Copy production environment file
cp .env.production deployment/laravel_app/.env

echo -e "${GREEN}✅ Files prepared in ./deployment/ directory${NC}"

echo -e "\n${YELLOW}🔧 Next steps (run these commands on A2 hosting):${NC}"

cat << 'EOF'

# 1. Connect to A2 hosting via SSH (get credentials from cPanel)
ssh your-username@your-domain.com

# 2. Navigate to your domain's directory
cd ~/public_html

# 3. Upload and extract files (use File Manager or SCP)
# Upload deployment.tar.gz, then extract:
tar -xzf deployment.tar.gz

# 4. Set up Laravel application
cd ~/laravel_app

# 5. Install Composer dependencies
/usr/local/bin/ea-php81 /usr/local/bin/composer install --no-dev --optimize-autoloader

# 6. Generate application key
/usr/local/bin/ea-php81 artisan key:generate --force

# 7. Run database migrations
/usr/local/bin/ea-php81 artisan migrate --force

# 8. Set correct permissions
chmod -R 755 storage bootstrap/cache
chmod -R 644 storage/logs

# 9. Create symbolic link for storage
/usr/local/bin/ea-php81 artisan storage:link

# 10. Cache for production
/usr/local/bin/ea-php81 artisan config:cache
/usr/local/bin/ea-php81 artisan route:cache
/usr/local/bin/ea-php81 artisan view:cache

EOF

echo -e "\n${YELLOW}📊 Database Setup (via cPanel):${NC}"
cat << 'EOF'
1. Go to MySQL Databases in cPanel
2. Create database: elitece_erp
3. Create user: elitece_user with password: Bashar@1994engzy
4. Grant all privileges to user
EOF

echo -e "\n${GREEN}🎉 Deployment package ready!${NC}"
echo -e "Upload the ${YELLOW}deployment${NC} folder contents to your A2 hosting account."
