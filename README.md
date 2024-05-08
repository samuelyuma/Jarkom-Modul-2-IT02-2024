# Jarkom-Modul-2-IT02-2024

Kelompok IT02 :
| Nama | NRP |
| -------------------- | ---------- |
| Samuel Yuma Krismata | 5027221029 |
| Marselinus Krisnawan Riandika | 5027221056 |

## Daftar Isi

[Soal 1](#soal-1)</br>
[Soal 2](#soal-2)</br>
[Soal 3](#soal-3)</br>
[Soal 4](#soal-4)</br>
[Soal 5](#soal-5)</br>
[Soal 6](#soal-6)</br>
[Soal 7](#soal-7)</br>
[Soal 8](#soal-8)</br>
[Soal 9](#soal-9)</br>
[Soal 10](#soal-10)</br>
[Soal 11](#soal-11)</br>
[Soal 12](#soal-12)</br>
[Soal 13](#soal-13)</br>
[Soal 14](#soal-14)</br>
[Soal 15](#soal-15)</br>
[Soal 16](#soal-16)</br>
[Soal 17](#soal-17)</br>
[Soal 18](#soal-18)</br>
[Soal 19](#soal-19)</br>
[Soal 20](#soal-20)</br>

## Soal 1

Untuk membantu pertempuran di **Erangel**, kamu ditugaskan untuk membuat jaringan komputer yang kan digunakan sebagai alat komunikasi. Sesuaikan rancangan **Topologi** dengan rancangan dan pembagian yang berada di link yang telah disediakan, dengan ketentuan nodenya sebagai berikut :

-   DNS Master akan diberi nama **Pochinki**, sesuai dengan kota tempat dibuatnya server tersebut
-   Karena ada kemungkinan musuh akan mencoba menyerang Server Utama, maka buatlah DNS Slave **Georgopol** yang mengarah ke Pochinki
-   Markas pusat juga meminta dibuatkan tiga Web Server yaitu **Severny, Stalber,** dan **Lipovka**. Sedangkan **Mylta** akan bertindak sebagai Load Balancer untuk server-server tersebut

## Penyelesaian

### Topologi

![Screenshot 2024-05-07 104720](https://github.com/samuelyuma/Jarkom-Modul-2-IT02-2024/assets/118542326/4109f846-3517-4365-9765-b6746124f224)

### Network Configuration

#### Erangel (Router)

```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.234.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.234.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.234.3.1
	netmask 255.255.255.0
```

#### Pochinki (DNS Master)

```
auto eth0
iface eth0 inet static
	address 192.234.3.2
	netmask 255.255.255.0
	gateway 192.234.3.1
```

#### Lipovka (Web Server)

```
auto eth0
iface eth0 inet static
	address 192.234.1.2
	netmask 255.255.255.0
	gateway 192.234.1.1
```

#### Stalber (Web Server)

```
auto eth0
iface eth0 inet static
	address 192.234.1.3
	netmask 255.255.255.0
	gateway 192.234.1.1
```

#### Severny (Web Server)

```
auto eth0
iface eth0 inet static
	address 192.234.1.4
	netmask 255.255.255.0
	gateway 192.234.1.1
```

#### Ruins (Client)

```
auto eth0
iface eth0 inet static
	address 192.234.2.2
	netmask 255.255.255.0
	gateway 192.234.2.1
```

#### Georgopol (DNS Slave)

```
auto eth0
iface eth0 inet static
	address 192.234.2.3
	netmask 255.255.255.0
	gateway 192.234.2.1
```

#### Mylta (Load Balancer)

```
auto eth0
iface eth0 inet static
	address 192.234.2.4
	netmask 255.255.255.0
	gateway 192.234.2.1
```

#### Apartments (Client)

```
auto eth0
iface eth0 inet static
	address 192.234.2.5
	netmask 255.255.255.0
	gateway 192.234.2.1
```

### Konfigurasi Tambahan

Perlu dilakukan konfigurasi pada node Erangel (Router) agar setiap node yang ada dalam jaringan dapat mengakses internet luar. Untuk itu, tambahkan command berikut pada node Erangel:

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.234.0.0/16
```

Selain itu, perlu dilakukan konfigurasi nameserver pada setiap node. Untuk itu, tambahkan line berikut pada file `/etc/resolv.conf` di semua node, (kecuali node Apartments dan Ruins):

```
nameserver 192.168.122.1
```

Khusus untuk node Apartments dan Ruins (Client), konfigurasi nameservernya adalah sebagai berikut:

```
nameserver 192.234.3.2 # IP Pochinki
nameserver 192.234.2.3 # IP Georgopol
```

## Soal 2

Karena para pasukan membutuhkan koordinasi untuk mengambil airdrop, maka buatlah sebuah domain yang mengarah ke Stalber dengan alamat **airdrop.xxxx.com** dengan alias **www.airdrop.xxxx.com** dimana xxxx merupakan kode kelompok

### Setup DNS pada DNS Master (Pochinki)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install bind9 -y
```

b. Menjalankan service dari bind9

```
service bind9 start
```

c. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "airdrop.it02.com" {
	type master;
	notify yes;
	file "/etc/bind/it02/airdrop.it02.com";
};
```

d. Membuat DNS record pada `/etc/bind/it02/airdrop.it02.com`

```
$TTL    604800
@       IN      SOA     airdrop.it02.com. root.airdrop.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@		IN      NS      airdrop.it02.com.
@		IN      A       192.234.1.3 ; IP Stalber
www		IN      CNAME   airdrop.it02.com.
```

e. Merestart service dari bind9

```
service bind9 restart
```

## Soal 3

Para pasukan juga perlu mengetahui mana titik yang sedang di bombardir artileri, sehingga dibutuhkan domain lain yaitu **redzone.xxxx.com** dengan alias **www.redzone.com** yang mengarah ke Severny

### Setup DNS pada DNS Master (Pochinki)

a. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "redzone.it02.com" {
	type master;
	notify yes;
	file "/etc/bind/it02/redzone.it02.com";
};
```

b. Membuat DNS record pada `/etc/bind/it02/airdrop.it02.com`

```
$TTL    604800
@       IN      SOA     redzone.it02.com. root.redzone.it02.com. (
                        2               ; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@       IN      NS      redzone.it02.com.
@       IN      A       192.234.1.4     ; IP Severny
www     IN      CNAME   redzone.it02.com.
```

c. Merestart service dari bind9

```
service bind9 restart
```

## Soal 4

Markas pusat meminta dibuatnya domain khusus untuk menaruh informasi persenjataan dan suplai yang tersebar. Informasi persenjataan dan suplai tersebut mengarah ke Mylta dan domain yang ingin digunakan adalah **loot.xxxx.com** dengan alias **www.loot.xxxx.com**

### Setup DNS pada DNS Master (Pochinki)

a. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "loot.it02.com" {
	type master;
	notify yes;
	file "/etc/bind/it02/loot.it02.com";
};
```

b. Membuat DNS record pada `/etc/bind/it02/airdrop.it02.com`

```
$TTL    604800
@       IN      SOA     loot.it02.com. root.loot.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@       IN      NS      loot.it02.com.
@       IN      A       192.234.2.4 ; IP MyIta
www     IN      CNAME   loot.it02.com.
```

c. Merestart service dari bind9

```
service bind9 restart
```

## Soal 5

Pastikan domain-domain tersebut dapat diakses oleh seluruh komputer (client) yang berada di Erangel

### Output

Pengujian dilakukan pada node Ruins dan Apartments (Client)

## Soal 6

Beberapa daerah memiliki keterbatasan yang menyebabkan **hanya dapat** mengakses domain secara langsung melalui **alamat IP** domain tersebut. Karena daerah tersebut tidak diketahui secara spesifik, pastikan semua komputer (client) dapat mengakses domain **redzone.xxxx.com** melalui **alamat IP** Severny

### Setup DNS pada DNS Master (Pochinki)

a. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "1.234.192.in-addr.arpa" {
	type master;
	file "/etc/bind/it02/1.234.192.in-addr.arpa";
};
```

b. Membuat DNS record pada `/etc/bind/it02/airdrop.it02.com`

```
$TTL    604800
@       IN      SOA     redzone.it02.com. root.redzone.it02.com. (
                        2               ; Serial
                        604800			; Refresh
                    	86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
1.234.192.in-addr.arpa. IN      NS      redzone.it02.com.
4                     	IN      PTR     redzone.it02.com.
```

c. Merestart service dari bind9

```
service bind9 restart
```

### Output

Pengujian dilakukan pada node Apartments (Client)

## Soal 7

Akhir-akhir ini seringkali terjadi serangan siber ke DNS Server Utama, sebagai tindakan antisipasi kamu diperintahkan untuk membuat DNS Slave di Georgopol untuk **semua domain** yang sudah dibuat sebelumnya

### Setup DNS pada DNS Master (Pochinki)

a. Edit konfigurasi zone `airdrop.it02.com`, `redzone.it02.com`, dan `loot.it02.com` pada file `etc/bind/named.conf.local` menjadi seperti berikut ini

```
zone "airdrop.it02.com" {
	type master;
	notify yes;
	also-notify { 192.234.2.3; }; // IP Georgopol
	allow-transfer { 192.234.2.3; }; // IP Georgopol
	file "/etc/bind/it02/airdrop.it02.com";
};

zone "redzone.it02.com" {
	type master;
	notify yes;
	also-notify { 192.234.2.3; }; // IP Georgopol
	allow-transfer { 192.234.2.3; }; // IP Georgopol
	file "/etc/bind/it02/redzone.it02.com";
};

zone "loot.it02.com" {
	type master;
	notify yes;
	also-notify { 192.234.2.3; }; // IP Georgopol
	allow-transfer { 192.234.2.3; }; // IP Georgopol
	file "/etc/bind/it02/loot.it02.com";
};
```

b. Merestart service dari bind9

```
service bind9 restart
```

### Setup DNS pada DNS Slave (Georgopol)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install bind9 -y
```

b. Menjalankan service dari bind9

```
service bind9 start
```

c. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "airdrop.it02.com" {
	type slave;
	masters { 192.234.3.2; }; // IP Pochinki
	file "var/lib/bind/airdrop.it02.com";
};

zone "redzone.it02.com" {
	type slave;
	masters { 192.234.3.2; }; // IP Pochinki
	file "var/lib/bind/redzone.it02.com";
};

zone "loot.it02.com" {
	type slave;
	masters { 192.234.3.2; }; // IP Pochinki
	file "var/lib/bind/loot.it02.com";
};
```

d. Merestart service dari bind9

```
service bind9 restart
```

## Soal 8

Kamu juga diperintahkan untuk membuat subdomain khusus melacak airdrop berisi peralatan medis dengan subdomain **medkit.airdrop.xxxx.com** yang mengarah ke Lipovka

### Setup DNS pada DNS Master (Pochinki)

a. Edit konfigurasi pada file `/etc/bind/it02/airdrop.it02.com` menjadi seperti berikut ini

```
$TTL    604800
@       IN      SOA     	airdrop.it02.com. root.airdrop.it02.com. (
                        	2				; Serial
                        	604800			; Refresh
                        	86400			; Retry
                        	2419200         ; Expire
                        	604800 )		; Negative Cache TTL
;
@			IN      NS      airdrop.it02.com.
@			IN      A       192.234.1.3 ; IP Stalber
www			IN      CNAME   airdrop.it02.com.
medkit		IN      A       192.234.1.2 ; IP Libovka
www.medkit	IN      CNAME   medkit.airdrop.it02.com.
```

b. Merestart service dari bind9

```
service bind9 restart
```

## Soal 9

Terkadang red zone yang pada umumnya di bombardir artileri akan dijatuhi bom oleh pesawat tempur. Untuk melindungi warga, kita diperlukan untuk membuat sistem peringatan air raid dan memasukkannya ke domain **siren.redzone.xxxx.com** dalam folder siren dan pastikan dapat diakses secara mudah dengan menambahkan alias **www.siren.redzone.xxxx.com** dan mendelegasikan subdomain tersebut ke Georgopol dengan alamat IP menuju radar di Severny

### Setup DNS pada DNS Master (Pochinki)

a. Edit file `/etc/bind/named.conf.options` menjadi seperti berikut ini

```
options {
    directory \"/var/cache/bind\";

    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0's placeholder.

	// forwarders {
	// 	192.168.122.1; // DNS Server
	// };

    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
    //========================================================================
    //dnssec-validation auto;
    allow-query {any;};

    auth-nxdomain no;
    listen-on-v6 { any; };
}
```

### Setup DNS pada DNS Slave (Georgopol)

a. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "siren.redzone.it02.com" {
	type master;
	allow-transfer { 192.234.3.2; }; // IP Pochinki
	file "/etc/bind/siren/siren.redzone.it02.com";
};
```

b. Membuat DNS record pada `/etc/bind/it02/airdrop.it02.com`

```
$TTL    604800
@       IN      SOA     siren.redzone.it02.com. root.siren.redzone.it02.com. (
						2				; Serial
						604800			; Refresh
						86400			; Retry
						2419200         ; Expire
						604800 )		; Negative Cache TTL
;
@       IN      NS      siren.redzone.it02.com.
@       IN      A       192.234.1.4 ; IP Severny
www     IN      CNAME   siren.redzone.it02.com.
```

c. Merestart service dari bind9

```
service bind9 restart
```

## Soal 10

Markas juga meminta catatan kapan saja pesawat tempur tersebut menjatuhkan bom, maka buatlah subdomain baru di subdomain siren yaitu **log.siren.redzone.xxxx.com** serta aliasnya **www.log.siren.redzone.xxxx.com** yang juga mengarah ke Severny

### Setup DNS pada DNS Slave (Georgopol)

a. Edit konfigurasi pada file `/etc/bind/siren/siren.redzone.it02.com` menjadi seperti berikut ini

```
$TTL    604800
@       IN      SOA     siren.redzone.it02.com. root.siren.redzone.it02.com. (
						2				; Serial
						604800			; Refresh
						86400			; Retry
						2419200         ; Expire
						604800 )		; Negative Cache TTL
;
@       IN      NS      siren.redzone.it02.com.
@       IN      A       192.234.1.4 ; IP Severny
www     IN      CNAME   siren.redzone.it02.com.
log     IN      A       192.234.1.4 ; IP Severny
www.log IN      CNAME   log.siren.redzone.it02.com.
```

b. Merestart service dari bind9

```
service bind9 restart
```

## Soal 11

Setelah pertempuran mereda, warga Erangel dapat kembali mengakses jaringan luar, tetapi **hanya** warga **Pochinki** saja yang dapat mengakses jaringan luar secara **langsung**. Buatlah konfigurasi agar warga Erangel yang berada diluar Pochinki dapat mengakses jaringan luar **melalui** DNS Server **Pochinki**

### Setup DNS pada DNS Master (Pochinki)

a. Edit file `/etc/bind/named.conf.options` menjadi seperti berikut ini

```
options {
    directory \"/var/cache/bind\";

    // If there is a firewall between you and nameservers you want
    // to talk to, you may need to fix the firewall to allow multiple
    // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

    // If your ISP provided one or more IP addresses for stable
    // nameservers, you probably want to use them as forwarders.
    // Uncomment the following block, and insert the addresses replacing
    // the all-0's placeholder.

	forwarders {
		192.168.122.1; // DNS Server
	};

    //========================================================================
    // If BIND logs error messages about the root key being expired,
    // you will need to update your keys.  See https://www.isc.org/bind-keys
    //========================================================================
    //dnssec-validation auto;
    allow-query {any;};

    auth-nxdomain no;
    listen-on-v6 { any; };
}
```

b. Merestart service dari bind9

```
service bind9 restart
```

## Soal 12

Karena pusat ingin sebuah website yang ingin digunakan untuk memantau kondisi markas lainnya maka deploy lah webiste ini (cek resource yg lb) pada **severny** menggunakan **apache**

### Setup website pada severny

a. Instalasi dependencies yang diperlukan 

```
apt-get update
apt-get install lynx apache2 php libapache2-mod-php7.0 wget unzip -y
```

b. Buat file `it02.conf` pada `/etc/apache2/sites-available/`

```
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/it02.conf
```

c. Hapus file `000-default.conf` pada `/etc/apache2/sites-enabled/` 

```
rm /etc/apache2/sites-enabled/000-default.conf
```

d. Edit file `it02.conf` pada `/etc/apache2/sites-available/` menjadi seperti berikut ini

```
<VirtualHost *:8080>
ServerAdmin webmaster@localhost
DocumentRoot /var/www/html
</VirtualHost>
```

e. Tambahkan `Listen 8080` pada `/etc/apache2/ports.conf/` menjadi seperti berikut ini

```
Listen 80
Listen 8080

<IfModule ssl_module>
    Listen 443
</IfModule>

<IfModule mod_gnutls.c>
    Listen 443
</IfModule>
```

f. Nyalakan situs web yang telah di konfigurasi pada `it02.conf`

```
a2ensite it02.conf
```

g. Unduh file `index.php`, dan letakkan pada `/var/www/html/`

```
$ mkdir -p /var/www/html/configuration/

$ wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O /var/www/html/configuration/lb.zip

$ unzip /var/www/html/configuration/lb.zip -d /var/www/html/configuration/

$ mv /var/www/html/configuration/worker/index.php /var/www/html/

$ rm -rf /var/www/html/configuration/
```

h. Nyalakan service apache


```
service apache2 start
```

i. Gunakan lynx untuk membuka website seperti berikut ini

```
lynx 192.234.1.4/index.php
```

## Soal 13

Tapi pusat merasa tidak puas dengan performanya karena traffic yag tinggi maka pusat meminta kita memasang load balancer pada web nya, dengan **Severny, Stalber, Lipovka** sebagai worker dan **Mylta** sebagai **Load Balancer** menggunakan apache sebagai web server nya dan load balancernya

### Setup worker pada Severny, Stalber, dan Lipovka

a. Instalasi dependencies yang diperlukan 

```
apt-get update
apt-get install lynx apache2 php libapache2-mod-php7.0 wget unzip -y
```

b. Buat file `it02.conf` pada `/etc/apache2/sites-available/`

```
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/it02.conf
```

c. Hapus file `000-default.conf` pada `/etc/apache2/sites-enabled/` 

```
rm /etc/apache2/sites-enabled/000-default.conf
```

d. Edit file `it02.conf` pada `/etc/apache2/sites-available/` menjadi seperti berikut ini

```
<VirtualHost *:8080>
ServerAdmin webmaster@localhost
DocumentRoot /var/www/html
</VirtualHost>
```

e. Tambahkan `Listen 8080` pada `/etc/apache2/ports.conf/` menjadi seperti berikut ini

```
Listen 80
Listen 8080

<IfModule ssl_module>
    Listen 443
</IfModule>

<IfModule mod_gnutls.c>
    Listen 443
</IfModule>
```

f. Nyalakan situs web yang telah di konfigurasi pada `it02.conf`

```
a2ensite it02.conf
```

g. Unduh file `index.php`, dan letakkan pada `/var/www/html/`


```
$ mkdir -p /var/www/html/configuration/

$ wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O /var/www/html/configuration/lb.zip

$ unzip /var/www/html/configuration/lb.zip -d /var/www/html/configuration/

$ mv /var/www/html/configuration/worker/index.php /var/www/html/

$ rm -rf /var/www/html/configuration/
```

h. Nyalakan service apache

```
service apache2 start
```

### Setup load balancer pada MyIta

a. Instalasi dependencies yang diperlukan 

```
apt-get update
apt-get install lynx apache2 -y
```

b. Nyalakan modul modul yang diperlukan

```
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer
a2enmod lbmethod_byrequests
```

c. Jalankan service apache

```
service apache2 start
```

d. Edit file `default-8080.conf` pada `/etc/apache2/sites-available/` menjadi seperti berikut ini

```
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
```

f. Nyalakan konfigurasi pada `it02.conf`

```
a2ensite it02.conf
```

g. restart service apache

```
service apache2 restart
```

## Soal 14

Mereka juga belum merasa puas jadi pusat meminta agar web servernya dan load balancer nya diubah menjadi nginx

### Setup worker pada Severny, Stalber, dan Lipovka

a. Instalasi dependencies yang diperlukan 

```
apt-get update
apt-get install dnsutils lynx nginx apache2 libapache2-mod-php7.0 wget unzip php php-fpm -y
```

b. nyalakan service php-fpm

```
service php7.0-fpm start
```

c. nyalakan service nginx

```
service nginx start
```

d. unduh `index.php` dan letakkan pada `/var/www/html/`

```
$ mkdir -p /var/www/html/configuration/

$ wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1xn03kTB27K872cokqwEIlk8Zb121HnfB' -O /var/www/html/configuration/lb.zip

$ unzip /var/www/html/configuration/lb.zip -d /var/www/html/configuration/

$ mv /var/www/html/configuration/worker/index.php /var/www/html/

$ rm -rf /var/www/html/configuration/
```

e. Edit file `it02` pada `/etc/nginx/sites-available/` menjadi seperti berikut ini

```
server {
    listen 8082;

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
```

f. buat symlink `it02` pada `/etc/nginx/sites-available/` di `/etc/nginx/sites-enabled`

```
ln -s /etc/nginx/sites-available/it02 /etc/nginx/sites-enabled
```

g. hapus `default` pada `/etc/nginx/sites-enabled/`

```
rm /etc/nginx/sites-enabled/default
```

h. Restart service nginx

```
service nginx restart
```

### Setup Load Balancer pada MyIta

a. Instalasi dependencies yang diperlukan 

```
apt-get update
apt-get install dnsutils nginx php-fpm php -y
```

b. nyalakan service php-fpm

```
service php7.0-fpm start
```

c. nyalakan service nginx

```
service nginx start
```

d. Edit file `it02` pada `/etc/nginx/sites-available/` menjadi seperti berikut ini
```
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
```

e. buat symlink `it02` pada `/etc/nginx/sites-available/` di `/etc/nginx/sites-enabled`

```
ln -s /etc/nginx/sites-available/it02 /etc/nginx/sites-enabled
```

f. hapus `default` pada `/etc/nginx/sites-enabled/`

```
rm /etc/nginx/sites-enabled/default
```

g. Restart service nginx

```
service nginx restart
```

## Soal 15

Markas pusat meminta laporan hasil benchmark dengan menggunakan apache benchmark dari load balancer dengan 2 web server yang berbeda tersebut dan meminta secara detail dengan ketentuan:

-   Nama Algoritma Load Balancer
-   Report hasil testing apache benchmark
-   Grafik request per second untuk masing masing algoritma.
-   Analisis

## Soal 16

Karena dirasa kurang aman karena masih memakai IP markas ingin akses ke mylta memakai **mylta.xxx.com** dengan alias **www.mylta.xxx.com** (sesuai web server terbaik hasil analisis kalian)

## Soal 17

Agar aman, buatlah konfigurasi agar **mylta.xxx.com** hanya dapat diakses melalui port 14000 dan 14400.

### Konfigurasi Nginx

Edit file `it02` pada `/etc/nginx/sites-available/` menjadi seperti berikut ini

```
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
```

## Soal 18

Apa bila ada yang mencoba mengakses IP mylta akan secara otomatis dialihkan ke **www.mylta.xxx.com**

### Konfigurasi Nginx

Edit file `it02` pada `/etc/nginx/sites-available/` menjadi seperti berikut ini

```
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
```

## Soal 19

Karena probset sudah kehabisan ide masuk ke **salah satu** worker buatkan akses direktori listing yang mengarah ke resource worker2

### Konfigurasi Nginx

Edit file `it02` pada `/etc/nginx/sites-available/` menjadi seperti berikut ini


```
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
```

## Soal 20

Worker tersebut harus dapat di akses dengan **tamat.xxx.com** dengan alias **www.tamat.xxx.com**

### Konfigurasi Nginx

Pengerjaan sama dengan nomor 19
