# Soal 12

echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install lynx apache2 php libapache2-mod-php7.0 wget unzip -y

cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/it02.conf

rm /etc/apache2/sites-enabled/000-default.conf

echo '<VirtualHost *:8080>
ServerAdmin webmaster@localhost
DocumentRoot /var/www/html
</VirtualHost>' > /etc/apache2/sites-available/it02.conf

sed -i '/Listen 80/a Listen 8080' '/etc/apache2/ports.conf'

a2ensite it02.conf

mkdir -p /var/www/html/configuration/

wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O /var/www/html/configuration/lb.zip

unzip /var/www/html/configuration/lb.zip -d /var/www/html/configuration/

mv /var/www/html/configuration/worker/index.php /var/www/html/

rm -rf /var/www/html/configuration/

service apache2 start

lynx 192.234.1.4/index.php