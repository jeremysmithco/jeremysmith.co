---
title: DRYing up Nginx configurations
date: 2017-01-16 22:08 UTC
tags:
---

I have a web server that hosts quite a few [Middleman](https://middlemanapp.com/) sites via Nginx. Since the sites are very similar, their Nginx configuration is largely the same. I recently moved common configurations into a separate include file, which has made it easier to understand the differences between site configuration files, and has simplified making changes that should apply across all sites.

Below is an example site configuration file, `sites-available/domain1.conf`. I'm using [Let's Encrypt](https://letsencrypt.org/) for SSL certs, so you'll see the first server block listens on port 80 and redirects to HTTPS, which has the SSL certificate config.

```
server {
    listen 80;
    server_name www.domain1.org domain1.org;
    rewrite ^(.*) https://www.domain1.org$1 permanent;
}

server {
    listen 443;
    server_name  www.domain1.org;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/www.domain1.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.domain1.org/privkey.pem;

    root /var/www/domain1.org;
    access_log /opt/nginx/logs/domain1-access.log main;

    # rewrite rules
    rewrite ^/order$ http://www.store1.org last;

    include /opt/nginx/conf/includes/shared.conf;
}
```

I have a file like the above for each site, with slightly different settings for the domain, SSL certificate location, redirects, etc.

The include file, `includes/shared.conf`, contains all the shared configuration, including routing Let's Encrypt `acme-challenge` requests to a separate shared root folder used by [certbot](https://certbot.eff.org/) for certificate renewals.

```
location = /favicon.ico {
  expires    max;
  add_header Cache-Control public;
}

error_page  404             /404/;
error_page 500 502 503 504  /500/;

client_max_body_size 4G;
keepalive_timeout 10;

location /.well-known/acme-challenge {
  default_type "text/plain";
  root /var/www/letsencrypt;
}
```
