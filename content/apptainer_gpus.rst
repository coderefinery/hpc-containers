Using GPUs with Apptainer
=========================

.. objectives::

   * Understand how to access and utilize GPU resources within an Apptainer container.
   * Learn to configure an Apptainer container for running applications that require GPU computation.
   * Develop skills to integrate GPU-based processing within containerized scientific workflows.

   This demo will guide you through the process of configuring and running an Apptainer container that utilizes GPUs, which is essential for high-performance computing tasks that require significant computational power, such as deep learning and large-scale data processing. Utilizing GPUs within containers can dramatically increase the efficiency and speed of these computations.

.. prerequisites::

   * Access to an HPC system with NVIDIA GPUs installed.
   * Apptainer installed on the HPC system.
   * Basic understanding of containerization and GPU computing principles.

GPUs are powerful tools for accelerating computational workloads, particularly those involving parallel processing tasks. However, accessing GPU resources within a containerized environment presents unique challenges, such as ensuring proper drivers are installed and accessible to the container. This demo will show you how to overcome these challenges to harness the full potential of GPU computing in an HPC setting.

First, we will create an Apptainer definition file that sets up an environment capable of utilizing NVIDIA GPUs.

.. code-block:: bash
   # Example Apptainer definition file for using NVIDIA GPUs
   Bootstrap: library
   From: nvcr.io/nvidia/cuda:11.0-base
   
   %post
       apt-get update && apt-get install -y cuda-samples-11-0
   
   %test
       cd /usr/local/cuda-11.0/samples/1_Utilities/deviceQuery
       make
       ./deviceQuery
   
   %environment
       export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
       export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64

   %runscript
       echo "Running CUDA device query..."
       ./deviceQuery
   

.. code-block:: bash
   # Build the GPU-enabled container
   apptainer build cuda_container.sif cuda.def
   

This block constructs the ``cuda_container.sif`` container from the ``cuda.def`` definition file, which includes the CUDA base image from NVIDIA's container registry. This setup ensures that the container will have access to the necessary CUDA libraries and tools to utilize GPU resources.

.. code-block:: bash
   # Run the container with GPU support
   apptainer exec --nv cuda_container.sif /bin/bash


This command executes the container with the `--nv` flag, which enables NVIDIA GPU support within the container. This flag is crucial as it allows the container to access the host's GPU resources, essential for running GPU-accelerated applications.

Summary
-------
In this tutorial, you have learned how to configure and use an Apptainer container to access and utilize GPU resources for high-performance computational tasks. This capability is particularly valuable in scientific computing, where the processing power of GPUs can be leveraged to accelerate research and development workflows. By integrating GPU support into your containers, you enhance their functionality and applicability in a wide range of HPC scenarios.
