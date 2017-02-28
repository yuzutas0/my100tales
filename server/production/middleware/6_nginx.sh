#!/bin/bash

# ================================
# variables
# ================================

root_url=$1
app_name=$2
domain_name=$3

# ================================
# install
# ================================

su

yum -y install nginx

systemctl start nginx
systemctl enable nginx

systemctl status nginx
# check active

# access by browser at local machine
open ${root_url}
less /etc/nginx/nginx.conf

# ================================
# settings for HTTP
# ================================

vim /etc/nginx/conf.d/${app_name}.conf
#  upstream unicorn_server {
#    server unix:/var/www/${app_name}/shared/tmp/sockets/unicorn.sock fail_timeout=0;
#  }
#
#  server_tokens off;
#  add_header X-Frame-Options SAMEORIGIN;
#  add_header X-Content-Type-Options nosniff;
#
#  server {
#    set $app ${app_name};
#    listen 80;
#    listen [::]:80;
#    server_name ${domain_name};
#
#    root /var/www/$app/current/public;
#
#    error_page 404 /404.html;
#    error_page 422 /422.html;
#    error_page 400 401 403 500 501 502 503 504 /500.html;
#
#    gzip on;
#    gzip_proxied any;
#    gzip_min_length 1k;
#    gzip_types text/html text/css text/javascript application/x-javascript;
#
#    location ~* \.php$ {
#      deny all;
#    }
#
#    location / {
#      try_files $uri @unicorn;
#    }
#
#    location @unicorn {
#      proxy_set_header X-Real-IP $remote_addr;
#      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#      proxy_set_header Host $http_host;
#      proxy_pass http://unicorn_server;
#    }
#  }
#
#  server {
#    listen 80;
#    listen [::]:80;
#    server_name _;
#    error_page 403 404 500 503 = /custom_404.html;
#
#    location / {
#      deny all;
#    }
#
#    location /custom_404.html {
#      return 404 "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html><head>\n<title>404 Not Found</title>\n</head><body>\n<h1>Not Found</h1>\n<p>The requested URL $request_uri was not found on this server.</p>\n</body></html>";
#      internal;
#    }
#  }

systemctl reload nginx

# ================================
# settings for HTTPs
# ================================

# after settings about lets encrypt

rm /etc/nginx/conf.d/${app_name}.conf
vim /etc/nginx/conf.d/${app_name}.conf
#  upstream unicorn_server {
#    server unix:/var/www/${app_name}/shared/tmp/sockets/unicorn.sock fail_timeout=0;
#  }
#
#  server_tokens off;
#  add_header X-Frame-Options SAMEORIGIN;
#  add_header X-Content-Type-Options nosniff;
#
#  server {
#    listen 80;
#    listen [::]:80;
#    server_name ${domain_name};
#    return 301 https://$host$request_uri;
#  }
#
#  server {
#    set $app ${app_name};
#    listen 443 ssl;
#    listen [::]:443 ssl;
#    server_name ${domain_name};
#
#    ssl on;
#    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
#    ssl_prefer_server_ciphers on;
#    ssl_ciphers ECDHE+RSAGCM:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!EXPORT:!DES:!3DES:!MD5:!DSS;
#
#    ssl_certificate /etc/letsencrypt/live/${domain_name}/fullchain.pem;
#    ssl_certificate_key /etc/letsencrypt/live/${domain_name}/privkey.pem;
#    ssl_trusted_certificate /etc/letsencrypt/live/${domain_name}/cert.pem;
#
#    root /var/www/$app/current/public;
#
#    error_page 404 /404.html;
#    error_page 422 /422.html;
#    error_page 400 401 403 500 501 502 503 504 /500.html;
#
#    gzip on;
#    gzip_proxied any;
#    gzip_min_length 1k;
#    gzip_types text/css text/javascript application/x-javascript;
#
#    location ~* \.php$ {
#      deny all;
#    }
#
#    location / {
#      try_files $uri @unicorn;
#    }
#
#    location @unicorn {
#      proxy_set_header X-Real-IP $remote_addr;
#      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#      proxy_set_header X-Forwarded-Proto https;
#      proxy_set_header Host $http_host;
#      proxy_pass http://unicorn_server;
#    }
#  }
#
#  server {
#    listen 80 default_server;
#    listen [::]:80 default_server;
#    server_name _;
#    error_page 400 401 403 404 500 501 502 503 504 = /custom_404.html;
#
#    location / {
#      deny all;
#    }
#
#    location /custom_404.html {
#      return 404 "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL was not found on this server.</p>\n</body>\n</html>";
#      internal;
#    }
#  }
#
#  server {
#    listen 443 ssl default_server;
#    listen [::]:443 ssl default_server;
#    server_name _;
#
#    ssl on;
#    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
#    ssl_prefer_server_ciphers on;
#    ssl_ciphers ECDHE+RSAGCM:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!EXPORT:!DES:!3DES:!MD5:!DSS;
#
#    ssl_certificate /etc/letsencrypt/live/${domain_name}/fullchain.pem;
#    ssl_certificate_key /etc/letsencrypt/live/${domain_name}/privkey.pem;
#    ssl_trusted_certificate /etc/letsencrypt/live/${domain_name}/cert.pem;
#
#    error_page 400 401 403 404 500 501 502 503 504 = /custom_404.html;
#
#    location / {
#      deny all;
#    }
#
#    location /custom_404.html {
#      return 404 "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n<html>\n<head>\n<title>404 Not Found</title>\n</head>\n<body>\n<h1>Not Found</h1>\n<p>The requested URL was not found on this server.</p>\n</body>\n</html>";
#      internal;
#    }
#  }

vim /etc/nginx/nginx.conf
# --------------------------------------------------
# from:
# --------------------------------------------------
#    server {
#        listen       80 default_server;
#        listen       [::]:80 default_server;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        location / {
#        }
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }
# --------------------------------------------------
# to:
# --------------------------------------------------
# #    server {
# #        listen       80 default_server;
# #        listen       [::]:80 default_server;
# #        server_name  _;
# #        root         /usr/share/nginx/html;
# #
# #        # Load configuration files for the default server block.
# #        include /etc/nginx/default.d/*.conf;
# #
# #        location / {
# #        }
# #
# #        error_page 404 /404.html;
# #            location = /40x.html {
# #        }
# #
# #        error_page 500 502 503 504 /50x.html;
# #            location = /50x.html {
# #        }
# #    }

systemctl reload nginx
