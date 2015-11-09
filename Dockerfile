FROM andyfurnival/centos:master

MAINTAINER Andy Furnival

ENV NGINX_VERSION 1.9.6

# Install Nginx.
RUN yum install openssl-devel -y

RUN yum install gcc gcc-c++ make -y

RUN yum clean all

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
    --with-http_ssl_module \
    --with-http_v2_module \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-threads \
    --with-ipv6 \
  && make \
  && make install

RUN useradd -r -M -d /usr/local/sbin/nginx -s /sbin/nologin nginx


RUN rm /etc/nginx/nginx.conf
ADD ./nginx.conf /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/sites-enabled

ADD ./ssl/server.crt /etc/nginx/ssl/certificate.crt
ADD ./ssl/server.key /etc/nginx/ssl/certificate.key


RUN chown nginx:nginx /etc/nginx/
RUN chown nginx:nginx /etc/nginx/*

EXPOSE 80 443

CMD /usr/local/sbin/nginx