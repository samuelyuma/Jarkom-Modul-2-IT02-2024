echo 'nameserver 192.168.122.1' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

service bind9 start

echo '
// Soal 7
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

// Soal 9
zone "siren.redzone.it02.com" {
	type master;
	allow-transfer { 192.234.3.2; }; // IP Pochinki
	file "/etc/bind/siren/siren.redzone.it02.com";
};
' > /etc/bind/named.conf.local

mkdir /etc/bind/siren

cp /etc/bind/db.local /etc/bind/siren/siren.redzone.it02.com

echo '
; BIND data file for Siren domain to Lipovka (Soal 9 & 10)
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
; Soal 10
log     IN      A       192.234.1.4 ; IP Severny
www.log IN      CNAME   log.siren.redzone.it02.com.
' > /etc/bind/siren/siren.redzone.it02.com

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
    //      0.0.0.0;
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