#!/bin/bash

set -e

echo "Atualizando repositórios..."
sudo apt update -y

echo "Instalando Nginx..."
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Instalando PHP..."
sudo apt install php-fpm php-mysqli -y

# Pegando a versão do PHP instalada (extraindo a versão principal, ex: 8.3)
PHP_VERSION=$(php -r "echo explode(' ', phpversion())[0];" | cut -d'.' -f1,2)

echo "Instalando MariaDB..."
sudo apt install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "Configurando MariaDB..."
sudo mysql_secure_installation <<EOF
n
n
y
y
y
y
EOF

echo "Criando banco de dados e usuário MariaDB..."
DB_PASSWORD=$(openssl rand -base64 12)
sudo mysql -u root -e "
CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
"

echo "Configurando Nginx para o WordPress..."

# Obter token IMDSv2
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 60")

# Usar token para obter IP público
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

# Configuração do Nginx
cat <<EOF | sudo tee /etc/nginx/sites-available/wordpress
server {
    listen 80;
    server_name $PUBLIC_IP;  

    root /var/www/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP_VERSION}-fpm.sock;  
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

echo "Habilitando site e recarregando Nginx..."
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo systemctl reload nginx

echo "Instalando WordPress..."
cd /var/www/
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzvf latest.tar.gz
sudo rm latest.tar.gz
sudo chown -R www-data:www-data wordpress
sudo chmod -R 755 wordpress

echo "Configurando wp-config.php..."
cd wordpress
sudo mv wp-config-sample.php wp-config.php

# Modificando wp-config.php com as configurações do banco de dados
sudo sed -i "s/database_name_here/wordpress/" wp-config.php
sudo sed -i "s/username_here/wp_user/" wp-config.php
sudo sed -i "s/password_here/$DB_PASSWORD/" wp-config.php
sudo sed -i "s/localhost/localhost/" wp-config.php

echo "Instalação concluída! Acesse http://$PUBLIC_IP para finalizar a configuração."
