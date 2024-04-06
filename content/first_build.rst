Building Your First Container
=============================

.. objectives::

   * Understand the basic concept and utility of containerization in HPC environments.
   * Learn to create an Apptainer container using a definition file.
   * Apply this knowledge to build reproducible computing environments.

   In this demo, you will learn how to build your first container using Apptainer, starting from a simple definition file. Containers are crucial for creating reproducible, portable, and scalable environments that are isolated from the underlying infrastructure. This hands-on example will guide you through the process of defining and building a basic container, which is a foundational skill in using containers effectively in high-performance computing.

.. prerequisites::

   * No prerequisites for following the demo


Building your first container is a significant milestone in adopting container technology for scientific computing. This demo is designed to provide you with the practical skills needed to create and manage these environments, which are critical for ensuring computational reproducibility and scalability across different HPC systems.

In this tutorial, you will start with a basic container definition file that specifies the operating system, applications, and environment settings to be included in the container. You will then use Apptainer to build the container, making it ready for deployment and execution on an HPC cluster.

.. code-block:: bash

   # Example definition file content for Apptainer
   Bootstrap: library
   From: alpine:latest
   
   %post
       apk add --no-cache python3 py3-pip
       pip3 install numpy
   
   %environment
       export PATH=/usr/local/bin:$PATH
       export LANG=C.UTF-8
   
   %runscript
       echo "Container built from the definition file is running!"
   
   # Save the above content into a file named 'mydefinition.def'
   
      
   
.. code-block:: bash

   # Build an Apptainer container from a definition file
   apptainer build mycontainer.sif mydefinition.def
   


This command constructs a container named 'mycontainer.sif' from the definition file 'mydefinition.def'. The ``.sif`` file format is a portable container format used by Apptainer. This step is essential as it compiles all the necessary components and software specified in your definition file into a single executable container.

Summary
-------
This lesson taught you how to build a basic container using Apptainer from a definition file. You've learned a critical skill in containerization, enabling you to create reproducible and portable environments for a wide range of scientific applications. This capability is foundational in leveraging the full potential of HPC resources while ensuring consistency across different computing environments.

