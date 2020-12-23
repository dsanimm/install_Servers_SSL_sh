#!/bin/bash
sudo apt-get update
wget ftp://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
tar -zxf pcre-8.44.tar.gz
cd pcre-8.44
./configure
make
sudo make install
cd ..

wget http://zlib.net/zlib-1.2.11.tar.gz
tar -zxf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
make
sudo make install
cd ..

wget http://www.openssl.org/source/openssl-1.1.1g.tar.gz
tar -zxf openssl-1.1.1g.tar.gz
cd openssl-1.1.1g
./Configure darwin64-x86_64-cc --prefix=/usr
make
sudo make install
cd ..

sudo apt-get update
sudo apt-get install nginx
sudo nginx 
curl -I 127.0.0.1

cd ..
cd ..
cd etc/nginx
sudo mkdir ssl
cd ssl
sudo openssl genrsa -des3 -out server.key 1024
sudo openssl req -new -key server.key -out server.csr
sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

cd ..
sed '10assl on;' nginx.conf
sed '11assl_certificate /etc/nginx/ssl/server.crt;' nginx.conf
sed '12assl_certificate_key /etc/nginx/ssl/server.key;' nginx.conf 
sudo nginx -s reload
curl https://localhost:80/
