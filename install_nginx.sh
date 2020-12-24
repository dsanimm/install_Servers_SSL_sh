#$1 = domain and commonname, $2 = passkey
#First install dependencies pcre,zlib, openssl
#Installs nginx
#generate key and SSL certificate
#uses sed to insert the SSL config in nginx.conf
#!/bin/bash
cd ..
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

sudo apt-get install nginx
sudo nginx 
curl -I 127.0.0.1

cd ../..
cd etc/nginx
sudo mkdir ssl
cd ssl
domain=$1
commonname=$1
country=GB
state=Nottingham
locality=Nottinghamshire
organization=Jamescoyle.net
organizationalunit=IT
email=administrator@jamescoyle.net

openssl genrsa -des3 -passout pass:$2 -out server.key 2048 -noout
openssl req -new -key server.key -out server.csr -passin pass:$2 \-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key
sudo openssl x509 -req -in server.csr -signkey server.key -out server.crt

cd ..
sudo sed -i '5assl on;' nginx.conf
sudo sed -i '6assl_certificate /etc/nginx/ssl/server.crt;' nginx.conf
sudo sed -i '7assl_certificate_key /etc/nginx/ssl/server.key;' nginx.conf 
sudo nginx -s reload
curl https://localhost:80/
