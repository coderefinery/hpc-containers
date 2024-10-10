Sharing reproducible containers
===============================

.. objectives::

  - Know about **good practices** for creating reproducible containers
  - Know about some **popular services** to share container definition files and images


Reuse
-----

As we have learned, building a container means that you pack the OS and all
the applications you need into a file. We have also learned that typically we
don't do everything from scratch, we **build upon base containers**.

This means that when building containers we try to:

- Use available base containers
- Add customisation on top of that

An :doc:`example <building_images>` was using an official python image for our python container:

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


Here we use a `python base image <https://hub.docker.com/_/python>`_ and in addition we install some more
software: numpy (and we bind mount a custom file into the image).

Building upon base-images is used extensively: The python image is not just python, it is again based on an another image, which itself is based on another image, and so on.

To find the image dependency, you will need to do a bit of detective work, finding the image in a registry, and inspecting its Dockerfile which hopefully is linked from the registry. If there is no Dockerfile linked from the registry page, you may be out of luck. 

Example image dependency 
+++++++++++++++++++++++++

Let's check the `Dockerhub python registry <https://hub.docker.com/_/python>`_. We can click on the link of the latest bookworm tag (see DockerHub python tab below) which leads us to its `Dockerfile on Github <https://github.com/docker-library/python/blob/7c8595e8e2b1c8bca0b6d9d146675b94c2a37ec7/3.13/bookworm/Dockerfile>`_  (as seen in the Dockerfile python tab). 

.. tabs::

   .. tab:: DockerHub python

      .. figure:: img/dockerhub_python.png

   .. tab:: Dockerfile python

      .. figure:: img/dockerfile_python_image.png

Inspecting this Dockerfile, we see that it again is based on a another image, namely ``buildpack-deps:bookworm``. 

We can do the same exercise for the image ``buildpack-deps:bookworm`` by finding the image in a registry like Dockerhub, navigating to the Dockerfile linked from that registry, and so on. 




After all that this is the image dependency tree we find for the python docker image: 

.. code-block::

   --> From: python:latest
     --> FROM: buildpack-deps:bookworm
       --> FROM buildpack-deps:bookworm-scm
         --> FROM buildpack-deps:bookworm-curl
           --> FROM debian:bookworm
             --> FROM scratch



.. admonition:: Take-away message

  Check if there is a suitable official base image for the applications you need, and build upon that.



  

Popular base images
+++++++++++++++++++

There probably exists a base image for your need, almost whatever it is. If you
web-search e.g. "best docker containers" you will find useful lists of popular
ones. Here is a customised selection of such a list - with some images we find
very useful:

- `Alpine <https://hub.docker.com/_/alpine>`_ (slim Linux OS)

- `BusyBox <https://hub.docker.com/_/busybox>`_ (slim Linux OS with many common Linux utilities)

- `Nginx <https://hub.docker.com/_/nginx>`_ (web server)

- `Ubuntu <https://hub.docker.com/_/ubuntu>`_ (Linux OS)

- `Python <https://hub.docker.com/_/python>`_

- `PostGreSQL <https://hub.docker.com/_/postgres>`_ (database)

- `Node <https://hub.docker.com/_/node>`_ (web development)

- `MySQL <https://hub.docker.com/_/mysql>`_ (database)

- `Jupyter datascience-notebook <https://hub.docker.com/r/jupyter/datascience-notebook>`_

Once you have found a suitable base image, you must think about what version to
chose. You will see that each image has a selection of different versions, so
which should you chose? We will explore this in the next section.


Be specific
-----------

One of the main objectives of using images is that the users gets exactly what
they expect, and everything should just work. The container is after all
self-contained!

During development you might want to have "latest" versions of software.  But
"latest" is a moving target: "latest" today is not the same as "latest" in 2
years.  And now you can get into problems! Maybe the latest version of your
base image is not compatible with the other software the image has included.
Or which you are including. This can spoil the party massively!


.. admonition:: Take-away message

  When sharing/publishing a container, try to be as specific as you can! Always specify software versions.


Taking our python image as an example, a more future-proof definition file would specify the base image version as well as the numpy version. Compare these two:

.. tabs::

   .. tab:: With specific versions

      .. code-block:: singularity
         :emphasize-lines: 2, 12

         Bootstrap: docker
         From: python:3.12.7-bookworm

         %files
             summation.py /opt

         %runscript
             echo "Got arguments: $*"
             exec python /opt/summation.py "$@"

         %post
             pip install numpy==1.26.0

   .. tab:: Versions are not specified

      .. code-block:: singularity
         :emphasize-lines: 2, 12

         Bootstrap: docker
         From: python:latest

         %files
             summation.py /opt

         %runscript
             echo "Got arguments: $*"
             exec python /opt/summation.py "$@"

         %post
             pip install numpy


