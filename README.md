# Inception
This document is a System Administration related exercise.

### Introduction (https://docs.docker.com/get-started/)

This project aims to broaden your knowledge of system administration by using Docker.

You will virtualize several Docker images, creating them in your new personal virtual
machine.

This project consists in having you set up a small infrastructure composed of different services under specific rules. 

![image](https://github.com/izzypt/Inception/assets/73948790/d3f35a1a-3b7a-4c5d-b40f-b597907e83e6 and https://www.educative.io/blog/docker-compose-tutorial)


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

# Why is Docker important?
Docker can package up applications along with their necessary operating system dependencies for easier deployment across environments. 

In the long run it has the potential to be the abstraction layer that easily manages containers running on top of any type of server, regardless of whether that server is on Amazon Web Services, Google Compute Engine, Linode, Rackspace or elsewhere.

https://www.fullstackpython.com/docker.html

# What is a container?

A container is a sandboxed process running on a host machine that is isolated from all other processes running on that host machine. To summarize, a container:

  - Is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI.
  - Can be run on local machines, virtual machines, or deployed to the cloud.
  - Is portable (and can be run on any OS).
  - Is isolated from other containers and runs its own software, binaries, configurations, etc.


# What is an image?

A running container uses an isolated filesystem. 

This isolated filesystem is provided by an image, and the image must contain everything needed to run an application - all dependencies, configurations, scripts, binaries, etc. 

The image also contains other configurations for the container, such as environment variables, a default command to run, and other metadata.

# What is the Docker Network

Docker networks provide a communication bridge between different Docker containers, allowing them to talk to each other securely. 

A Docker network enables isolated environments for containers, helping with better organization and management of containerized applications.

Here's a simple explanation:

  ### Isolation:
  - Docker containers running on the same network can communicate with each other, but they are isolated from containers on other networks.

  ### Default Bridge Network:
  
  - When you run a Docker container without specifying a network, it is connected to the default bridge network. 
  - Containers on the same bridge network can communicate with each other using IP addresses.

  ### User-Defined Networks:
  
  - Docker allows you to create custom, user-defined networks. 
  - Containers connected to the same custom network can communicate with each other using container names as hostnames.

  ### Scalability and Flexibility:
  
  - Docker networks make it easy to scale applications. 
  - For example, if you have a web application and a database, you can run them in separate containers on the same network.

  ### Container Discovery:
  
  - Containers on the same network can discover and communicate with each other using service names or container names as if they were hostnames.

  ### Security:
  
  - Docker networks provide a level of security by isolating communication between containers. Containers on different networks usually cannot communicate with each other directly.

  ### Bridge, Overlay, and Host Networks:
  
      - Docker supports various types of networks, including bridge networks (default), overlay networks for multi-host communication, and host networks where containers share the host's network stack.

  ### Network Drivers:
  
      - Docker supports different network drivers that determine how containers on a network communicate. 
      - The default is the bridge driver, but you can also use overlay, macvlan, and others based on your specific requirements.

In essence, Docker networks are a crucial part of managing and organizing containerized applications, providing a way for containers to communicate, share data, and work together in a controlled and secure manner. They contribute to the flexibility and scalability of containerized architectures.

# Web Servers
Web servers respond to Hypertext Transfer Protocol (HTTP) requests from clients and send back a response containing a status code and often content such as HTML, XML or JSON as well.

# Why are web servers necessary?
Web servers are the ying to the web client's yang. The server and client speak the standardized language of the World Wide Web. This standard language is why an old Mozilla Netscape browser can still talk to a modern Apache or Nginx web server, even if it cannot properly render the page design like a modern web browser can.

The basic language of the Web with the request and response cycle from client to server then server back to client remains the same as it was when the Web was invented by Tim Berners-Lee at CERN in 1989. Modern browsers and web servers have simply extended the language of the Web to incorporate new standards.

# Web server implementations
The conceptual web server idea can be implemented in various ways. The following web server implementations each have varying features, extensions and configurations.

The Apache HTTP Server has been the most commonly deployed web server on the Internet for 20+ years.

Nginx is the second most commonly used server for the top 100,000 websites and often serves as a reverse proxy for Python WSGI servers.

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

### Configuration File’s Structure

nginx consists of modules which are controlled by directives specified in the configuration file. 

Directives are divided into simple directives and block directives. 

A simple directive consists of the name and parameters separated by spaces and ends with a semicolon (;). 

A block directive has the same structure as a simple directive, but instead of the semicolon it ends with a set of additional instructions surrounded by braces ({ and }). 

If a block directive can have other directives inside braces, it is called a context (examples: events, http, server, and location).

Directives placed in the configuration file outside of any contexts are considered to be in the main context. The events and http directives reside in the main context, server in http, and location in server.

The rest of a line after the # sign is considered a comment.


### Serving Static Content

An important web server task is serving out files (such as images or static HTML pages). You will implement an example where, depending on the request, files will be served from different local directories: /data/www (which may contain HTML files) and /data/images (containing images). This will require editing of the configuration file and setting up of a server block inside the http block with two location blocks.

First, create the /data/www directory and put an index.html file with any text content into it and create the /data/images directory and place some images in it.

Next, open the configuration file. The default configuration file already includes several examples of the server block, mostly commented out. For now comment out all such blocks and start a new server block:
  ```
  http {
      server {
      }
  }
  ```
Generally, the configuration file may include several server blocks distinguished by ports on which they listen to and by server names. Once nginx decides which server processes a request, it tests the URI specified in the request’s header against the parameters of the location directives defined inside the server block.

Add the following location block to the server block:
 ```
location / {
    root /data/www;
}
 ```
This location block specifies the “/” prefix compared with the URI from the request. For matching requests, the URI will be added to the path specified in the root directive, that is, to /data/www, to form the path to the requested file on the local file system. If there are several matching location blocks nginx selects the one with the longest prefix. The location block above provides the shortest prefix, of length one, and so only if all other location blocks fail to provide a match, this block will be used.

Next, add the second location block:
 ```
location /images/ {
    root /data;
}
 ```
It will be a match for requests starting with /images/ (location / also matches such requests, but has shorter prefix).

The resulting configuration of the server block should look like this:

 ```
server {
    location / {
        root /data/www;
    }

    location /images/ {
        root /data;
    }
}
 ```

This is already a working configuration of a server that listens on the standard port 80 and is accessible on the local machine at http://localhost/. In response to requests with URIs starting with /images/, the server will send files from the /data/images directory. For example, in response to the http://localhost/images/example.png request nginx will send the /data/images/example.png file. If such file does not exist, nginx will send a response indicating the 404 error. Requests with URIs not starting with /images/ will be mapped onto the /data/www directory. For example, in response to the http://localhost/some/example.html request nginx will send the /data/www/some/example.html file.

To apply the new configuration, start nginx if it is not yet started or send the reload signal to the nginx’s master process, by executing:
 ```
nginx -s reload
 ```
In case something does not work as expected, you may try to find out the reason in access.log and error.log files in the directory /usr/local/nginx/logs or /var/log/nginx.

### Setting Up a Simple Proxy Server
One of the frequent uses of nginx is setting it up as a proxy server, which means a server that receives requests, passes them to the proxied servers, retrieves responses from them, and sends them to the clients.

We will configure a basic proxy server, which serves requests of images with files from the local directory and sends all other requests to a proxied server. In this example, both servers will be defined on a single nginx instance.

First, define the proxied server by adding one more server block to the nginx’s configuration file with the following contents:
```
server {
    listen 8080;
    root /data/up1;

    location / {
    }
}
```
This will be a simple server that listens on the port 8080 (previously, the listen directive has not been specified since the standard port 80 was used) and maps all requests to the /data/up1 directory on the local file system. Create this directory and put the index.html file into it. Note that the root directive is placed in the server context. Such root directive is used when the location block selected for serving a request does not include its own root directive.

Next, use the server configuration from the previous section and modify it to make it a proxy server configuration. In the first location block, put the proxy_pass directive with the protocol, name and port of the proxied server specified in the parameter (in our case, it is http://localhost:8080):

```
server {
    location / {
        proxy_pass http://localhost:8080;
    }

    location /images/ {
        root /data;
    }
}
```
We will modify the second location block, which currently maps requests with the /images/ prefix to the files under the /data/images directory, to make it match the requests of images with typical file extensions. The modified location block looks like this:
```
location ~ \.(gif|jpg|png)$ {
    root /data/images;
}
```
The parameter is a regular expression matching all URIs ending with .gif, .jpg, or .png. A regular expression should be preceded with ~. The corresponding requests will be mapped to the /data/images directory.

When nginx selects a location block to serve a request it first checks location directives that specify prefixes, remembering location with the longest prefix, and then checks regular expressions. If there is a match with a regular expression, nginx picks this location or, otherwise, it picks the one remembered earlier.

The resulting configuration of a proxy server will look like this:
```
server {
    location / {
        proxy_pass http://localhost:8080/;
    }

    location ~ \.(gif|jpg|png)$ {
        root /data/images;
    }
}
```
This server will filter requests ending with .gif, .jpg, or .png and map them to the /data/images directory (by adding URI to the root directive’s parameter) and pass all other requests to the proxied server configured above.

To apply new configuration, send the reload signal to nginx as described in the previous sections.

There are many more directives that may be used to further configure a proxy connection.
