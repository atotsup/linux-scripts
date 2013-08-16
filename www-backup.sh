#!/bin/bash

www=/var/www
backup=/var/backups/www/www

for d in `ls ${www}`
do
    (cd ${www} && XZ_OPT=-9 tar cJpf ${backup}/${d}.tar.xz --exclude=*.zip --exclude=*.exe --exclude=*.log --exclude=*.jpa ${d} && echo $d compressed)
done
