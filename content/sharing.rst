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


Here we saw that we use the python base image (for instance from https://hub.docker.com/_/python) - in addtion we install some more software - numpy, and we bind mount a custom file into the image. 

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

### Top 10 Base images
There is most probably a very nice base image for most of your needs. If you google e.g. "best docker containers" you will find a list similar to this one: 

1. [Alpine](https://hub.docker.com/_/alpine) (slim Linux OS)
2. [BusyBox](https://hub.docker.com/_/busybox) (slim Linux OS with many common Linux utilities)
3. [Nginx](https://hub.docker.com/_/nginx) (web server)
4. [Ubuntu](https://hub.docker.com/_/ubuntu) (Linux OS)
5. [Python](https://hub.docker.com/_/python)
6. [PostGreSQL](https://hub.docker.com/_/postgres) (database)
7. [Redis](https://hub.docker.com/_/redis) (database) 
8. [Apache httpd](https://hub.docker.com/_/httpd) (web server)
9. [Node](https://hub.docker.com/_/node) (web development)
10. [MongoDB](https://hub.docker.com/_/mongo) (database) 
11. [MySQL](https://hub.docker.com/_/mysql) (database) 
12. [Memcached](https://hub.docker.com/_/memcached)
13. [Traefik](https://hub.docker.com/_/traefik)
14. [MariaDB](https://hub.docker.com/_/mariadb) (database) 
15. [RabbitMQ](https://hub.docker.com/_/rabbitmq) (message broker, for instance between web application and backend)
    
In addition I will add one of my favourites: 
16. [Jupyter datascience-notebook](https://hub.docker.com/r/jupyter/datascience-notebook)

Once you have found a suitable base image, you must think about what version to chose. You will see that each image has a selection of different versions, so which should you chose? More on that next. 

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
