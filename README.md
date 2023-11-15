# Inception
This document is a System Administration related exercise.

### Introduction

This project aims to broaden your knowledge of system administration by using Docker.
You will virtualize several Docker images, creating them in your new personal virtual
machine.

This project consists in having you set up a small infrastructure composed of different services under specific rules. 

![image](https://github.com/izzypt/Inception/assets/73948790/d3f35a1a-3b7a-4c5d-b40f-b597907e83e6)


The whole project has to be done in a virtual machine. 
- You have to use docker compose.
- Each Docker image must have the same name as its corresponding service.
- Each service has to run in a dedicated container.
- For performance matters, the containers must be built either from the penultimate stable version of Alpine or Debian.
- You also have to write your own Dockerfiles, one per service.
- The Dockerfiles must be called in your docker-compose.yml by your Makefile.
- It means you have to build yourself the Docker images of your project.
- It is then forbidden to pull ready-made Docker images, as well as using services such as DockerHub (Alpine/Debian being excluded from this rule).

- You then have to set up:

  • A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
  
  • A Docker container that contains WordPress + php-fpm (it must be installed and configured) only without nginx.
  
  • A Docker container that contains MariaDB only without nginx.
  
  • A volume that contains your WordPress database.
  
  • A second volume that contains your WordPress website files.
  
  • A docker-network that establishes the connection between your containers.
  
 - In your WordPress database, there must be two users, one of them being the administrator. The administrator’s username can’t contain admin/Admin or administrator/Administrator (e.g., admin, administrator, Administrator, admin-123, and so forth).

 - You have to configure your domain name so it points to your local IP address. This domain name must be login.42.fr.
   > For example, if your login is wil, wil.42.fr will redirect to the IP address pointing to wil’s website

# NGINX

nginx is one of the first services we need to set up. Let's talk about what it is and what we will use it for:


nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev. 

For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. 

According to Netcraft, nginx served or proxied 20.66% busiest sites in October 2023. Here are some of the success stories: Dropbox, Netflix, Wordpress.com, FastMail.FM.

### Basic HTTP server features
- Serving static and index files, autoindexing; open file descriptor cache;
- Accelerated reverse proxying with caching; load balancing and fault tolerance;
- Accelerated support with caching of FastCGI, uwsgi, SCGI, and memcached servers; load balancing and fault tolerance;
- Modular architecture. Filters include gzipping, byte ranges, chunked responses, XSLT, SSI, and image transformation filter. Multiple SSI inclusions within a single page can be processed in parallel if they are handled by proxied or - FastCGI/uwsgi/SCGI servers;
- SSL and TLS SNI support;
- Support for HTTP/2 with weighted and dependency-based prioritization;
- Support for HTTP/3.



