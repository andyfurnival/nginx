FROM andyfurnival/centos:master

MAINTAINER Andy Furnival

RUN yum localinstall -y http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm

# Install Nginx.
RUN yum install openssl -y
RUN yum install --disablerepo="*" --enablerepo=nginx install nginx -y

# We need tar
RUN yum --disablerepo="*" --enablerepo=base install tar -y

#turn nginx daemon off
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN yum clean all

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log


VOLUME  ["/opt"]
RUN mkdir /opt/static

ADD ./nginx.static.conf /etc/nginx/conf.d/default.conf


EXPOSE 80
