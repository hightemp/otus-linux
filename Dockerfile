FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/
COPY index.html /var/www/localhost/htdocs/
RUN mkdir -p /run/nginx
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
