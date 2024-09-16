Workflow Integration
====================

.. objectives::

   * Understand the benefits of integrating container technology into HPC workflows.
   * Learn to integrate an Apptainer container into an existing workflow on an HPC system.
   * Develop the ability to streamline and standardize computational workflows using containers.

   This demo illustrates how to integrate Apptainer containers into an existing HPC workflow. Containers can encapsulate environments and dependencies, making workflows more reproducible and portable across different computational systems. This integration is particularly beneficial in HPC settings where consistency and scalability are critical.

.. prerequisites::

   * Access to an HPC system with Apptainer installed.
   * An existing workflow or application that will be containerized.
   * Basic knowledge of shell scripting and command line operations on Linux.

Integrating containers into HPC workflows involves encapsulating the application and its dependencies into a container, which can then be executed consistently across various environments. This process not only simplifies the deployment and management of applications but also enhances their portability and reproducibility.

Let’s start by creating an Apptainer definition file that encapsulates a typical scientific application, then proceed to integrate this container into a sample HPC workflow.

.. code-block:: bash

   # Create a directory for the workflow
   mkdir -p /home/user/hpc_workflow
   
   # Example Apptainer definition file for a scientific application
   Bootstrap: library
   From: ubuntu:20.04
   
   %post
       apt-get update && apt-get install -y python3 python3-pip
       pip3 install numpy scipy matplotlib
   
   %environment
       export PATH=/usr/local/bin:$PATH
   
   %runscript
       echo "Running the scientific application..."
       python3 -c "import numpy as np; import scipy; import matplotlib.pyplot as plt; x = np.linspace(0, 10, 100); y = np.sin(x); plt.plot(x, y); plt.savefig('/workflow/output/plot.png');"



.. code-block:: bash

   # Build the container for the scientific application
   apptainer build sci_app_container.sif sci_app.def


This block creates the ``sci_app_container.sif`` from the ``sci_app.def`` definition file. This container includes Python and popular scientific libraries, setting up an environment capable of running complex scientific computations.

.. code-block:: bash
   # Define a directory on the host for output
   mkdir -p /home/user/hpc_workflow/output

   # Run the container as part of the HPC workflow
   apptainer run --bind /home/user/hpc_workflow/output:/workflow/output sci_app_container.sif


This command runs the container and binds a directory from the host system (``/home/user/hpc_workflow/output``) to the container. This setup allows the container to output results directly to the host filesystem, integrating the containerized application's output with other components of the HPC workflow.

Summary
-------
In this tutorial, you've learned how to integrate an Apptainer container into an existing HPC workflow. By containerizing applications, you standardize the execution environment, reducing inconsistencies and enhancing reproducibility across different computational platforms. This practice is essential for maintaining the integrity and reliability of complex scientific workflows in high-performance computing environments.

