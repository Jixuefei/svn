#!/bin/bash
#部署LNMP脚本
hostnamectl set-hostname $1
rm -rf /etc/yum.repos.d/*
echo"[jxf]
name=jxf
baseurl=ftp://201.1.$2.254/rhel7
enabled=1
gpgcheck=0" > /etc/yum.repos.d/jxf.repo
yum repolist
tar -xf /root/lnmp_soft.tar.gz -C /root
tar -xf /root/lnmp_soft/nginx-1.12.2.tar.gz  -C /root
cd /root/lnmp_soft
yum -y install gcc pcre-devel openssl-devel  mariadb-server mariadb-devel mariadb memcached php php-mysql php-fpm-5.4.16-42.el7.x86_64.rpm php-pecl-memcache.x86_64
cd /root/nginx-1.12.2
./configure --with-http_ssl_module --with-stream --with-http_stub_status_module
make && make install
ln -s /usr/local/nginx/sbin/nginx /sbin

systemctl restart mariadb
systemctl restart php-fpm
systemctl restart memcached

sed -i '65,68s/#//' /usr/local/nginx/conf/nginx.conf
sed -i '70,71s/#//' /usr/local/nginx/conf/nginx.conf
sed -ri 's/\_params/\.conf/' /usr/local/nginx/conf/nginx.conf
 nginx

ss -aupltn | grep :80
ss -aupltn | grep :9000
ss -aupltn | grep :3306




