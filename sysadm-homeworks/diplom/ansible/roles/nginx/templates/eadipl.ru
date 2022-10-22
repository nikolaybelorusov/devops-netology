server {
        listen 80;
#        listen [::]:443 ssl ;

#        server_name eadipl.ru;
#        ssl_certificate /etc/nginx/ssl/eadipl.ru/fullchain.pem;
#        ssl_certificate_key /etc/nginx/ssl/eadipl.ru/privkey.pem;
#        ssl_trusted_certificate /etc/nginx/ssl/eadipl.ru/fullchain.pem;
        root /var/www/eadipl.ru/html;
        index index.html index.htm index.nginx-debian.html;

        server_name eadipl.ru www.eadipl.ru;

        location / {
                try_files $uri $uri/ =404;
        }
}

#server {
#        server_name eadipl.ru www.eadipl.ru;
#        listen 443 ssl;
#        listen [::]:443 ssl ;

#        server_name eadipl.ru;
#        ssl_certificate /etc/letsencrypt/certs/fullchain_eadipl.pem;
#        ssl_certificate_key /etc/letsencrypt/keys/eadipl.ru.key;
#        ssl_trusted_certificate /etc/letsencrypt/certs/chain_eadipl.ru.pem;
#        ssl_certificate /etc/nginx/ssl/eadipl.ru/fullchain.pem;
#        ssl_certificate_key /etc/nginx/ssl/eadipl.ru/privkey.pem;
#        ssl_trusted_certificate /etc/nginx/ssl/eadipl.ru/fullchain.pem;
#        ssl_stapling on;
#        ssl_stapling_verify on;
#        resolver ns1.yandexcloud.net ns2.yandexcloud.net;



#        root /var/www/eadipl.ru/html;
#        index index.html index.htm index.nginx-debian.html;

#        server_name eadipl.ru www.eadipl.ru;

#        location / {
#                try_files $uri $uri/ =404;
#        }
#}
