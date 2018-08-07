FROM centos:latest

MAINTAINER "tujuhion" <yanwar.purnama@gmail.com>

ENV container docker

# UPDATE
RUN yum -y install epel-release wget
RUN yum -y update
RUN rpm -ivh http://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el7.noarch.rpm

#Install Proftpd
RUN yum -y install proftpd
RUN sed -i "s/ProFTPD server/$HOSTNAME/g" /etc/proftpd.conf

#Install Openlitespeed
RUN mkdir /home/defdomain
RUN mkdir /home/defdomain/html
RUN mkdir /home/defdomain/logs

RUN yum -y install openlitespeed

#Install MariaDB
ADD repo/MariaDB.repo /etc/yum.repos.d/MariaDB.repo
RUN yum -y install MariaDB-server MariaDB-client

# Install PHP 56
RUN yum -y install lsphp56 lsphp56-common lsphp56-mysqlnd lsphp56-process lsphp56-gd lsphp56-mbstring lsphp56-mcrypt lsphp56-opcache lsphp56-bcmath lsphp56-pdo lsphp56-xml lsphp56-json lsphp56-zip lsphp56-xmlrpc lsphp56-pecl-mcrypt
#Setting Up
RUN mv -f /usr/local/lsws/conf/vhosts/Example/ /usr/local/lsws/conf/vhosts/defdomain/
RUN rm -f /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
RUN rm -f /usr/local/lsws/conf/httpd_config.conf
RUN rm -f /usr/local/lsws/admin/conf/admin_config.conf

ADD conf/vhconf.conf /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
ADD conf/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
ADD conf/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf
ADD file/index.php /home/defdomain/html/index.php

RUN chown lsadm:lsadm /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
RUN chown lsadm:lsadm /usr/local/lsws/conf/httpd_config.conf
RUN chown lsadm:lsadm /usr/local/lsws/admin/conf/admin_config.conf
RUN chown -R nobody:nobody /home/defdomain/html/

# make sure firewall
EXPOSE 21
EXPOSE 80
EXPOSE 443
EXPOSE 7080

RUN systemctl enable proftpd
CMD ["/usr/sbin/init"]
ENTRYPOINT /usr/local/lsws/bin/lswsctrl start && /etc/init.d/mysql start && /bin/bash

