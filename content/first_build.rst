Building Your First Container
=============================

.. objectives::

   * Understand the basic concept and utility of containerization in HPC environments.
   * Learn to create an Apptainer container using a definition file.
   * Apply this knowledge to build reproducible computing environments.

   In this demo, you will learn how to build your first container using Apptainer, starting from a simple definition file. Containers are crucial for creating reproducible, portable, and scalable environments that are isolated from the underlying infrastructure. This hands-on example will guide you through the process of defining and building a basic container, which is a foundational skill in using containers effectively in high-performance computing.

.. prerequisites::

   * No prerequisites for following the demo


Building your first container is a significant first step to test the technology and make sure it works in the cluster(s) you use. This example is based on the typical case when you need to install and run a specific tool which cannot be easily installed by your HPC cluster admins. This can happen if certain tools are really tight to some specific system-wide dependencies (e.g. certain versions of libraries, compilers, operating system). 


For the sake of learning, assume that the three tools ``fortune``, ``cowsay``, and ``lolcat`` cannot be installed by your cluster admins, and have strict requirements that you cannot just install them by yourself without root privileges.


.. code-block:: bash

   # Example definition file content for Apptainer
   Bootstrap: docker
   From: ubuntu:20.04

   %post
       apt-get -y update
       apt-get -y install fortune cowsay lolcat

   %environment
       export LC_ALL=C
       export PATH=/usr/games:$PATH

   %runscript
       fortune | cowsay | lolcat

   # Save the above content into a file named 'mydefinition.def'
   

Next we need to build the container image.
   
.. code-block:: bash

   # Build an Apptainer container from a definition file
   apptainer build mycontainer.sif mydefinition.def
   


This command constructs a container named 'mycontainer.sif' from the definition file 'mydefinition.def'. The ``.sif`` file format is a portable container format used by Apptainer. This step is essential as it compiles all the necessary components and software specified in your definition file into a single executable container.

Summary
-------
This example showed you how to build a basic container using Apptainer from a definition file. You've learned a critical skill in containerization, enabling you to create reproducible and portable environments for a wide range of scientific applications. This capability is foundational in leveraging the full potential of HPC resources while ensuring consistency across different computing environments.


.. exercise:: Build a simple container and test it

   Build a simple container on your cluster. You do not have to use the example above. Test the following:
   1. Start a terminal shell on the container and run a command such as ``date``
   2. Test the `runscript` part for the container above. How do you run it and what is the output?
   3. Add the `%labels` and `%help` block and test them as explained in the "Building Apptainer Images" section
   4. Copy paste all terminal commands and output from the three point above into a text file that you can submit as homework.