Further below we have an exercise where we can practice recognizing future
problems in container definition files.


Separate concerns
-----------------

Purpose
++++++++++

When creating you image definition file - have a think about what the image should contain based on what purpose it has. Do not be tempted to add software just because it is convenient for general use. 

For instance: an image that is used to run some specific scientific analysis on a specific input type of data may not need your favourite text editor inside. Or that extra python package just in case. Slim the image down to just what it needs for the purpose it fulfills. The benefit will be at least two-fold: the image will be lighter meaning it will be quicker to download and have smaller carbon-footprint. But in addition there is less software to potentially get into software dependency problems with. Another benefit: it will be clearer for the user what is the purpose of the image, and how to use it. 

Data
+++++++++++++++++++
The main purpose of a software image is exactly that - to provide software, not datasets. There are several reasons why it is not a good idea to include (potentially large) datasets, here are a few: 

- The image could become very heavy
- The data may better be stored in a suited data registry
- The data may be different from user to user
- The data may be sensitive and should only reside in a private and secure computing environment

Instead of shipping the data with the image, let the user bind mount it into the container. Check out the :doc:`Binding folders into your container lesson <binding_folders>` for details. 

Compare the two apptainer definition files and how to run the resulting ``my_container.sif`` container. The right tab also exemplifies bind-mounting a folder for output data, which is useful in order to access the resulting output data directly from the host server. 

.. tabs::

   .. tab:: Image including data

      .. code-block:: singularity
         :emphasize-lines: 6,10,16

         Bootstrap: docker
         From: python:3.9-slim

         %files
            process_data.py /app/process_data.py
            input_data /app/input_data

         %post
            mkdir /app/output_data
            chmod 777 /app/output_data

         %runscript
            python /app/process_data.py /app/input_data /app/output_data

         %help
            Usage: apptainer run --writable-tmpfs this_container.sif

   .. tab:: Image not including data - using bind-mounts

      .. code-block:: singularity
         :emphasize-lines: 9,15

         Bootstrap: docker
         From: python:3.9-slim

         %files
            process_data.py /app/process_data.py

         %post
            mkdir /app/output_data
            mkdir /app/input_data

         %runscript
            python /app/process_data.py /app/input_data /app/output_data

         %help
            Usage: apptainer run --bind /path/to/host/input:/app/input_data,/path/to/host/output:/app/output_data this_container.sif

Documentating your image
-----------------------------------
In the example above you can see that some documentation is added in the image itself under the ``%help`` block.  This is not only important for sharing, but also for yourself to help remember how to use the container. See more details in the :ref:`Adding documentation to your image <documentation>`. 


.. admonition:: Document your image

  Always add documentation to your image. 

  - Minimally how to use the container via the ``%help`` block
  - In addition author, version, description via the ``%label`` block


Use version control and public registries
-----------------------------------------

.. admonition:: Key practices

   - **Track the changes to the definition** file with version control. In practice: Put the definition file on GitHub or GitLab.
   - Make the container image findable by others. In practice: Put the image on a **public registry**.
   - **Make sure one can find and inspect the definition file** from the registry. In practice: Link the repo to the public registry.

In principle a definition file is enough to build a container image and in
theory we would not need to share pre-built images. But in practice it is very
**useful to share the pre-built image as well**. This is because:

- Building a container image can take time and resources.
- If we were not careful specifying versions, the image might not build again
  in the same way.
- Some dependencies might not be available anymore.

There are many popular services to share container images and almost every
big-tech company offers one:

- `Docker Hub <https://hub.docker.com/>`__: Default Docker registry with public/private repositories and CI/CD integration.
- `Google Container Registry (GCR) <https://cloud.google.com/container-registry>`__: GCP service, tightly integrated with Google Cloud services and Kubernetes.
- `Azure Container Registry (ACR) <https://azure.microsoft.com/en-us/services/container-registry/>`__: Fully managed, integrated with Azure services like AKS and DevOps.
- `Quay.io <https://quay.io/>`__: Red Hat service, security scanning, OpenShift/Kubernetes integration, public/private repositories.
- `JFrog Artifactory <https://jfrog.com/artifactory/>`__: Universal artifact repository supporting Docker and other formats, advanced security features.
- `Harbor <https://goharbor.io/>`__: Open-source registry, role-based access control, vulnerability scanning, and image signing.
- `DigitalOcean Container Registry <https://www.digitalocean.com/products/container-registry/>`__: Integrated with DigitalOcean Kubernetes.
- `GitLab Container Registry <https://docs.gitlab.com/ee/user/packages/container_registry/>`__: Built into GitLab, works seamlessly with GitLab CI/CD pipelines.

