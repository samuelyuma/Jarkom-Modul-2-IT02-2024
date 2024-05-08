apt-get update
apt-get install dnsutils lynx -y

echo '
nameserver 192.234.3.2 # IP Pochinki
nameserver 192.234.2.3 # IP Georgopol
' > /etc/resolv.conf
