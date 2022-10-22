server {
        listen 80 default_server;
        root /var/www/html;
        index index.html index.htm index.php index.nginx-debian.html;

        server_name www.eadipl.ru;
        location = /favicon.ico {
                log_not_found off;
                access_log off;
        }
        location / {
                try_files $uri $uri/ /index.php?q=$uri$args;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                include fastcgi_params;
                fastcgi_intercept_errors on;
                fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }
        location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                expires max;
                log_not_found off;
        }
}

