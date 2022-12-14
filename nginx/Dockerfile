FROM registry.access.redhat.com/ubi7/ubi

WORKDIR /nginx

COPY /files/repo/nginx.repo /etc/yum.repos.d

# Installing Nginx
RUN yum update -y && yum install -y nginx
# Symlinking nginx logs to stdout and stderr for docker log collection
RUN set -x \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
#Copying in nginx.conf file

COPY nginx.conf /etc/nginx/nginx.conf

COPY /files/includes/. /etc/nginx/includes/

COPY /files/ssl/. /etc/ssl/certs/nginx/
# Default command to run our server!
CMD ["nginx", "-g", "daemon off;"]
