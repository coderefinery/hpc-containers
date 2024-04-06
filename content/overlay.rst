Overlay File Systems
====================

.. objectives::

   * Understand the concept and utility of overlay file systems in container technology.
   * Learn how to use overlay file systems to modify contents within an Apptainer container at runtime.
   * Develop the ability to dynamically alter container environments, enhancing flexibility for computational tasks.

   This demo explains the use of overlay file systems with Apptainer containers. Overlay file systems allow modifications to a container's file system during runtime without altering the base image. This capability is crucial for scenarios where temporary changes are needed for a session or when permissions restrict modifications to the container's base image.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * A basic container already available for modification.
   * Understanding of file system structures and permissions.

Overlay file systems in containers are particularly useful in multi-user environments like HPC systems, where users may need to experiment with different configurations without affecting the original container setup. By using overlays, users can ensure that their modifications are temporary and do not impact other users.

First, we'll set up a simple container with a base configuration, and then demonstrate how to use an overlay to modify its contents at runtime.

.. codeblock:: bash

   # Example Apptainer definition file for a basic container
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y curl
       mkdir /app
       echo "Hello from the base container!" > /app/message.txt
   
   %runscript
       cat /app/message.txt
   


.. codeblock:: bash

   # Build the base container
   apptainer build base_container.sif base.def


This block constructs the ``base_container.sif`` from the ``base.def`` definition file, which includes installing basic utilities and creating an initial message file in the ``/app`` directory.

.. codeblock:: bash

   # Create a temporary overlay directory on the host
   mkdir -p /home/user/my_overlay/upper /home/user/my_overlay/work

   # Example command to run the container with an overlay
   apptainer run --overlay /home/user/my_overlay/upper:/home/user/my_overlay/work:rw base_container.sif


This command runs ``base_container.sif`` with an overlay file system. The overlay consists of an upper directory (``/home/user/my_overlay/upper``) where changes are written, and a work directory (``/home/user/my_overlay/work``) that is used by the overlay file system to manage these changes.

Inside the container, you can modify ``/app/message.txt`` or add new files. These changes will appear in the upper directory on the host, demonstrating how overlays allow for runtime modifications without altering the original container image.

Summary
-------
In this tutorial, you've learned how to use overlay file systems with Apptainer to dynamically modify container contents at runtime. This technique is invaluable for testing, development, and computational experiments in HPC environments, allowing users to tailor their environments temporarily without impacting the stability and integrity of the base container. This flexibility greatly enhances the usability and adaptability of containerized applications in research and production settings.

