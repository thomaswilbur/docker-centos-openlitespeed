FROM centos:latest

MAINTAINER "Thomas Wilbur" <thomaswilbur@adaclare.com>

ENV container docker

# UPDATE
RUN yum -y install epel-release wget
RUN yum -y update
RUN rpm -ivh http://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el7.noarch.rpm


#Install Openlitespeed
RUN mkdir /home/defdomain
RUN mkdir /home/defdomain/html
RUN mkdir /home/defdomain/logs

RUN yum -y install openlitespeed


# Install PHP 72
RUN yum -y install lsphp72 lsphp72-common lsphp72-mysqlnd lsphp72-process lsphp72-gd lsphp72-mbstring lsphp72-mcrypt lsphp72-opcache lsphp72-bcmath lsphp72-pdo lsphp72-xml lsphp72-json lsphp72-zip lsphp72-xmlrpc lsphp72-pecl-mcrypt

#Setting Up
RUN mv -f /usr/local/lsws/conf/vhosts/Example/ /usr/local/lsws/conf/vhosts/defdomain/
RUN rm -f /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
RUN rm -f /usr/local/lsws/conf/httpd_config.conf
RUN rm -f /usr/local/lsws/admin/conf/admin_config.conf

ADD conf/vhconf.conf /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
ADD conf/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
ADD conf/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf
COPY httpdocs /home/defdomain/html

RUN chown lsadm:lsadm /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
RUN chown lsadm:lsadm /usr/local/lsws/conf/httpd_config.conf
RUN chown lsadm:lsadm /usr/local/lsws/admin/conf/admin_config.conf
RUN chown -R nobody:nobody /home/defdomain/html/

EXPOSE 80
EXPOSE 443
EXPOSE 7080

CMD ["/usr/sbin/init"]
ENTRYPOINT /usr/local/lsws/bin/lswsctrl start

