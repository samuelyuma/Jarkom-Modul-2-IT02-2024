echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install apache2 -y

a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests

service apache2 start

echo '
<VirtualHost *:8080>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/it02

    ProxyRequests Off
    <Proxy balancer://mycluster>
        BalancerMember http://192.234.1.4:8080
        BalancerMember http://192.234.1.3:8080
        BalancerMember http://192.234.1.2:8080
        ProxySet lbmethod=byrequests
    </Proxy>

    ProxyPass / balancer://mycluster/
    ProxyPassReverse / balancer://mycluster/
</VirtualHost>
' > /etc/apache2/sites-available/default-8080.conf

a2ensite default-8080.conf

service apache2 restart
