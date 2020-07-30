# Judgr
A sandboxed Ruby on Rails online judge.

![Judgr App screenshot](https://raw.githubusercontent.com/patricksongzy/judgr/master/images/judgr.png)

## Deploy
Deployed on an Azure VM, using Nginx. Used TLS 1.2, and 1.3, and a Let's Encrypt certificate.

The following environment variables must be set:
```
SECRET_KEY_BASE
RAILS_SERVE_STATIC_FILES=true
JUDGR_DATABASE_PASSWORD
EMAIL_USER
EMAIL_PASS
GOOGLE_APPLICATION_CREDENTIALS
HOST_NAME
```

If the judge will be run for private competitions, to avoid abuse, a whitelist environment variable can be specified as `JUDGR_EMAILS`.
Only whiltelisted emails will then be able to sign up.

Obtain a certificate from Let's Encrypt to begin.

The following Nginx configuration should be used. The configuration forces https, which is critical, as user login are being done.
Passwords are hashed, and managed using a Ruby Gem to ensure security.

```
upstream app {
    server unix:///tmp/judgr.sock fail_timeout=0;
}

server {
    listen 443 ssl;
    server_name [ADDRESS];
    ssl_trusted_certificate /etc/letsencrypt/live/[ADDRESS]/chain.pem;
    ssl_certificate /etc/letsencrypt/live/[ADDRESS]/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/[ADDRESS]/privkey.pem;

    # CertBot
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    root [PATH_TO_SITE];

    try_files $uri/index.html $uri @app;

    location @app {
        proxy_pass http://app;
	proxy_set_header X-Forwarded-Proto https;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header Host $http_host;
	proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}

server {
    if ($host == [ADDRESS]) {
        return 301 https://$host$request_uri;	
    }

    listen 80;
    server_name [ADDRESS];
    return 404;
}
```

Some good ciphers to use are TLS 1.2, and TLS 1.3 elliptic curve ciphers. 

## Dependencies
* bubblewrap
* libmagic
* bash, find, readlink, grep
* gcc
* Java
* Python
* Ruby (on Rails)
