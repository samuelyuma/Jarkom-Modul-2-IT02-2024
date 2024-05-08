# Soal 14

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install dnsutils nginx php-fpm php -y

service php7.0-fpm start

service nginx start

echo '
upstream mylta {
    server 192.234.1.2:8082; # Lipovka
    server 192.234.1.3:8083; # Stalber
    server 192.234.1.4:8084; # Severny
}

server {
  listen 8082;
  server_name 192.234.2.4;

  location / {
    proxy_pass http://mylta;
  }
}

server {
  listen 8083;
  server_name 192.234.2.4;

  location / {
    proxy_pass http://mylta;
  }
}

server {
  listen 8084;
  server_name 192.234.2.4;

  location / {
    proxy_pass http://mylta;
  }
}
' > /etc/nginx/sites-available/it02

ln -s /etc/nginx/sites-available/it02 /etc/nginx/sites-enabled

rm /etc/nginx/sites-enabled/default

service nginx restart

# Soal 17

echo '
upstream mylta {
    server 192.234.1.2:8082; # Lipovka
    server 192.234.1.3:8083; # Stalber
    server 192.234.1.4:8084; # Severny
}

server {
    listen 14000;
    server_name mylta.it02.com;

    location / {
        proxy_pass http://mylta;
    }
}

server {
    listen 14400;
    server_name mylta.it02.com;

    location / {
        proxy_pass http://mylta;
    }
}

server {
    listen 8082;
    listen 8083;
    listen 8084;
    server_name 192.234.2.4;

    return 404;
}
' > /etc/nginx/sites-available/it02

# Soal 18

echo '
upstream mylta {
    server 192.234.1.2:8082; # Lipovka
    server 192.234.1.3:8083; # Stalber
    server 192.234.1.4:8084; # Severny
}

server {
    listen 14000;
    server_name mylta.it02.com;

    location / {
        proxy_pass http://mylta;
    }
}

server {
    listen 14400;
    server_name mylta.it02.com;

    location / {
        proxy_pass http://mylta;
    }
}

server {
    listen 80 default_server;
    server_name _;

    location / {
        return 301 http://www.mylta.xxx.com$request_uri;
    }
}

server {
    listen 8082;
    listen 8083;
    listen 8084;
    server_name 192.234.2.4;

    return 404;
}
' > /etc/nginx/sites-available/it02

# Soal 19 & 20

echo '
upstream mylta {
    server 192.234.1.2:8082; # Lipovka
    server 192.234.1.3:8083; # Stalber
    server 192.234.1.4:8084; # Severny
}

server {
    listen 14000;
    server_name mylta.it02.com;

    location / {
        proxy_pass http://mylta;
    }
}

server {
    listen 14400;
    server_name mylta.it02.com;

    location / {
        proxy_pass http://mylta;
    }
}

server {
    listen 80 default_server;
    server_name _;

    location / {
        return 301 http://www.mylta.xxx.com$request_uri;
    }
}

server {
    listen 8082;
    listen 8083;
    listen 8084;
    server_name 192.234.2.4;

    return 404;
}

server {
    listen 80;
    server_name tamat.it02.com www.tamat.it02.com;

    location / {
        autoindex on;
        proxy_pass http://mylta;
    }
}
' > /etc/nginx/sites-available/it02



