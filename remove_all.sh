#!/bin/bash

set -e

echo "Removendo o Nginx e limpando arquivos de configuração..."
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo apt purge nginx nginx-common -y
sudo apt autoremove -y
sudo rm -rf /etc/nginx /var/www/html

echo "Removendo o PHP e limpando arquivos de configuração..."
sudo apt purge php* -y
sudo apt autoremove -y
sudo rm -rf /etc/php /var/lib/php

echo "Removendo o MariaDB e limpando arquivos de configuração..."
sudo systemctl stop mariadb
sudo systemctl disable mariadb
sudo apt purge mariadb-server mariadb-client mariadb-common -y
sudo apt autoremove -y
sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql

echo "Removendo o WordPress..."
sudo rm -rf /var/www/wordpress

echo "Removendo arquivos de configuração do Nginx para WordPress..."
sudo rm -rf /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress

echo "Limpando dependências não utilizadas..."
sudo apt autoremove --purge -y

echo "Limpando cache de pacotes..."
sudo apt clean

echo "Sistema limpo! Agora você pode rodar o script de instalação novamente."
