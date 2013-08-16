#!/bin/bash

bind=/etc/authbind/byport
user=master
fp=/home/${user}/fp_server
cert=/etc/ssl/fp

echo == Remove fp server
rm -R ${fp}

echo == Remove components
apt-get -yqq remove openssl libapr1-dev libssl-dev authbind apache2

echo == Remove web-server configs
rm /etc/apache2/sites-available/fpweb*
rm /etc/apache2/sites-enabled/fpweb*
rm -R ${cert}

echo == Remove authbind configs
for port in 80 443
do
	rm ${bind}/${port}
done
