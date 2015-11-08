FROM andyfurnival/centos:master

MAINTAINER Andy Furnival

ENV NGINX_VERSION 1.9.6

# Install Nginx.
RUN yum install openssl-devel -y

RUN yum install gcc gcc-c++ make -y


RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar -xzvf nginx-${NGINX_VERSION}.tar.gz


RUN cd nginx-${NGINX_VERSION} \
  && ./configure \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/local/sbin \
    --conf-path=/etc/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
#    --with-http_ssl_module \
    --with-http_v2_module \
    --with-openssl=/usr \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-ipv6 \
  && make \
  && make install


#turn nginx daemon off
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

RUN yum clean all

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# add management scripts
ADD startup.sh /startup.sh
RUN chmod 755 /startup.sh
ADD restart.sh /restart.sh
RUN chmod 755 /restart.sh

EXPOSE 80

CMD /startup.sh