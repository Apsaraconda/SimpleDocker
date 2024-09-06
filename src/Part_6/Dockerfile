FROM ubuntu:20.04
LABEL maintainer="gigantag"
RUN useradd -rm -d /home/nginx -s /bin/bash -g root -u 1001 nginx; \
    apt-get update && apt-get install -y gcc nginx libfcgi libfcgi-dev spawn-fcgi; \
    chown -R nginx /etc/nginx/nginx.conf; \
    chown -R nginx /var/log/nginx/; \
    chown -R nginx /usr/sbin/nginx; \
    chown -R nginx /usr/lib/nginx; \
    chown -R nginx /etc/nginx; \
    chown -R nginx /usr/share/nginx; \
    chown -R nginx /home/nginx; \
    chown -R nginx /var/lib/nginx; \
    touch /var/run/nginx.pid; \
    chown -R nginx /var/run/nginx.pid; \
    rm -rf /var/lib/apt/lists
WORKDIR /home/nginx
COPY ./nginx.conf /etc/nginx/
USER nginx
ENTRYPOINT nginx -g "daemon off;"
HEALTHCHECK CMD [ "service", "nginx", "status"]