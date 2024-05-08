echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

service bind9 start

echo '
// Soal 2 & Soal 7
zone "airdrop.it02.com" {
	type master;
	notify yes;
	also-notify { 192.234.2.3; }; // IP Georgopol
	allow-transfer { 192.234.2.3; }; // IP Georgopol
	file "/etc/bind/it02/airdrop.it02.com";
};

// Soal 3 & Soal 7
zone "redzone.it02.com" {
	type master;
	notify yes;
	also-notify { 192.234.2.3; }; // IP Georgopol
	allow-transfer { 192.234.2.3; }; // IP Georgopol
	file "/etc/bind/it02/redzone.it02.com";
};

// Soal 4 & Soal 7
zone "loot.it02.com" {
	type master;
	notify yes;
	also-notify { 192.234.2.3; }; // IP Georgopol
	allow-transfer { 192.234.2.3; }; // IP Georgopol
	file "/etc/bind/it02/loot.it02.com";
};

// Soal 6
zone "1.234.192.in-addr.arpa" {
	type master;
	file "/etc/bind/it02/3.68.10.in-addr.arpa";
};

// Soal 16
zone "mylta.it02.com" {
 		type master;
 		file "/etc/bind/it02/mylta.it02.com";
 };
'> /etc/bind/named.conf.local

mkdir /etc/bind/it02

cp /etc/bind/db.local /etc/bind/it02/airdrop.it02.com # Soal 2
cp /etc/bind/db.local /etc/bind/it02/redzone.it02.com # Soal 3
cp /etc/bind/db.local /etc/bind/it02/loot.it02.com # Soal 4

cp /etc/bind/db.local /etc/bind/it02/1.234.192.in-addr.arpa # Soal 6

echo '
; BIND data file for Airdrop domain to Stalber (Soal 2)
$TTL    604800
@       IN      SOA     airdrop.it02.com. root.airdrop.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@			IN      NS      airdrop.it02.com.
@			IN      A       192.234.1.3 ; IP Stalber
www			IN      CNAME   airdrop.it02.com.
; Soal 8
medkit		IN      A       192.234.1.2 ; IP Libovka
www.medkit	IN      CNAME   medkit.airdrop.it02.com.
' > /etc/bind/it02/airdrop.it02.com

echo '
; BIND data file for Loot domain to Mylta (Soal 4)
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
' > /etc/bind/it02/loot.it02.com

echo '
; BIND data file for reverse DNS to Severny (Soal 6)
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
' > /etc/bind/it02/3.68.10.in-addr.arpa

echo ';
; BIND data file for Redzone & Siren domain that will be delegated to Georgopol with IP Address to Severny (Soal 3 & 9)
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
ns1     IN      A       192.234.2.3     ; IP Georgopol
siren   IN      NS      ns1
' > /etc/bind/it02/redzone.it02.com

echo '
; BIND data file for Mylta domain to Mylta (Soal 16)
$TTL    604800
@       IN      SOA     mylta.it02.com. root.mylta.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@       IN      NS      mylta.it02.com.
@       IN      A       192.234.2.4 ; IP MyIta
www     IN      CNAME   mylta.it02.com.
' > /etc/bind/it02/mylta.it02.com

# Soal 9 & 11
echo "
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
};" > /etc/bind/named.conf.options

service bind9 restart