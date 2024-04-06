Persistent Storage
==================

.. objectives::

   * Understand the importance of persistent storage in containerized environments.
   * Learn how to configure persistent storage for an Apptainer container to maintain data state between runs.
   * Develop the ability to effectively manage data persistence, enhancing the usability and flexibility of container deployments in HPC settings.

   This demo explains how to set up and use persistent storage with Apptainer containers. Persistent storage is crucial for applications that need to maintain data or state between runs, such as databases or applications that generate ongoing logs or results. This capability is essential for ensuring data is not lost when a container is stopped or restarted, which is especially important in research environments where data integrity and continuity are paramount.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic knowledge of filesystems and permissions on Linux.

Container technology typically encapsulates application environments and dependencies, but by default, any changes made inside the container can be lost when the container is stopped or destroyed. To prevent this, Apptainer allows you to bind host directories to the container, enabling the container to read from and write to persistent storage on the host system.

First, we will demonstrate creating a simple application that writes data to a file inside a container, then show how this data can be preserved using a host directory bound to the container.

.. codeblock:: bash

   # Create a directory on the host to serve as persistent storage
   mkdir -p /home/user/persistent_data
   
   # Example Apptainer definition file to use persistent storage
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y nano
       echo "Hello from Apptainer!" > /data/hello.txt
   
   %runscript
       echo "Modifying the data file..."
       echo "Another line added to the file." >> /data/hello.txt
       cat /data/hello.txt
   


.. codeblock:: bash

   # Build the container that interacts with persistent data
   apptainer build data_container.sif data.def


This block builds the ``data_container.sif`` from the ``data.def`` file, which includes a simple script to modify and display a data file stored in ``/data``.

.. codeblock:: bash
   
   # Run the container with the persistent storage directory bound
   apptainer run --bind /home/user/persistent_data:/data data_container.sif


This command mounts the ``/home/user/persistent_data`` directory from the host to the ``/data`` directory inside the container. This setup allows the container to read from and write to the persistent storage, ensuring that changes to the data file are maintained even after the container is stopped.

Summary
-------
In this tutorial, you've learned how to configure and use persistent storage with an Apptainer container. This practice is critical for applications that require data continuity, ensuring that valuable research data is not lost across container runs. By leveraging persistent storage, you can enhance the robustness and reliability of your containerized applications within the HPC environment.

