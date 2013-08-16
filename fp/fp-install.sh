#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 <server.zip>"
    exit 1
fi

bind=/etc/authbind/byport
user=master
fp=/home/${user}/fp_server
cert=/etc/ssl/fp
fpzip=${1}

echo == Unpack fp server
mkdir ${fp}
unzip -q ${fpzip} -d ${fp}

echo == Install required components
apt-get -yqq install openssl libapr1-dev libssl-dev authbind libtcnative-1 apache2

echo == Setup web-server
cp apache/sites/* /etc/apache2/sites-available
if [ ! -f /etc/apache2/ports.conf.bak ]; then
    cp /etc/apache2/ports.conf /etc/apache2/ports.conf.bak
fi
cp -f apache/ports.conf /etc/apache2/
mkdir ${cert}
cp cert/* ${cert}
a2enmod ssl proxy_ajp
a2dissite default
a2ensite fpweb*

echo == Setup authbind
for port in 80 443
do
	touch ${bind}/${port}
	chown ${user}:${user} ${bind}/${port}
	chmod 755 ${bind}/${port}
done

echo == Set permissions
chown -R ${user}:${user} ${fp}
chmod -R 644 ${fp}
chmod -R u+X ${fp}
find ${fp} -regex '\(.+/bin/[-_a-zA-Z0-9]+\)\|\(.+/[-_a-zA-Z0-9]+\.sh\)' -type f -exec chmod +x '{}' ';'

echo == Restart web-server
service apache2 restart

echo == Install complete
echo "Now run tomcat with 'startup_with_authbind.sh' as user '${user}'"
