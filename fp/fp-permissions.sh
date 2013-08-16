#!/bin/bash

user=master
fp=/home/${user}/fp_server

chown -R ${user}:${user} ${fp}
chmod -R 644 ${fp}
chmod -R u+X ${fp}
find ${fp} -regex '\(.+/bin/[-_a-zA-Z0-9]+\)\|\(.+/[-_a-zA-Z0-9]+\.sh\)' -type f -exec chmod +x '{}' ';'
