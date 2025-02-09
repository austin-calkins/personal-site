+++ 
draft = false
date = 2025-02-08T15:49:07-07:00
title = "Using Docker for Software builds"
description = "Docker can manage both software builds and deployments"
slug = ""
authors = ["Austin Calkins"]
tags = ["docker"]
categories = []
externalLink = ""
series = []
+++

Software development often requires consistent environments to ensure smooth builds across different machines. Docker provides a way to package dependencies and build processes into a container, making software compilation reproducible and portable. In this post, we'll explore how to use Docker to build software efficiently.

## Why Use Docker for Building Software?

### 1. **Consistency Across Environments**
By using Docker, you eliminate the "works on my machine" problem. A container ensures that dependencies, compilers, and configurations remain the same regardless of where the build runs.

### 2. **Dependency Management**
Instead of manually installing build tools on different systems, Docker allows you to define all dependencies in a single `Dockerfile`.

### 3. **Isolation**
Docker ensures that the build process doesn't interfere with the host system by running in an isolated container.

## Setting Up a Docker Build Environment

To demonstrate how Docker can be used to build software, let's examine the Dockerfile used to deploy this personal website built using hugo.


### Step1: Cloning the repository
cloning the respository will pull down all sources required to build and manage my personal site
```sh
git clone https://github.com/austin-calkins/personal-site.git
```

### Step 2: Creating a Dockerfile

This `Dockerfile` defines how the build environment is set up using hugo, and how to use nginx to serve the static site.

```Dockerfile
FROM hugomods/hugo:reg-base-0.143.1 AS builder

# Set the working directory inside the container
WORKDIR /src

# Copy the Hugo site files into the container
COPY . .

# Build the Hugo site
RUN hugo

# Use an Nginx image to serve the static files
FROM nginx:alpine

# Copy the built site from the builder stage
COPY --from=builder /src/public /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
```
Hugo generates a static site from all markdown provided and moves all generated markup in the public directory that can be served in many ways, in this case, copied and served from an nginx container.

### Step 3: Building and Running the Container

Run the following commands to build and execute the software inside the Docker container:

```sh
docker build -t personal-site .
docker run -p 80:80 personal-site
```

This will serve the hugo site with nginx and make the website accessible on port 80

navigate to http://localhost and the static site will load in the browse



## Best Practices for Using Docker in Software Builds

- **Use Multi-Stage Builds**: To reduce image size, separate the build and runtime environments.
- **Cache Dependencies**: Structure `Dockerfile` to leverage Docker’s layer caching.
- **Minimize Image Size**: Use minimal base images like `alpine` where possible.
- **Mount Source Code**: Use bind mounts for faster iteration during development.

## Conclusion

Using Docker to build software ensures consistency, isolation, and ease of dependency management. Whether compiling C++, Go, Python, or any other language, Docker provides a powerful way to streamline development and deployment workflows.

Happy coding! 🚀
