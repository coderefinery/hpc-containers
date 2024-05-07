Intro to containers (on HPC)
============================

.. objectives::

   * Understand the basic logic and terms behind container technology
   * Learn about the possible use cases for containers on HPC clusters

What even is a container?
-------------------------

Containers take their name from shipping containers:

.. figure:: https://upload.wikimedia.org/wikipedia/commons/3/36/Shipping_container%2C_Bellarena_-_geograph.org.uk_-_1859736.jpg

   Figure 1: A shipping container in its natural habitat

This analogue is based on the idea is that containers have a barrier
between the insides of the container and outside of the container.
This makes shipping them between ports easy.

Based on this analogue one might think that the container is just a
storage format. It is that as well: containers are stored in container
images (more on this in a later chapter).

Instead it is a way of running **an application in a self-contained
environment with all the tools that this specific application needs**.

More traditional container launchers like Docker, Podman and Kubernetes
also manage containers' resource usage, networking and various other aspects.
When using Apptainer, we do not need to worry about these features.

.. admonition:: More technical information on how traditional containers work
   :class: dropdown

   Traditional containers use
   `linux namespaces <https://en.wikipedia.org/wiki/Linux_namespaces>`__
   when they implement various features. These features include:

   - **Creating a separate process identifier (PID) namespace:**
     This means that process id's are not shared in the container and on
     the host.
   - **Creating a virtual network for the containers:**
     Container runtimes such as docker often create virtual network
     interfaces that the containers can use to communicate like actual
     virtual machines.
   - **Limiting container resources:**
     Container runtimes usually limit container resource usage
     (CPU usage, RAM usage) via Linux control groups (cgroups).

   Apptainer does none of these as it is meant to be run as a normal
   user and not as a superuser.

   Apptainer does use
   `user namespaces <https://apptainer.org/docs/user/latest/security.html#setuid-user-namespaces>`__
   for launching the container without giving the user additional privileges.


Let's consider the following case:

1. User installs and runs an application on a their home computer
2. They want to run the exact same application on their HPC cluster
3. The operating system / available software is different on the HPC cluster
4. Even if the program runs, it is necessarily not the **exact same program** as operating system has changed

.. figure:: img/normal_application.png

   Figure 2: Without containers, your program uses libraries from the host system

With containers the user would run the exact same container on both systems:

.. figure:: img/containerized_application.png

   Figure 3: With containers, your program uses libraries from the container image

The OS that launches the container is often called **the host** and
the container that is launched is called **a guest**.

.. admonition:: Key points to remember

   Containers are a way of launching applications in a self-contained
   environment with their own OS and program libraries.

   Filesystem used by containers is stored in container images. We'll talk
   more on container images later.

   Remember that the word container can refer to:
     - a running container with it's own environment
     - the container image that defines the container environment

   **Host** refers to the OS that launches the container, **guest**
   refers to the launched container.


What is the intended use case of Apptainer?
-------------------------------------------

Apptainer is meant for running complex applications in various systems such
as HPC systems in a reproducible and portable way.

There are many uses, but here are some example:

- Installing an application that has installation instructions and has been
  designed for specific operating system
- Creating a self-contained application that can be used as a part of your
  workflow in multiple different systems
- Creating a finished application that can be shared with your paper
- Reducing the amount of files needed to install an application by putting
  all files in the image (especially useful for Python environments)

Apptainer vs. Singularity
-------------------------

Singularity started as an open source project from Lawrence Berkeley National
Laboratory in 2015. In 2018 a company called Sylabs was founded to provide
commercial support for sites that use it.

In 2021 the project joined Linux Foundation and was renamed Apptainer.

Sylabs is still present and they maintain their own fork of the project called
SingulartyCE.

For more info, see the
`Singularity wikipedia article <https://en.wikipedia.org/wiki/Singularity_(software)>`__.

.. admonition:: Key points to remember

   Your site might be running Singularity, SingularityCE or Apptainer.

   In most cases the user interface is completely the same.

   If you're running ``singularity`` you can just rename any
   ``apptainer``-commands to ``singularity``.

Image sources
-------------

- Shipping container, Bellarena by Rossographer, `CC BY-SA 2.0 <https://creativecommons.org/licenses/by-sa/2.0>`__, via `Wikimedia Commons <https://commons.wikimedia.org/wiki/File:Shipping_container,_Bellarena_-_geograph.org.uk_-_1859736.jpg>`__


