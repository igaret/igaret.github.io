#!/bin/sh


if [ -d "$PREFIX/etc/dns/config" ]
then
    dnsDir="$PREFIX/etc/dns"
else
    dnsDir="$PREFIX/opt/technitium/dns"
fi

dnsConfig="$PREFIX/etc/dns"
dnsTar="$dnsDir/DnsServerPortable.tar.gz"
dnsUrl="https://download.technitium.com/dns/DnsServerPortable.tar.gz"

installLog="$dnsDir/install.log"

echo ""
echo "==============================="
echo "Technitium DNS Server Installer"
echo "==============================="
echo ""
echo "Downloading Technitium DNS Server..."
echo ""
yes | apt install dotnet-runtime-8.0 dotnet-host dotnet-apphost-pack-8.0 dotnet-sdk-8.0 daemonize > $installLog
echo "" >> $installLog


if [ -d $dnsConfig ]
then
    echo "Updating Technitium DNS Server..."
else
    echo "Installing Technitium DNS Server..."
fi

tar -zxf $dnsTar -C $dnsDir >> $installLog 2>&1

echo ""

if dotnet $dnsDir/DnsServerApp.dll --icu-test >> $installLog 2>&1
then
    echo "ICU package is already installed."
else
    echo "Checking for required ICU package..."

    if command -v apt-get >/dev/null 2>&1; then
        # Debian/Ubuntu based
        if ! dpkg -l | grep -q "libicu"; then
            echo "Installing required ICU package..."
            apt-get update >> $installLog 2>&1

            # Try to install the most common package name
            if apt-cache show libicu74 >/dev/null 2>&1; then
                echo "Installing libicu74 package..."
                apt-get install -y libicu74 >> $installLog 2>&1
            elif apt-cache show libicu72 >/dev/null 2>&1; then
                echo "Installing libicu72 package..."
                apt-get install -y libicu72 >> $installLog 2>&1
            elif apt-cache show libicu70 >/dev/null 2>&1; then
                echo "Installing libicu70 package..."
                apt-get install -y libicu70 >> $installLog 2>&1
            else
                # Fallback to a generic approach
                echo "No specific libicu package was found, trying generic installation..."
                apt-get install -y libicu* >> $installLog 2>&1
            fi
        fi
    else
        echo "Failed to install Technitium DNS Server: could not determine package manager to install ICU package. Please install ICU package manually and try again."
        echo "Please read the 'Missing ICU Package' section in this blog post to understand how to manually install the ICU package for your distro: https://blog.technitium.com/2017/11/running-dns-server-on-ubuntu-linux.html"
        exit 1
    fi

    #test again to confirm
    if dotnet $dnsDir/DnsServerApp.dll --icu-test >> $installLog 2>&1
    then
        echo "ICU package was installed successfully!"
    else
        echo "Failed to install Technitium DNS Server: failed to install ICU package. Please install ICU package manually and try again."
        echo "Please read the 'Missing ICU Package' section in this blog post to understand how to manually install the ICU package for your distro: https://blog.technitium.com/2017/11/running-dns-server-on-ubuntu-linux.html"
        exit 1
    fi
fi

echo ""


echo ""
echo "Technitium DNS Server was installed successfully!"
echo "Open http://$(hostname):5380/ to access the web console."
echo ""
echo "Donate! Make a contribution by becoming a Patron: https://www.patreon.com/technitium"
echo ""
