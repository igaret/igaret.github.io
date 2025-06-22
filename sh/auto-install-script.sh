#!/data/data/com.termux/files/usr/bin/bash
yes | apt install dotnet-runtime-8.0 dotnet-host dotnet-apphost dotnet-apphost-pack-8.0 dotnet-sdk-8.0 wget tsu -y
wget https://download.technitium.com/dns/DnsServerPortable.tar.gz -o dns.tar.gz
mkdir dns
mv dns.tar.gz dns/
cd dns
gunzip --uncompress dns.tar.gz
mkdir $PREFIX/opt/technitium -p
cp -r dns $PREFIX/opt/technitium/
echo \#\!/bin/sh > /data/data/com.termux/files/usr/opt/technitium/dns/start.sh 
echo /data/data/com.termux/files/usr/bin/dotnet /data/data/com.termux/files/usr/opt/technitium/dns/DnsServerApp.dll >> /data/data/com.termux/files/usr/opt/technitium/dns/start.sh 
ln -sf /data/data/com.termux/files/usr/opt/technitium/dns/start.sh /data/data/com.termux/files/usr/bin/svc-technitium-start
/data/data/com.termux/files/usr/bin/svc-technitium-start
am start http://localhost:5380/