What many projects do (however, note the warning below):

- Track their container definition files in a public repository on GitHub or GitLab.
- From these repositories, they build the container images and push them to a public registry (above list).


.. warning::

   A public registry that is free today might not be free tomorrow. Make sure
   you have a backup plan for your images and make sure the image can still be
   found 5 years from now if the service provider changes their pricing model.

.. admonition:: Recommendation to "guarantee" long-term availability

   - There are no guarantees, however:
   - One of the most stable services is `Zenodo <https://zenodo.org/>`__ which
     is an excellent place to publish your container image as supporting
     material for a publication and also get a DOI for it. It is unlikely to
     change pricing for academic use.
   - Make sure to also publish the definition file with it.


It is possible to host both the definition file and the image on GitHub:

    - You don't need to host it yourself.
    - The image stays close to its sources and is not on a different service.
    - Anybody can inspect the recipe and how it was built.
    - Every time you make a change to the recipe, it builds a new image.
    - We can practice/demonstrate this in the exercise below.


Exercises
---------

.. exercise:: Exercise Sharing-1: Time-travel with containers

   Imagine the following situation: A researcher has written and published their research code which
   requires a number of libraries and system dependencies. They ran their code
   on a Linux computer (Ubuntu). One very nice thing they did was to publish
   also a container image with all dependencies included, as well as the
   definition file (below) to create the container image.

   Now we travel 3 years into the future and want to reuse their work and adapt
   it for our data. The container registry where they uploaded the container
   image however no longer exists. But luckily (!) we still have the definition
   file (below). From this we should be able to create a new container image.

   - Can you anticipate problems using the definition file here 3 years after its
     creation? Which possible problems can you point out?
   - Discuss possible take-aways for creating more reusable containers.

   .. tabs::

      .. tab:: Python project using virtual environment

         .. literalinclude:: sharing/bad-example-python.def
            :language: singularity
            :linenos:

         .. solution::

            - Line 2: "ubuntu:latest" will mean something different 3 years in future.
            - Lines 11-12: The compiler gcc and the library libgomp1 will have evolved.
            - Line 30: The container uses requirements.txt to build the virtual environment but we don't see
              here what libraries the code depends on.
            - Line 33: Data is copied in from the hard disk of the person who created it. Hopefully we can find the data somewhere.
            - Line 35: The library fancylib has been built outside the container and copied in but we don't see here how it was done.
            - Python version will be different then and hopefully the code still runs then.
            - Singularity/Apptainer will have also evolved by then. Hopefully this definition file then still works.
            - No help text.
            - No contact address to ask more questions about this file.
            - (Can you find more? Please contribute more points.)

            .. literalinclude:: sharing/bad-example-python.def
               :language: singularity
               :linenos:
               :emphasize-lines: 2, 11-12, 30, 33, 35

      .. tab:: C++ project

         This definition files has potential problems 3 years later. Further
         down on this page we show a better and real version.

         .. literalinclude:: sharing/bad-example-cxx.def
            :language: singularity
            :linenos:

         .. solution::

            - Line 2: "ubuntu:latest" will mean something different 3 years in future.
            - Lines 9: The libraries will have evolved.
            - Line 11: We clone a Git repository recursively and that repository might evolve until we build the container image the next time.
              here what libraries the code depends on.
            - Line 18: The library fancylib has been built outside the container and copied in but we don't see here how it was done.
            - Singularity/Apptainer will have also evolved by then. Hopefully this definition file then still works.
            - No help text.
            - No contact address to ask more questions about this file.
            - (Can you find more? Please contribute more points.)

            .. literalinclude:: sharing/bad-example-cxx.def
               :language: singularity
               :linenos:
               :emphasize-lines: 2, 9, 11, 18


.. exercise:: Exercise Sharing-2: Building a container on GitHub

   You can build a container on GitHub (using GitHub Actions) or GitLab (using
   GitLab CI) and host the image on GitHub/GitLab. This has the following
   advantages:

   - You don't need to host it yourself.
   - The image stays close to its sources and is not on a different service.
   - Anybody can inspect the recipe and how it was built.
   - Every time you make a change to the recipe, it builds a new image.

   If you want to try this out:

   - Take `this repository <https://github.com/bast/html2pdf>`_ as starting point and inspiration.
   - Don't focus too much on what this container does, but rather `how it is built <https://github.com/bast/html2pdf/tree/main/.github/workflows>`_.
   - To build a new version, one needs to send a pull request which updates
     the file ``VERSION`` and modifies the definition file.
   - Using this approach, try to build a very simple container definition
     directly on GitHub where the goal is to have both the definition file
     and the image file in the same place.
