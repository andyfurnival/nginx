#!/bin/sh


NGINX=/usr/local/sbin/nginx

# show Version and compile config
$NGINX -V

$NGINX &

# test config
#$NGINX -t

#$NGINX -g "daemon off;"