Resource Limits
===============

.. objectives::

   * Understand the importance of managing resource usage within containerized environments on a shared HPC cluster.
   * Learn to set specific CPU and memory limits on an Apptainer container.
   * Develop skills to optimize container performance while preventing resource contention among users.

   This demo demonstrates how to set resource limits on an Apptainer container, which is essential in a shared HPC environment to ensure fair usage and prevent any single user or job from monopolizing system resources. Managing these limits helps maintain system stability and improves overall cluster performance, especially during peak usage times.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * Basic understanding of system resources like CPU cores and memory.
   * Permissions to run resource-limited jobs on the HPC cluster.

Resource limits on containers are crucial in multi-user environments where careful resource management is needed to avoid performance degradation. This tutorial will show you how to configure these settings, which can help in running multiple containerized applications concurrently without impacting each other's performance.

First, we'll set up a simple Apptainer definition file that runs a resource-intensive task, and then apply CPU and memory limits to this container.

.. code-block:: bash

   # Example Apptainer definition file for a resource-intensive task
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y stress
   
   %runscript
       echo "Starting stress test..."
       stress --cpu 8 --io 4 --vm 2 --vm-bytes 256M --timeout 30s



.. code-block:: bash

   # Build the container for the stress test
   apptainer build stress_container.sif stress.def


This block builds the ``stress_container.sif`` from the ``stress.def`` file. It includes the ``stress`` tool, which is used to generate a controlled load on the system's resources to demonstrate the effects of CPU and memory limits.

.. code-block:: bash

   # Run the container with specific CPU and memory limits
   apptainer exec --apply-cgroups /path/to/cgroup_settings.json stress_container.sif


This command runs the ``stress_container.sif`` container with resource limits specified in a cgroups configuration file. This file (``cgroup_settings.json``) should contain JSON-formatted settings that define the CPU and memory limits for the container, like the following:

.. code-block:: json

   {
       "cpu": {
           "shares": 512
       },
       "memory": {
           "limit_in_bytes": "500M"
       }
   }


These settings restrict the container to using only a fraction of available CPU resources (``shares: 512``) and limit its memory usage to 500 MB. Adjust these values based on your cluster's policies and the specific requirements of your workload.

Summary
-------
In this tutorial, you've learned how to set resource limits for an Apptainer container using cgroups. This approach is vital for managing resource allocation on shared HPC clusters, ensuring that all users and applications can operate effectively without resource contention. By implementing these limits, you can optimize the performance and reliability of containerized applications in a shared environment.

