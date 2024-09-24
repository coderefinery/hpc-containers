# Sharing reproducible containers

:::{objectives}
- Objective 1 - Know of some key best practices for creating reproducible containers
- Objective 2 - Know of some common version control services
- Objective 3 - ...
:::


## Reuse
(work in progress - Maiken working on this part)

- Use available base containers
- Add your customisation on top of that

As we have learned, building a container means that you pack the OS and all the applications you need into it. We have also learned that we typically we do not do everything from scratch, we build upon base containers.

An example was using an official python image for our python container https://coderefinery.github.io/hpc-containers/building_images/

.. code-block:: singularity

   Bootstrap: docker
   From: python:latest

   %files
       summation.py /opt

   %runscript
       echo "Got arguments: $*"
       exec python /opt/summation.py "$@"

   %post
       pip install numpy


Here we saw that we use the python base image from https://hub.docker.com/_/python - in addtion we install some more software - numpy, and we bind mount a custom file into the image. 

The python image is not just python, it is again based on an another image (```FROM buildpack-deps:bookworm```) , which it self can be based on another image and so on. We can trail though the Dockerfiles hopefully linked to via the image registrery page and we find the following dependency:

.. figure:: img/dockerfile_python_image.png

Image dependency

```
Our python image
   --> From: python:latest
     --> FROM: buildpack-deps:bookworm
       --> FROM buildpack-deps:bookworm-scm
         --> FROM buildpack-deps:bookworm-curl
          --> FROM debian:bookworm
  ```


.. admonition:: Take-away message
Check if there is a suitable official base image for the applications you need, and build upon that. 

## Top 10 Base images
1. Alpine (slim Linux OS)
2. BusyBox (slim Linux OS with many common Linux utilities)
3. Nginx (web server)
4. Ubuntu (Linux OS)
5. Python
6. PostGreSQL (database)
7. Redis (database) 
8. Apache httpd (web server)
9. Node (web development)
10. MongoDB (database) 
11. MySQL (database) 
12. Memcached
13. Traefik
14. MariaDB (database) 
15. RabbitMQ (message queue, for instance between web application and backend)
    
Read more at: https://analyticsindiamag.com/top-ai-tools/top-docker-containers/


## Be specific
(work in progress)

- Use specific software version of everything
- Show file with/without software versions and explain behaviour in both cases


## Separate concerns
(work in progress)
- Only include things that are related to the computation and are general
- Input-data is typically not general
- User specific configuration 
 
## Use version control and public registries
- GitLab/GitHub for definition files
- Public registry for pre-built images
- Link the repo to the public registry

## Exercise

(work in progress)
