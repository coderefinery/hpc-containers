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
- 
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


Here we saw that we use the python base image from https://hub.docker.com/_/python - and then we in addition bind mount a custom file, and install numpy on top. 

- change OS
- add several base images
- pick and mix


1. Alpine 2. BusyBox 3. Nginx 4. Ubuntu 5. Python 6. PostGreSQL 7. Redis 8. Apache httpd 9. Node 10. MongoDB 11. MySQL 12. Memcached 13. Traefik 14. MariaDB 15. RabbitMQ
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
