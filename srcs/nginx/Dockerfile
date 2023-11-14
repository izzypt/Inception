# This Dockerfile generates SSL/TLS certificates, 
# copies a script to handle certificate setup,  

FROM debian:buster

# Install NGINX
RUN apt-get update && \
    apt-get install -y nginx

# Generate SSL/TLS Certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/aouhadou.key \
    -out /etc/ssl/certs/aouhadou.crt \
    -subj="/C=MA/ST=khouribga/L=khouribga/O=1337 School/OU=aouhadou/CN=aouhadou.42.fr"

# Copy Certificate Generation Script
COPY ./tools/certs.sh /tmp/certs.sh

# Set Execute Permissions for the Script
RUN chmod +x /tmp/certs.sh

# Copy NGINX Configuration
COPY ./conf/default /etc/nginx/sites-available/default

EXPOSE  443

# Set NGINX as the Entry Point
ENTRYPOINT ["nginx", "-g", "daemon off;"]
