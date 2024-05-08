# Soal 14

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install dnsutils lynx nginx apache2 libapache2-mod-php7.0 wget unzip php php-fpm -y

service php7.0-fpm start

service nginx start

mkdir -p /var/www/html/configuration/

wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O /var/www/html/configuration/lb.zip

unzip /var/www/html/configuration/lb.zip -d /var/www/html/configuration/

mv /var/www/html/configuration/worker/index.php /var/www/html/

rm -rf /var/www/html/configuration/

echo '
server {
    listen 8084;

    root /var/www/html;

    index index.php index.html index.htm;
    server_name _;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    # pass PHP scripts to FastCGI server
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
    }

    location ~ /\.ht {
     deny all;
    }

    error_log /var/log/nginx/jarkom-it02_error.log;
    access_log /var/log/nginx/jarkom-it02_access.log;
}
' > /etc/nginx/sites-available/it02

ln -s /etc/nginx/sites-available/it02 /etc/nginx/sites-enabled

rm /etc/nginx/sites-enabled/default

service nginx restart