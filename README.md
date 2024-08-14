# Inception
This document is a System Administration related exercise.

# List of Contents

- [Introduction](#intro)
- [Why is Docker important?](#docker)
- [What is a container?](#docker)
- [What is an image?](#image)
- [Difference between Dockerfile and Docker Compose](#compose)
- [Docker vs VM (Virtual Machine)](#dockervsvm)
- [What are volumes](#volumes)
- [What is the Docker Network](#network)
- [Container Port vs Host Port](#ports)
- [Docker commands](#commands)
- [Web Servers](#web)
- [NGINX](#nginx)

# Another questions/problems I ran into later in development life

- [Multi-Stage builds and --target](#multistage)
- [Tagging and saving image](#tagandsave)

<a id="intro"></a>
# Introduction <h6>(https://docs.docker.com/get-started/ and  https://www.educative.io/blog/docker-compose-tutorial)</h6>

This project aims to broaden your knowledge of system administration by using Docker.

You will virtualize several Docker images, creating them in your new personal virtual
machine.

This project consists in having you set up a small infrastructure composed of different services under specific rules. 

![image](https://github.com/izzypt/Inception/assets/73948790/4c28b4ed-898d-4786-9e45-a091db86aa18)


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

<a id="docker"></a>
# Why is Docker important?
Docker can package up applications along with their necessary operating system dependencies for easier deployment across environments. 

In the long run it has the potential to be the abstraction layer that easily manages containers running on top of any type of server, regardless of whether that server is on Amazon Web Services, Google Compute Engine, Linode, Rackspace or elsewhere.

https://www.fullstackpython.com/docker.html

<a id="container"></a>
# What is a container?

A container is a sandboxed process running on a host machine that is isolated from all other processes running on that host machine. To summarize, a container:

  - Is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI.
  - Can be run on local machines, virtual machines, or deployed to the cloud.
  - Is portable (and can be run on any OS).
  - Is isolated from other containers and runs its own software, binaries, configurations, etc.

<a id="image"></a>
# What is an image?

A running container uses an isolated filesystem. 

This isolated filesystem is provided by an image, and the image must contain everything needed to run an application - all dependencies, configurations, scripts, binaries, etc. 

The image also contains other configurations for the container, such as environment variables, a default command to run, and other metadata.

<a id="compose"></a>
# Difference between Dockerfile and Docker Compose

The key difference between the Dockerfile and docker-compose is that the Dockerfile describes how to build Docker images, while docker-compose is used to run Docker containers.

The contents of a Dockerfile describe how to create and build a Docker image, while docker-compose is a command that runs Docker containers based on settings described in a docker-compose.yaml file.

<a id="dockervsvm"></a>
# Docker vs VM (Virtual Machine)

Docker containers and virtual machines are both ways of deploying applications inside environments that are isolated from the underlying hardware: 
 - The chief difference is the level of isolation.

Docker containers share many of their resources with the host system, they require fewer things to be installed in order to run. 

Containers share the same kernel on the same host. As a result, processes running inside containers are visible from the host system (given enough privileges for listing all).

Compared to a virtual machine, a container typically takes up less space and consumes less RAM and CPU time

In contrast, with a virtual machine, everything running inside the VM is independent of the host operating system, or hypervisor.

What’s fundamentally different with a virtual machine is that at start time, it boots a new, dedicated kernel for this VM environment, and starts a (often rather large) set of operating system processes. This makes the size of the VM much larger than a typical container that only contains the application.

<a id="volumes"></a>
#  What are volumes

Whenever we run a container based on an image ( e.g. running a database in container) and have generated some data, if we remove that container the data will no longer be accessible to us. 

The data gets removed with the container. And what if we want to preserve that data generated by running containers? Here’s where Docker Volumes comes in…

Docker volumes are a filesystem used in docker to persist data of a container independent of its life cycle. It helps us to persist or store either a file or a directory so that we can share it across multiple container or to create new containers from it.

For this reason, you need some way to have a mechanism for storing data.

There are 2 ways to make data persistent in docker:
  - volumes
  - bind mounts

In a Docker Compose file, you can distinguish between a named volume and a bind mount based on how you define the volume in the volumes section. 

Here are the key differences:

    Named Volume:

        When using a named volume, you define the volume directly under the volumes section without specifying a host path. Docker Compose will automatically create and manage the named volume.

        Example:

        yaml

    services:
      myservice:
        volumes:
          - my-named-volume:/path/in/container
    volumes:
      my-named-volume:

In this example, my-named-volume is a named volume.

Bind Mount:

    When using a bind mount, you define the volume under the volumes section with a host path specified before a colon (:), followed by the path in the container.

    Example:

    yaml

        services:
          myservice:
            volumes:
              - /host/path:/path/in/container

    In this example, /host/path is a bind mount.

Here's a more complete example demonstrating the use of both named volumes and bind mounts in a Docker Compose file:

```

version: '3'
services:
  myservice:
    image: myimage
    volumes:
      - my-named-volume:/path/in/container
      - /host/path:/another/path/in/container

volumes:
  my-named-volume:
```

In this example, my-named-volume is a named volume, and /host/path is a bind mount.

Remember that named volumes are managed by Docker, and you can inspect them using docker volume ls and docker volume inspect <volume_name>. Bind mounts, on the other hand, directly reference paths on the host machine.


<a id="network"></a>
# What is the Docker Network

Docker networks provide a communication bridge between different Docker containers, allowing them to talk to each other securely.

Example:

When I deploy two containers on the same docker network , in this case - mongo and mongo express- they can talk to each other only using the ***container name*** because they are in the same network. 

And the apps that run outside of Docker like this nodeJS, is gonna connect to them using localhost or the port number:

<img width="1184" alt="image" src="https://github.com/user-attachments/assets/5aa8f941-8f2a-4907-92a2-d34575da50b8">


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

Docker has 7 types of network, this video explains more about each one:

- https://www.youtube.com/watch?v=bKFMS5C4CG0

<a id="commands"></a>
# Docker commands

A list of commonly used docker comands:

  - ```docker run```: Create and start a new container from an image.

  - ```docker build```: Build a Docker image from a Dockerfile.

  - ```docker pull```: Pull an image or a repository from a registry.

  - ```docker push```: Push an image or a repository to a registry.

  - ```docker ps```: List running containers.

  - ```docker ps -a```: List all containers, including stopped ones.

  - ```docker exec```: Run a command inside a running container.

  - ```docker stop```: Stop one or more running containers.

  - ```docker start```: Start one or more stopped containers.

  - ```docker restart```: Restart one or more containers.

  - ```docker rm```: Remove one or more containers.

  - ```docker rmi```: Remove one or more images.

  - ```docker images```: List available images on the local system.

  - ```docker inspect```: Display detailed information about one or more containers, images, networks, or volumes.

  - ```docker-compose up```: Create and start containers defined in the docker-compose.yml file.

  - ```docker-compose down```: Stop and remove containers, networks, and volumes defined in the docker-compose.yml file.

  - ```docker network ls```: List Docker networks.

  - ```docker volume ls```: List Docker volumes.

### ```docker run``` vs ```docker exec```

  - docker run:
    - This command is used to create a new container from a Docker image and then run a command inside that container.
    - It's typically used to start new containers.
    - When you use docker run, Docker creates a new container based on the specified image and then executes the command you provide within that container. If the container is already running, docker run will start another instance of the specified image.

- docker exec:
  - This command is used to run a command inside an existing, running container.
  - It allows you to execute commands within a container that is already running.
  - Unlike docker run, which creates a new container instance, docker exec works on an existing container that has already been created and started.

- In summary, docker run is used to start new containers, while docker exec is used to execute commands within existing containers.

<a id="ports"></a>
# Container Port vs Host Port

In Docker, the concepts of container port and host port are key to understanding how network traffic is routed to your containerized applications:

- **Container Port**: This is the port number that your application inside the container listens to. It is defined within the Docker container.

- **Host Port**: This is the port number on the host machine (the physical or virtual machine running Docker) that is mapped to the container port. This allows external systems or users to access the application running inside the container.

When you run a Docker container, you can map a host port to a container port using the `-p` flag. 

For example, `-p 8080:80` maps port `8080` on the host to port `80` in the container. 

This means that if you access `http://localhost:8080` on the host machine, the request will be forwarded to the application running on port 80 inside the container.

<img width="1546" alt="image" src="https://github.com/user-attachments/assets/2835b119-899c-404e-b622-4b2cb496be11">


<a id="web"></a>
# Web Servers
Web servers respond to Hypertext Transfer Protocol (HTTP) requests from clients and send back a response containing a status code and often content such as HTML, XML or JSON as well.

# Why are web servers necessary?
Web servers are the ying to the web client's yang. The server and client speak the standardized language of the World Wide Web. This standard language is why an old Mozilla Netscape browser can still talk to a modern Apache or Nginx web server, even if it cannot properly render the page design like a modern web browser can.

The basic language of the Web with the request and response cycle from client to server then server back to client remains the same as it was when the Web was invented by Tim Berners-Lee at CERN in 1989. Modern browsers and web servers have simply extended the language of the Web to incorporate new standards.

# Web server implementations
The conceptual web server idea can be implemented in various ways. The following web server implementations each have varying features, extensions and configurations.

The Apache HTTP Server has been the most commonly deployed web server on the Internet for 20+ years.

Nginx is the second most commonly used server for the top 100,000 websites and often serves as a reverse proxy for Python WSGI servers.

<a id="nginx"></a>
# NGINX 

https://www.youtube.com/watch?v=iInUBOVeBCc&t=22s

nginx is one of the first services we need to set up. Let's talk about what it is and what we will use it for:
(https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms)

nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev. 

For a long time, it has been running on many heavily loaded Russian sites including Yandex, Mail.Ru, VK, and Rambler. 

According to Netcraft, nginx served or proxied 20.66% busiest sites in October 2023. Here are some of the success stories: Dropbox, Netflix, Wordpress.com, FastMail.FM.

![image](https://github.com/user-attachments/assets/2a271e65-2f83-4d3d-b5e7-87ff01433636)

![image](https://github.com/user-attachments/assets/4262c842-e855-49e9-b2db-1ac21fb7db1e)

![image](https://github.com/user-attachments/assets/ffa850a2-261b-4e0e-b0d6-9ffea5ed5beb)

![image](https://github.com/user-attachments/assets/e6c62875-59a6-4406-8769-9f0a0676265a)

![image](https://github.com/user-attachments/assets/7dba0477-5f88-409d-aad4-562e7e2eabbe)




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

How to create nginx config file -> https://www.youtube.com/watch?v=NEf3CFjN0Dg

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


<a id="multistage"></a>
# Multi-Stage builds and --target

The `--target` flag in Docker is used in the context of multi-stage builds within a Dockerfile. When you have a Dockerfile with multiple build stages, the `--target` option allows you to specify which stage you want to build up to.

### Multi-Stage Builds

In a multi-stage build, you can define multiple `FROM` instructions within a single Dockerfile. Each `FROM` instruction starts a new build stage, and you can use different base images or configurations for each stage. Typically, you might use one stage to build your application and another to package the final, optimized image.

### The `--target` Flag

The `--target` flag allows you to stop the build process at a specific stage and output the image created up to that point. This can be useful when you only want to build an intermediate stage for debugging or if you have different targets for development, testing, and production.

### Example

Here’s a simplified example Dockerfile with multi-stage builds:

```dockerfile
# Stage 1: Build
FROM golang:1.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp .

# Stage 2: Production Image
FROM alpine:latest AS prod_image
WORKDIR /app
COPY --from=builder /app/myapp .
CMD ["./myapp"]

# Stage 3: Debug Image
FROM alpine:latest AS debug_image
WORKDIR /app
COPY --from=builder /app/myapp .
RUN apk add --no-cache bash
CMD ["bash"]
```

In this example, there are three stages:
1. **builder**: Compiles the Go application.
2. **prod_image**: Copies the compiled binary from the builder stage to a lightweight Alpine image, creating a minimal production image.
3. **debug_image**: Similar to the production image, but includes a shell for debugging.

### Using the `--target` Flag

If you want to build the production image only, you would use the `--target` flag:

```bash
docker build --target prod_image -t myapp:prod .
```

- **`--target prod_image`**: Instructs Docker to build only up to the `prod_image` stage.
- **`-t myapp:prod`**: Tags the resulting image as `myapp:prod`.

Similarly, you could build the debug image like this:

```bash
docker build --target debug_image -t myapp:debug .
```

This flexibility allows you to have different build targets for various purposes (e.g., production, testing, debugging) within a single Dockerfile.

<a id="tagandsave"></a>

# Tagging and saving image

### Tagging the Image:

If you want this image to appear under a specific tag, you can tag it manually:

`sh
docker tag c400271e778d nexus.eigen.live/generative_service:<desired_tag>
`

Replace <desired_tag> with the tag name you prefer. After doing this, running docker images will show the image with the tag you've assigned.

### Saving the Image:

To save your Docker image to a `.tar` file, you can use the `docker save` command. This command exports the image into a tarball, which you can then transfer or store as needed.

Here’s how you can do it:

1. **Use `docker save` to Export the Image**

   Run the following command, replacing `<image_id>` with the ID of the image you want to save and `<file_name>.tar` with your desired filename:

   ```bash
   docker save -o <file_name>.tar <image_id>
   ```

   In your case, the command would be:

   ```bash
   docker save -o generative_service_image.tar c400271e778d
   ```

   This command will create a file named `generative_service_image.tar` in your current directory containing the image.

2. **Verify the Tarball**

   After saving the image, you can list the files in your directory to ensure that the tarball has been created:

   ```bash
   ls -l generative_service_image.tar
   ```

   You can also inspect the tarball to verify its contents:

   ```bash
   tar -tf generative_service_image.tar
   ```

### Additional Tips

- **Compress the Tarball**: If you want to save space, you can compress the tarball using `gzip`:

  ```bash
  gzip generative_service_image.tar
  ```

  This will create a `generative_service_image.tar.gz` file.

- **Load the Image from Tarball**: To load the saved image back into Docker on another system or after cleaning up, use:

  ```bash
  docker load -i <file_name>.tar
  ```

  For example:

  ```bash
  docker load -i generative_service_image.tar
  ```

This process allows you to export and import Docker images as needed, facilitating image transfer and backup.
